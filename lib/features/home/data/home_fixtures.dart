import '../../history/data/history_fixtures.dart';
import '../../profile/data/profile_fixtures.dart';
import '../model/home_overview.dart';

/// Sample home content matching the HTML design.
/// Clearly demo data — not verified real-world information.
class HomeFixtures {
  HomeFixtures._();

  static HomeOverview overview({DateTime? now}) {
    final user = ProfileFixtures.user;
    return HomeOverview(
      userName: user.name,
      location: user.location,
      scansThisWeek: 12,
      flagsCaught: 4,
      languagesUsed: 3,
      recentScans: HistoryFixtures.sample(now: now).take(3).toList(),
    );
  }
}
