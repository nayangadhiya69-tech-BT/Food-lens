import '../../history/model/scan_record.dart';

/// Aggregated home-screen content from the HTML design.
class HomeOverview {
  const HomeOverview({
    required this.userName,
    required this.location,
    required this.scansThisWeek,
    required this.flagsCaught,
    required this.languagesUsed,
    required this.recentScans,
  });

  final String userName;
  final String location;
  final int scansThisWeek;
  final int flagsCaught;
  final int languagesUsed;
  final List<ScanRecord> recentScans;
}
