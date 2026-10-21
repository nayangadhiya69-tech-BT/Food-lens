import '../../../core/storage/app_prefs.dart';

/// Persistence contract for the selected app language.
///
/// Swap the implementation here (or in `core/di`) if language storage moves
/// to another backend later — UI code only depends on this interface.
abstract class LanguageRepository {
  /// Returns the persisted locale code, or `null` when the user has not
  /// explicitly chosen a language yet.
  String? loadLocaleCode();

  Future<void> saveLocaleCode(String code);
}

/// Default implementation backed by [SharedPreferences] via [AppPrefs].
class PrefsLanguageRepository implements LanguageRepository {
  const PrefsLanguageRepository();

  @override
  String? loadLocaleCode() => AppPrefs.localeCode;

  @override
  Future<void> saveLocaleCode(String code) => AppPrefs.setLocaleCode(code);
}
