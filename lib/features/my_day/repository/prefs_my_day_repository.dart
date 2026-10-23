import 'dart:convert';

import '../../../core/storage/app_prefs.dart';
import '../data/food_catalog_fixtures.dart';
import '../model/food_product.dart';
import '../model/my_day_entry.dart';
import 'my_day_repository.dart';

/// Local, date-scoped My Day persistence on top of SharedPreferences.
///
/// Entries are stored as one JSON array under `my_day_entries_<yyyy-MM-dd>`,
/// so today's data can never overwrite a previous day, and an app
/// restart restores exactly what was saved. Corrupt data degrades to an
/// empty day instead of crashing.
class PrefsMyDayRepository implements MyDayRepository {
  const PrefsMyDayRepository();

  static const String _keyPrefix = 'my_day_entries_';

  /// Storage key for one calendar day (local date, no time component).
  static String dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$_keyPrefix$y-$m-$d';
  }

  @override
  Future<List<FoodProduct>> fetchCatalog() async => FoodCatalogFixtures.all();

  @override
  Future<List<MyDayEntry>> fetchEntries(DateTime date) async {
    final raw = AppPrefs.getString(dateKey(date));
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(MyDayEntry.fromJson)
          .toList();
    } catch (_) {
      // Corrupt or legacy data: treat the day as empty, never crash.
      return const [];
    }
  }

  @override
  Future<bool> saveEntries(DateTime date, List<MyDayEntry> entries) async {
    final encoded = jsonEncode([for (final entry in entries) entry.toJson()]);
    return AppPrefs.setString(dateKey(date), encoded);
  }
}
