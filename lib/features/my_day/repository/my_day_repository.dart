import '../model/food_product.dart';
import '../model/my_day_entry.dart';

/// Contract for the My Day data the feature needs: the food catalog to
/// pick from, and the entries saved for a given calendar day.
///
/// Implemented locally by [PrefsMyDayRepository] (SharedPreferences,
/// one JSON blob per date). A backend implementation can be swapped in
/// via DI without touching any screen or view model.
abstract class MyDayRepository {
  /// Products the user can pick for their day.
  Future<List<FoodProduct>> fetchCatalog();

  /// Entries saved for [date] (local calendar day); empty when none.
  Future<List<MyDayEntry>> fetchEntries(DateTime date);

  /// Replaces [date]'s entries atomically so items are never duplicated.
  /// Returns false when persistence failed.
  Future<bool> saveEntries(DateTime date, List<MyDayEntry> entries);
}
