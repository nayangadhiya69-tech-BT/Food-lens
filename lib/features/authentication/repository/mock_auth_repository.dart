import '../model/auth_result.dart';
import 'auth_repository.dart';

/// Local, network-free authentication used until a real backend exists.
///
/// Behaviour:
/// * Never sends anything anywhere — the "code" is [kDemoOtpCode].
/// * Enforces a resend cooldown and a resend limit per session.
/// * Counts wrong verification attempts and restarts the session after
///   [maxFailedVerifies] failures.
///
/// [latency] and [clock] are injectable so tests run instantly and
/// deterministically.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    this.latency = const Duration(milliseconds: 400),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// Simulated processing time (set to [Duration.zero] in tests).
  final Duration latency;

  final DateTime Function() _clock;

  @override
  final String demoOtpCode = kDemoOtpCode;

  @override
  Duration get resendCooldown => const Duration(seconds: 30);

  @override
  int get maxResends => 3;

  @override
  int get maxFailedVerifies => 5;

  DateTime? _lastRequestedAt;
  int _resendCount = 0;
  int _failedVerifies = 0;

  @override
  Duration timeUntilResend() {
    final requestedAt = _lastRequestedAt;
    if (requestedAt == null) return Duration.zero;
    final remaining = resendCooldown - _clock().difference(requestedAt);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  bool get resendLimitReached => _resendCount >= maxResends;

  @override
  Future<OtpRequestOutcome> requestOtp({required String phone}) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    final isFirst = _lastRequestedAt == null;
    if (!isFirst) {
      if (resendLimitReached) return OtpRequestOutcome.limitReached;
      if (timeUntilResend() > Duration.zero) {
        return OtpRequestOutcome.coolingDown;
      }
      _resendCount++;
    }
    _lastRequestedAt = _clock();
    return OtpRequestOutcome.accepted;
  }

  @override
  Future<OtpVerifyOutcome> verifyOtp({
    required String phone,
    required String code,
  }) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    if (code.length != 6 || code.contains(RegExp(r'[^0-9]'))) {
      return OtpVerifyOutcome.incomplete;
    }
    if (code != demoOtpCode) {
      _failedVerifies++;
      if (_failedVerifies >= maxFailedVerifies) {
        // Restart the demo session so the user is never permanently stuck:
        // the resend path becomes available again.
        reset();
        return OtpVerifyOutcome.tooManyAttempts;
      }
      return OtpVerifyOutcome.mismatch;
    }
    return OtpVerifyOutcome.success;
  }

  @override
  void reset() {
    _lastRequestedAt = null;
    _resendCount = 0;
    _failedVerifies = 0;
  }
}
