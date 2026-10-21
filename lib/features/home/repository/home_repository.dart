import '../model/home_overview.dart';

/// Contract for the home screen content.
abstract class HomeRepository {
  Future<HomeOverview> fetchOverview();
}
