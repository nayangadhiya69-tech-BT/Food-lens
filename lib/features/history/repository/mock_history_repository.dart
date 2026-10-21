import '../data/history_fixtures.dart';
import '../model/scan_record.dart';
import 'history_repository.dart';

/// Local sample history. [empty] and [fail] exist for tests and for
/// exercising empty/error UI states without touching a network.
class MockHistoryRepository implements HistoryRepository {
  MockHistoryRepository({
    this.latency = const Duration(milliseconds: 350),
    this.empty = false,
    this.fail = false,
    this.fixedNow,
  });

  final Duration latency;
  final bool empty;
  final bool fail;

  /// Overrides "now" so fixtures are deterministic in tests.
  final DateTime? fixedNow;

  @override
  Future<List<ScanRecord>> fetchHistory() async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    if (fail) {
      throw StateError('Mock history failure');
    }
    if (empty) return const <ScanRecord>[];
    return HistoryFixtures.sample(now: fixedNow);
  }
}
