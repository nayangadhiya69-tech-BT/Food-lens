import '../data/home_fixtures.dart';
import '../model/home_overview.dart';
import 'home_repository.dart';

/// Local sample home content. [fail] exercises the error state in tests.
class MockHomeRepository implements HomeRepository {
  MockHomeRepository({
    this.latency = const Duration(milliseconds: 350),
    this.fail = false,
    this.fixedNow,
  });

  final Duration latency;
  final bool fail;
  final DateTime? fixedNow;

  @override
  Future<HomeOverview> fetchOverview() async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    if (fail) {
      throw StateError('Mock home failure');
    }
    return HomeFixtures.overview(now: fixedNow);
  }
}
