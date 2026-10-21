import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/features/authentication/model/auth_result.dart';
import 'package:foodlens/features/authentication/repository/auth_repository.dart';
import 'package:foodlens/features/authentication/repository/mock_auth_repository.dart';

void main() {
  const phone = '9876543210';

  late DateTime now;
  late MockAuthRepository repo;

  setUp(() {
    now = DateTime(2026, 1, 1, 10, 0, 0);
    repo = MockAuthRepository(
      latency: Duration.zero,
      clock: () => now,
    );
  });

  test('demo OTP code is the documented constant', () {
    expect(repo.demoOtpCode, kDemoOtpCode);
    expect(kDemoOtpCode, '123456');
  });

  test('first request is accepted and starts the cooldown', () async {
    expect(await repo.requestOtp(phone: phone), OtpRequestOutcome.accepted);
    expect(repo.timeUntilResend(), repo.resendCooldown);
  });

  test('request during cooldown returns coolingDown', () async {
    await repo.requestOtp(phone: phone);
    now = now.add(const Duration(seconds: 10));
    expect(
      await repo.requestOtp(phone: phone),
      OtpRequestOutcome.coolingDown,
    );
  });

  test('request after cooldown is accepted as a resend', () async {
    await repo.requestOtp(phone: phone);
    now = now.add(repo.resendCooldown);
    expect(await repo.requestOtp(phone: phone), OtpRequestOutcome.accepted);
    expect(repo.timeUntilResend(), repo.resendCooldown);
  });

  test('resend limit is enforced', () async {
    await repo.requestOtp(phone: phone);
    for (var i = 0; i < repo.maxResends; i++) {
      now = now.add(repo.resendCooldown);
      expect(await repo.requestOtp(phone: phone), OtpRequestOutcome.accepted);
    }
    now = now.add(repo.resendCooldown);
    expect(
      await repo.requestOtp(phone: phone),
      OtpRequestOutcome.limitReached,
    );
    expect(repo.resendLimitReached, isTrue);
  });

  test('correct code verifies successfully', () async {
    await repo.requestOtp(phone: phone);
    expect(
      await repo.verifyOtp(phone: phone, code: kDemoOtpCode),
      OtpVerifyOutcome.success,
    );
  });

  test('wrong code returns mismatch and counts the failure', () async {
    await repo.requestOtp(phone: phone);
    expect(
      await repo.verifyOtp(phone: phone, code: '000000'),
      OtpVerifyOutcome.mismatch,
    );
  });

  test('incomplete code returns incomplete', () async {
    expect(
      await repo.verifyOtp(phone: phone, code: '123'),
      OtpVerifyOutcome.incomplete,
    );
    expect(
      await repo.verifyOtp(phone: phone, code: '12345a'),
      OtpVerifyOutcome.incomplete,
    );
  });

  test('too many wrong attempts restarts the session', () async {
    await repo.requestOtp(phone: phone);
    OtpVerifyOutcome? last;
    for (var i = 0; i < repo.maxFailedVerifies; i++) {
      last = await repo.verifyOtp(phone: phone, code: '000000');
    }
    expect(last, OtpVerifyOutcome.tooManyAttempts);
    // Session reset: cooldown is gone and the next request is a fresh first.
    expect(repo.timeUntilResend(), Duration.zero);
    expect(repo.resendLimitReached, isFalse);
  });

  test('reset clears all counters', () async {
    await repo.requestOtp(phone: phone);
    await repo.verifyOtp(phone: phone, code: '000000');
    repo.reset();
    expect(repo.timeUntilResend(), Duration.zero);
    expect(repo.resendLimitReached, isFalse);
    expect(await repo.requestOtp(phone: phone), OtpRequestOutcome.accepted);
  });
}
