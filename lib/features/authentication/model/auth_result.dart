/// Typed outcomes for the demo authentication flow.
///
/// These are deliberately *not* API responses: no network call happens.
enum OtpRequestOutcome {
  /// A (demo) code request was accepted.
  accepted,

  /// The resend cooldown has not elapsed yet.
  coolingDown,

  /// The demo resend limit has been reached.
  limitReached,
}

enum OtpVerifyOutcome {
  /// Code matched the development demo code.
  success,

  /// Fewer than 6 digits entered.
  incomplete,

  /// Code did not match.
  mismatch,

  /// Too many wrong attempts — a new code must be requested.
  tooManyAttempts,

  /// A verification is already running (duplicate submit guard).
  inProgress,
}
