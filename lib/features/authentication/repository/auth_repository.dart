import '../model/auth_result.dart';

/// Development-only demo OTP.
///
/// No SMS is ever sent. This code is shown to the user inside a clearly
/// labelled demo notice on the OTP screen and only ever verified locally.
const String kDemoOtpCode = '123456';

/// Authentication contract.
///
/// The demo implementation is fully local. When a real backend exists,
/// implement this interface with API calls and register it in
/// `core/di/app_providers.dart` — no widget changes required.
abstract class AuthRepository {
  /// The demo OTP shown to the user (development only).
  String get demoOtpCode;

  /// Cooldown between demo code requests.
  Duration get resendCooldown;

  /// Maximum number of resends within one demo session.
  int get maxResends;

  /// Maximum wrong verification attempts before the session restarts.
  int get maxFailedVerifies;

  /// Remaining time until a resend is allowed.
  Duration timeUntilResend();

  /// Whether the resend limit has been reached.
  bool get resendLimitReached;

  Future<OtpRequestOutcome> requestOtp({required String phone});

  Future<OtpVerifyOutcome> verifyOtp({required String phone, required String code});

  /// Clears session counters (used on sign-out and after too many attempts).
  void reset();
}
