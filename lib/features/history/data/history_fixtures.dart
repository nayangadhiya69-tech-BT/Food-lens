import '../model/scan_record.dart';

/// Sample scan history matching the HTML design.
///
/// Timestamps are generated relative to [now] so the localized
/// Today / Yesterday / N-days-ago labels stay believable in demos and tests.
class HistoryFixtures {
  HistoryFixtures._();

  static List<ScanRecord> sample({DateTime? now}) {
    final base = now ?? DateTime.now();
    DateTime at(int daysAgo, int hour, int minute) {
      final day = DateTime(base.year, base.month, base.day)
          .subtract(Duration(days: daysAgo));
      return DateTime(day.year, day.month, day.day, hour, minute);
    }

    return [
      ScanRecord(
        id: 'scan-1',
        name: 'Patanjali Doodh Biscuits',
        emoji: '🍪',
        timestamp: at(0, 10, 42),
        flagCount: 3,
      ),
      ScanRecord(
        id: 'scan-2',
        name: 'Dahi — Plain Curd',
        emoji: '🥣',
        timestamp: at(1, 18, 15),
        flagCount: 0,
      ),
      ScanRecord(
        id: 'scan-3',
        name: 'Masala Instant Noodles',
        emoji: '🍜',
        timestamp: at(2, 13, 5),
        flagCount: 2,
      ),
      ScanRecord(
        id: 'scan-4',
        name: 'Amul Butter',
        emoji: '🧈',
        timestamp: at(2, 9, 20),
        flagCount: 1,
      ),
      ScanRecord(
        id: 'scan-5',
        name: 'Real Fruit Juice',
        emoji: '🧃',
        timestamp: at(4, 16, 30),
        flagCount: 0,
      ),
      ScanRecord(
        id: 'scan-6',
        name: 'Marie Gold Biscuits',
        emoji: '🍪',
        timestamp: at(6, 17, 40),
        flagCount: 1,
      ),
      ScanRecord(
        id: 'scan-7',
        name: 'Masala Chana Mix',
        emoji: '🥜',
        timestamp: at(9, 11, 10),
        flagCount: 2,
      ),
    ];
  }
}
