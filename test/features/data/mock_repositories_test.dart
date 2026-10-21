import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/features/history/repository/mock_history_repository.dart';
import 'package:foodlens/features/home/repository/mock_home_repository.dart';
import 'package:foodlens/features/profile/repository/mock_profile_repository.dart';

void main() {
  group('MockHistoryRepository', () {
    test('returns the sample fixtures in order', () async {
      final repo = MockHistoryRepository(
        latency: Duration.zero,
        fixedNow: DateTime(2026, 1, 20, 12),
      );
      final records = await repo.fetchHistory();

      expect(records, hasLength(7));
      expect(records.first.name, 'Patanjali Doodh Biscuits');
      expect(records.first.flagCount, 3);
      expect(records[1].isClear, isTrue);
      expect(records.last.id, 'scan-7');
    });

    test('empty variant returns no records', () async {
      final repo = MockHistoryRepository(
        latency: Duration.zero,
        empty: true,
      );
      expect(await repo.fetchHistory(), isEmpty);
    });

    test('fail variant throws', () async {
      final repo = MockHistoryRepository(
        latency: Duration.zero,
        fail: true,
      );
      expect(repo.fetchHistory, throwsStateError);
    });

    test('fixtures are JSON-round-trippable for a future API mapping', () async {
      final repo = MockHistoryRepository(latency: Duration.zero);
      final record = (await repo.fetchHistory()).first;
      expect(record.toJson()['name'], record.name);
    });
  });

  group('MockHomeRepository', () {
    test('overview matches the HTML demo content', () async {
      final repo = MockHomeRepository(
        latency: Duration.zero,
        fixedNow: DateTime(2026, 1, 20, 12),
      );
      final overview = await repo.fetchOverview();

      expect(overview.userName, 'Mahesh');
      expect(overview.location, 'Surat, Gujarat');
      expect(overview.scansThisWeek, 12);
      expect(overview.flagsCaught, 4);
      expect(overview.languagesUsed, 3);
      expect(overview.recentScans, hasLength(3));
    });

    test('fail variant throws', () async {
      final repo = MockHomeRepository(latency: Duration.zero, fail: true);
      expect(repo.fetchOverview, throwsStateError);
    });
  });

  group('MockProfileRepository', () {
    test('returns the demo user', () async {
      final repo = MockProfileRepository(latency: Duration.zero);
      final user = await repo.fetchProfile();

      expect(user.name, 'Mahesh');
      expect(user.phoneDigits, '9876543210');
      expect(user.location, 'Surat, Gujarat');
    });

    test('fail variant throws', () async {
      final repo = MockProfileRepository(latency: Duration.zero, fail: true);
      expect(repo.fetchProfile, throwsStateError);
    });
  });
}
