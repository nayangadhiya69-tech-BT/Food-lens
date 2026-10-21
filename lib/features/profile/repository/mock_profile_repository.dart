import '../data/profile_fixtures.dart';
import '../model/app_user.dart';
import 'profile_repository.dart';

/// Local sample profile. [fail] exercises the error state in tests.
class MockProfileRepository implements ProfileRepository {
  MockProfileRepository({
    this.latency = const Duration(milliseconds: 300),
    this.fail = false,
  });

  final Duration latency;
  final bool fail;

  @override
  Future<AppUser> fetchProfile() async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    if (fail) {
      throw StateError('Mock profile failure');
    }
    return ProfileFixtures.user;
  }
}
