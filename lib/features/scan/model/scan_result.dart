import '../../../core/models/health_flag.dart';

/// One number in the result's stat strip (HTML screen 10).
///
/// [value] is fixture content; the label is localized by the screen from
/// [key], following the app's rule that fixtures never hold UI strings.
class ScanStat {
  const ScanStat({required this.key, required this.value});

  final ScanStatKey key;
  final String value;
}

/// Semantic keys for the five stat-strip cells.
enum ScanStatKey { sodium, condition, additives, allergens, score }

/// A single "flags on this label" row: what was found, and the figure.
class LabelFlag {
  const LabelFlag({required this.title, required this.value});

  final String title;
  final String value;
}

/// The "Decoded in depth" card: one nutrient read all the way down to
/// the ingredient that carries it (HTML screen 10's palm-oil card).
class DepthDecode {
  const DepthDecode({
    required this.title,
    required this.amount,
    required this.detail,
    required this.percent,
    required this.pill,
    required this.ingredient,
    required this.note,
  });

  /// e.g. "Saturated & trans fat"
  final String title;

  /// e.g. "13.7 g total fat"
  final String amount;

  /// e.g. "(6.5 g saturated) per 80 g"
  final String detail;

  /// e.g. "· 30% daily" — rendered in the warning color.
  final String percent;

  /// e.g. "Whole food"
  final String pill;

  /// e.g. "Edible Vegetable Oil (Palm Oil)"
  final String ingredient;

  /// Plain-language note about the ingredient.
  final String note;
}

/// Everything the processing step produces for the result screen.
class ScanResult {
  const ScanResult({
    required this.name,
    required this.subtitle,
    required this.flaggedCount,
    required this.stats,
    required this.bannerBody,
    required this.labelFlags,
    required this.depth,
    required this.friendlyFlags,
  });

  /// Product name and pack subtitle shown in the result header and on
  /// the processing screen.
  final String name;
  final String subtitle;

  /// Total things flagged on the label — drives the banner headline
  /// (the banner also counts items explained in the depth card, which
  /// is why it can exceed [labelFlags].length).
  final int flaggedCount;

  final List<ScanStat> stats;

  /// Long banner explanation under the headline.
  final String bannerBody;

  final List<LabelFlag> labelFlags;
  final DepthDecode depth;

  /// Personal flags from the user's selection that this product is
  /// friendly for (e.g. a Jain-friendly biscuit). The overview status
  /// compares the selection against this.
  final Set<HealthFlag> friendlyFlags;
}
