import 'package:flutter/foundation.dart';

import '../../../core/constants/app_locales.dart';
import '../../../core/models/health_flag.dart';
import '../../../core/storage/app_prefs.dart';
import '../../language/view_model/locale_provider.dart';

/// State for the profile-setup screen (HTML screen 4):
/// preferred language + optional health flags.
///
/// Both are local-only preferences. Completing or skipping setup marks
/// onboarding complete — it never marks the user authenticated.
class SetupViewModel extends ChangeNotifier {
  SetupViewModel({required LocaleProvider localeProvider})
      : _localeProvider = localeProvider,
        selectedCode = localeProvider.effectiveCode,
        selectedFlags = HealthFlag.fromKeys(AppPrefs.healthFlags);

  final LocaleProvider _localeProvider;

  String selectedCode;
  Set<HealthFlag> selectedFlags;
  bool saving = false;

  bool _languageTouched = false;
  bool _flagsTouched = false;

  void selectLanguage(String code) {
    if (!AppLocales.isSupported(code) || code == selectedCode) return;
    _languageTouched = true;
    selectedCode = code;
    notifyListeners();
  }

  void toggleFlag(HealthFlag flag) {
    _flagsTouched = true;
    selectedFlags = HealthFlag.toggle(selectedFlags, flag);
    notifyListeners();
  }

  /// Continue button: the highlighted language becomes the explicit choice.
  Future<void> completeSetup() => _finish(alwaysPersistLanguage: true);

  /// Skip button: nothing extra is persisted unless the user touched a chip
  /// or card (an untouched language keeps resolving from the device locale).
  Future<void> skipSetup() => _finish(alwaysPersistLanguage: false);

  Future<void> _finish({required bool alwaysPersistLanguage}) async {
    if (saving) return;
    saving = true;
    notifyListeners();

    if (alwaysPersistLanguage || _languageTouched) {
      await _localeProvider.setLocale(selectedCode);
    }
    if (_flagsTouched) {
      await AppPrefs.setHealthFlags(HealthFlag.toKeys(selectedFlags));
    }
    await AppPrefs.setOnboardingComplete(true);

    saving = false;
    notifyListeners();
  }
}
