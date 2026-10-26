import '../../l10n/generated/app_localizations.dart';

/// Locally stored flag preference from the HTML design (profile-setup
/// screen and the scan flow): health conditions plus dietary flags such
/// as Jain / Swaminarayan. These are user selections stored on-device
/// only — they are not medical data sent anywhere.
enum HealthFlag {
  diabetes('diabetes'),
  bloodPressure('blood_pressure'),
  cholesterol('cholesterol'),
  pregnancy('pregnancy'),
  jain('jain'),
  swaminarayan('swaminarayan'),
  none('none');

  const HealthFlag(this.storageKey);

  /// Stable value persisted in [AppPrefs].
  final String storageKey;

  bool get isNone => this == HealthFlag.none;

  static HealthFlag? fromKey(String key) {
    for (final flag in values) {
      if (flag.storageKey == key) return flag;
    }
    return null;
  }

  static Set<String> toKeys(Iterable<HealthFlag> flags) =>
      flags.map((f) => f.storageKey).toSet();

  static Set<HealthFlag> fromKeys(Iterable<String> keys) {
    final result = <HealthFlag>{};
    for (final key in keys) {
      final flag = fromKey(key);
      if (flag != null) result.add(flag);
    }
    return result;
  }

  /// Single source of truth for chip selection rules:
  /// * "None of these" is mutually exclusive with every other flag;
  /// * any other toggle clears "None of these".
  static Set<HealthFlag> toggle(Set<HealthFlag> selected, HealthFlag flag) {
    if (flag.isNone) {
      return selected.contains(flag) ? <HealthFlag>{} : <HealthFlag>{flag};
    }
    final next = Set<HealthFlag>.from(selected)..remove(HealthFlag.none);
    if (next.contains(flag)) {
      next.remove(flag);
    } else {
      next.add(flag);
    }
    return next;
  }

  String localizedLabel(AppLocalizations l10n) => switch (this) {
        HealthFlag.diabetes => l10n.flagDiabetes,
        HealthFlag.bloodPressure => l10n.flagBloodPressure,
        HealthFlag.cholesterol => l10n.flagCholesterol,
        HealthFlag.pregnancy => l10n.flagPregnancy,
        HealthFlag.jain => l10n.flagJain,
        HealthFlag.swaminarayan => l10n.flagSwaminarayan,
        HealthFlag.none => l10n.flagNoneOfThese,
      };
}
