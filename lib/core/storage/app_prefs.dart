import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over [SharedPreferences] for app-level preferences.
///
/// Only non-sensitive state is persisted: locale, onboarding completion,
/// the demo sign-in flag and locally chosen health flags.
/// Passwords and OTP codes are never stored.
class AppPrefs {
  AppPrefs._();

  static const String keyLocale = 'app_locale';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyDemoAuthenticated = 'demo_authenticated';
  static const String keyHealthFlags = 'health_flags';

  static SharedPreferences? _prefs;

  /// Restores persisted preferences. Must be awaited before the first
  /// route is chosen (called from `main()`).
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---- Locale (null = not explicitly chosen yet) ----

  static String? get localeCode => _prefs?.getString(keyLocale);

  static Future<bool> setLocaleCode(String code) async {
    return _prefs?.setString(keyLocale, code) ?? false;
  }

  // ---- Onboarding (profile setup) ----

  static bool get onboardingComplete =>
      _prefs?.getBool(keyOnboardingComplete) ?? false;

  static Future<bool> setOnboardingComplete(bool value) async {
    return _prefs?.setBool(keyOnboardingComplete, value) ?? false;
  }

  // ---- Demo session (local, replaceable by a real auth session later) ----

  static bool get demoAuthenticated =>
      _prefs?.getBool(keyDemoAuthenticated) ?? false;

  static Future<bool> setDemoAuthenticated(bool value) async {
    return _prefs?.setBool(keyDemoAuthenticated, value) ?? false;
  }

  /// Clears only the demo sign-in. Locale and health flags are kept.
  static Future<void> clearDemoSession() async {
    await setDemoAuthenticated(false);
  }

  // ---- Health flags (local-only preference from the design) ----

  static Set<String> get healthFlags =>
      (_prefs?.getStringList(keyHealthFlags) ?? const <String>[]).toSet();

  static Future<bool> setHealthFlags(Iterable<String> flags) async {
    return _prefs?.setStringList(keyHealthFlags, flags.toList()) ?? false;
  }
}
