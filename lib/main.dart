import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/storage/app_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore persisted preferences (locale, demo session, onboarding,
  // health flags) before the first route is chosen by the splash screen.
  //
  // Fail-soft by design: if the platform channel is unavailable (stale hot
  // restart, unsupported platform, plugin not yet registered), the app runs
  // with in-memory defaults instead of crashing. Every AppPrefs getter
  // tolerates an uninitialized store: writes stay visible through the
  // session overlay and AppPrefs retries the store in the background.
  try {
    await AppPrefs.init();
  } on MissingPluginException catch (e) {
    debugPrint('SharedPreferences unavailable, using in-memory defaults: $e');
  } catch (e) {
    debugPrint('AppPrefs.init failed, using in-memory defaults: $e');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const FoodLensApp());
}
