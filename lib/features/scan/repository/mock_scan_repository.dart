import '../../../core/models/health_flag.dart';
import '../data/scan_fixtures.dart';
import '../model/scan_mode.dart';
import '../model/scan_result.dart';
import 'scan_repository.dart';

/// Local demo analysis. [fail] exercises the error state in tests.
class MockScanRepository implements ScanRepository {
  MockScanRepository({
    this.latency = const Duration(milliseconds: 400),
    this.fail = false,
  });

  final Duration latency;
  final bool fail;

  @override
  String get workingName => ScanFixtures.productName;

  @override
  Future<ScanResult> analyze({
    required ScanMode mode,
    required Set<HealthFlag> flags,
  }) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    if (fail) {
      throw StateError('Mock scan failure');
    }
    // "Condition flagged" counts the user's own selections, so the flag
    // step visibly feeds the result.
    return ScanFixtures.result(
      conditionFlagged: flags.where((flag) => !flag.isNone).length,
    );
  }
}
