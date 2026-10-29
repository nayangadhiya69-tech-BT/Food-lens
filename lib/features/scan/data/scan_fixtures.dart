import '../../../core/models/health_flag.dart';
import '../model/scan_result.dart';

/// Demo scan result matching the HTML design's result screen (screen 10)
/// for the same product the sample history already lists.
///
/// Product content (names, figures) is fixture data like the rest of the
/// demo build; every surrounding label is localized by the screen.
class ScanFixtures {
  ScanFixtures._();

  /// Product the demo analysis matches — also the name shown while the
  /// label is still being read on the processing screen.
  static const String productName = 'Patanjali Doodh Biscuits';

  static const String productSubtitle = '800 g box · 10 mini packs inside';

  /// Demo verdicts: which personal flags this sample product is friendly
  /// for (e.g. Jain-friendly biscuits). The mock analysis intersects this
  /// with the flags the user selected during the scan.
  static const Set<HealthFlag> friendlyForProduct = <HealthFlag>{
    HealthFlag.jain,
    HealthFlag.swaminarayan,
  };

  /// [conditionFlagged] is how many of the user's own flags apply here —
  /// the link between the flag step and the result's stat strip.
  /// [friendlyFlags] are the selected flags this product is friendly for.
  static ScanResult result({
    required int conditionFlagged,
    Set<HealthFlag> friendlyFlags = const <HealthFlag>{},
  }) => ScanResult(
    name: productName,
    subtitle: productSubtitle,
    flaggedCount: 3,
    stats: [
      const ScanStat(key: ScanStatKey.sodium, value: '14%'),
      ScanStat(key: ScanStatKey.condition, value: '$conditionFlagged'),
      const ScanStat(key: ScanStatKey.additives, value: '4'),
      const ScanStat(key: ScanStatKey.allergens, value: '4'),
      const ScanStat(key: ScanStatKey.score, value: '80'),
    ],
    bannerBody:
        'Added sugar, saturated fat, and hidden sodium sources each cross '
        'the WHO / ICMR-NIN adult daily reference when scaled to the 80 g '
        'pack this product is actually sold in.',
    labelFlags: const [
      LabelFlag(title: 'Added sugar', value: '17.8 g · 36%'),
      LabelFlag(title: 'Hidden sodium · 4 sources', value: '14%'),
    ],
    depth: const DepthDecode(
      title: 'Saturated & trans fat',
      amount: '13.7 g total fat',
      detail: '(6.5 g saturated) per 80 g',
      percent: '· 30% daily',
      pill: 'Whole food',
      ingredient: 'Edible Vegetable Oil (Palm Oil)',
      note:
          'Palm oil is a naturally occurring vegetable fat that carries more '
          'saturated fat than most other cooking oils.',
    ),
    friendlyFlags: friendlyFlags,
  );
}
