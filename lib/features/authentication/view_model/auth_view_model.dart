import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/storage/app_prefs.dart';
import '../../../core/utils/app_utils.dart';
import '../model/auth_result.dart';
import '../repository/auth_repository.dart';

/// Session state for the demo sign-in flow.
///
/// Lives at application scope so phone, resend countdown and attempt limits
/// survive navigation between the Login and OTP screens.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  Timer? _ticker;
  String _phone = '';

  bool _requestLoading = false;
  bool _verifyLoading = false;
  OtpVerifyOutcome? _verifyError;
  bool _signInComplete = false;
  AuthViewModel(this._repository);

  String get demoOtpCode => _repository.demoOtpCode;

  bool get hasRequestedCode => _phone.isNotEmpty;

  /// 10-digit phone for the current demo session (never persisted).
  String get phone => _phone;
  bool get requestLoading => _requestLoading;

  bool get resendLimitReached => _repository.resendLimitReached;

  bool get resendReady =>
      hasRequestedCode && resendSecondsLeft == 0 && !resendLimitReached;
  int get resendSecondsLeft => _repository.timeUntilResend().inSeconds;

  /// True right after a successful verification (drives one-shot navigation).
  bool get signInComplete => _signInComplete;
  OtpVerifyOutcome? get verifyError => _verifyError;

  bool get verifyLoading => _verifyLoading;

  /// Clears any verify error (e.g. when the user edits the code).
  void clearVerifyError() {
    if (_verifyError == null) return;
    _verifyError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Requests a demo code. Returns how the request was handled so the UI can
  /// decide to proceed to the OTP screen.
  Future<OtpRequestOutcome> requestOtp(String phoneDigits) async {
    if (_requestLoading) {
      // Duplicate submit guard: an identical request is already running.
      return OtpRequestOutcome.coolingDown;
    }
    final digits = phoneDigits.replaceAll(RegExp(r'[\s-]'), '');
    if (!AppUtils.isValidIndianMobile(digits)) {
      return OtpRequestOutcome.coolingDown;
    }
    _requestLoading = true;
    notifyListeners();

    _phone = digits;
    final outcome = await _repository.requestOtp(phone: digits);

    _requestLoading = false;
    _startTicker();
    notifyListeners();
    return outcome;
  }

  /// Ends the demo session: resets counters and clears the auth flag only.
  Future<void> signOut() async {
    _ticker?.cancel();
    _ticker = null;
    _phone = '';
    _requestLoading = false;
    _verifyLoading = false;
    _verifyError = null;
    _signInComplete = false;
    _repository.reset();
    await AppPrefs.clearDemoSession();
    notifyListeners();
  }

  /// Verifies the entered code locally. Never sends anything anywhere.
  Future<OtpVerifyOutcome> verify(String code) async {
    if (_verifyLoading) return OtpVerifyOutcome.inProgress;

    _verifyError = null;
    if (!AppUtils.isValidOtp(code)) {
      _verifyError = OtpVerifyOutcome.incomplete;
      notifyListeners();
      return OtpVerifyOutcome.incomplete;
    }

    _verifyLoading = true;
    notifyListeners();

    final outcome = await _repository.verifyOtp(phone: _phone, code: code);

    _verifyLoading = false;
    if (outcome == OtpVerifyOutcome.success) {
      _verifyError = null;
      _signInComplete = true;
      // Demo session flag only — no password or code is ever stored.
      await AppPrefs.setDemoAuthenticated(true);
    } else if (outcome == OtpVerifyOutcome.tooManyAttempts) {
      _verifyError = outcome;
    } else if (outcome != OtpVerifyOutcome.inProgress) {
      _verifyError = outcome;
    }
    notifyListeners();
    return outcome;
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecondsLeft <= 0) {
        timer.cancel();
      }
      notifyListeners();
    });
  }
}
