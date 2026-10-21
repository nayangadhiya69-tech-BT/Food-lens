import 'package:flutter/widgets.dart';

import '../../../core/constants/app_locales.dart';
import '../repository/language_repository.dart';

/// Holds the app locale and notifies the whole tree on change so the UI
/// updates immediately — no restart, no re-login.
class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._repository)
      : _savedCode = _repository.loadLocaleCode();

  final LanguageRepository _repository;
  String? _savedCode;

  /// Explicitly chosen locale code, or `null` when still unset.
  String? get savedCode => _savedCode;

  /// Locale passed to MaterialApp; `null` lets the system locale resolve.
  Locale? get locale {
    final code = _savedCode;
    return code == null ? null : Locale(code);
  }

  /// The code that is effectively displayed right now: the saved choice,
  /// otherwise the device locale when supported, otherwise English.
  String get effectiveCode {
    final code = _savedCode;
    if (code != null && AppLocales.isSupported(code)) return code;
    final device =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return AppLocales.isSupported(device) ? device : AppLocales.fallbackCode;
  }

  bool isSelected(String code) => effectiveCode == code;

  Future<void> setLocale(String code) async {
    if (!AppLocales.isSupported(code)) return;
    if (_savedCode == code) return;
    _savedCode = code;
    notifyListeners();
    await _repository.saveLocaleCode(code);
  }
}
