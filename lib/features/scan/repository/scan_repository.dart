import '../../../core/models/health_flag.dart';
import '../model/scan_mode.dart';
import '../model/scan_result.dart';

/// Data source for the scan flow (HTML screens 6–10).
///
/// Swap `MockScanRepository` for an API-backed implementation in
/// `app_providers.dart` when a backend exists — no screen changes.
abstract class ScanRepository {
  /// Product the capture matches, shown while the label is still being
  /// read. A real backend returns this from the match step; the mock
  /// knows it upfront.
  String get workingName;

  /// Reads the capture and returns everything the result screen shows.
  /// [flags] are the user's own preferences — they decide which of the
  /// label's conditions surface first, never what the label says.
  Future<ScanResult> analyze({
    required ScanMode mode,
    required Set<HealthFlag> flags,
  });
}
