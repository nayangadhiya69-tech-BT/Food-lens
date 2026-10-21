import 'package:flutter_test/flutter_test.dart';
import 'package:foodlens/core/storage/app_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPrefs.init();
  });

  group('locale', () {
    test('is null until explicitly chosen', () {
      expect(AppPrefs.localeCode, isNull);
    });

    test('persists the chosen code', () async {
      await AppPrefs.setLocaleCode('hi');
      expect(AppPrefs.localeCode, 'hi');

      // Simulate a cold start.
      await AppPrefs.init();
      expect(AppPrefs.localeCode, 'hi');
    });

    test('choosing a language never implies authentication', () async {
      await AppPrefs.setLocaleCode('gu');
      expect(AppPrefs.demoAuthenticated, isFalse);
      expect(AppPrefs.onboardingComplete, isFalse);
    });
  });

  group('session + onboarding', () {
    test('defaults are off', () {
      expect(AppPrefs.demoAuthenticated, isFalse);
      expect(AppPrefs.onboardingComplete, isFalse);
    });

    test('demo session persists across restarts', () async {
      await AppPrefs.setDemoAuthenticated(true);
      await AppPrefs.init();
      expect(AppPrefs.demoAuthenticated, isTrue);
    });

    test('clearDemoSession keeps locale and health flags', () async {
      await AppPrefs.setLocaleCode('hi');
      await AppPrefs.setHealthFlags(['diabetes']);
      await AppPrefs.setDemoAuthenticated(true);

      await AppPrefs.clearDemoSession();

      expect(AppPrefs.demoAuthenticated, isFalse);
      expect(AppPrefs.localeCode, 'hi');
      expect(AppPrefs.healthFlags, {'diabetes'});
    });

    test('onboarding flag is independent of auth', () async {
      await AppPrefs.setOnboardingComplete(true);
      expect(AppPrefs.onboardingComplete, isTrue);
      expect(AppPrefs.demoAuthenticated, isFalse);
    });
  });

  group('health flags', () {
    test('default is empty', () {
      expect(AppPrefs.healthFlags, isEmpty);
    });

    test('persists and restores a set', () async {
      await AppPrefs.setHealthFlags(['diabetes', 'cholesterol']);
      await AppPrefs.init();
      expect(AppPrefs.healthFlags, {'diabetes', 'cholesterol'});
    });

    test('replacing with empty clears the set', () async {
      await AppPrefs.setHealthFlags(['pregnancy']);
      await AppPrefs.setHealthFlags(const <String>[]);
      expect(AppPrefs.healthFlags, isEmpty);
    });
  });
}
