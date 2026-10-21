import 'package:flutter/widgets.dart';

/// Supported app locales and their display metadata.
///
/// All currently supported languages are LTR. Adding an RTL language later
/// only requires an ARB file — Flutter derives text direction from the locale.
class AppLocales {
  AppLocales._();

  /// Language codes supported by the app (ARB files in `lib/l10n`).
  static const List<String> supportedCodes = ['en', 'hi', 'gu'];

  /// [Locale] objects for MaterialApp's `supportedLocales`.
  static final List<Locale> supported =
      supportedCodes.map(Locale.new).toList(growable: false);

  /// Used whenever no locale has been chosen and the device locale is not
  /// supported.
  static const String fallbackCode = 'en';

  /// Short native-script labels for the compact language switcher
  /// (`EN / हि / ગુ`) from the HTML design. Deliberately not translated.
  static const Map<String, String> chipLabels = {
    'en': 'EN',
    'hi': 'हि',
    'gu': 'ગુ',
  };

  static bool isSupported(String code) => supportedCodes.contains(code);
}
