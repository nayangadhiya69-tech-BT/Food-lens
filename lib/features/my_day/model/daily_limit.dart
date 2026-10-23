import 'nutrient_totals.dart';

/// The three nutrients My Day tracks against a daily reference limit.
enum NutrientType {
  /// Free sugars (WHO 2015 basis), grams.
  sugar,

  /// Sodium, milligrams. Displayed as "Salt (sodium)" — the label says
  /// sodium and the limit is the sodium limit, so no salt conversion
  /// (sodium g × 2.5) is applied to these figures.
  sodium,

  /// Saturated fat — "heavy fat" in the reference UI, grams.
  saturatedFat,
}

/// One daily reference limit: nutrient, amount, unit and its source.
class DailyLimit {
  const DailyLimit({
    required this.nutrient,
    required this.limit,
    required this.unit,
    required this.source,
  });

  final NutrientType nutrient;
  final double limit;
  final String unit;
  final String source;
}

/// WHO adult daily reference values used by the My Day reference design.
///
/// These are reference intakes from the supplied design (WHO 2015 free
/// sugars, WHO 2012 sodium, WHO 2023 saturated fat) — not personal goals
/// and not FSSAI limits. They live here so the calculator, the summary
/// and the Home dashboard all compare against exactly the same numbers.
class DailyLimits {
  DailyLimits._();

  static const DailyLimit sugar = DailyLimit(
    nutrient: NutrientType.sugar,
    limit: 50,
    unit: 'g',
    source: 'WHO 2015',
  );

  static const DailyLimit sodium = DailyLimit(
    nutrient: NutrientType.sodium,
    limit: 2000,
    unit: 'mg',
    source: 'WHO 2012',
  );

  static const DailyLimit saturatedFat = DailyLimit(
    nutrient: NutrientType.saturatedFat,
    limit: 22,
    unit: 'g',
    source: 'WHO 2023',
  );

  static const List<DailyLimit> all = [sugar, sodium, saturatedFat];

  /// Consumed amount of [limit]'s nutrient inside [totals].
  static double valueOf(NutrientTotals totals, DailyLimit limit) {
    switch (limit.nutrient) {
      case NutrientType.sugar:
        return totals.sugarG;
      case NutrientType.sodium:
        return totals.sodiumMg;
      case NutrientType.saturatedFat:
        return totals.saturatedFatG;
    }
  }
}

/// Visual state of a progress bar: green, amber (≥70 %) or over the limit.
enum LimitLevel { ok, warn, over }

/// A consumed amount measured against one daily limit.
class LimitProgress {
  const LimitProgress({
    required this.limit,
    required this.value,
    required this.percent,
    required this.level,
  });

  final DailyLimit limit;
  final double value;

  /// Consumed percentage of the daily limit; may exceed 100.
  final double percent;
  final LimitLevel level;

  /// Amount left before the limit — may be negative when over.
  double get remaining => limit.limit - value;

  bool get isOver => value > limit.limit;

  /// Safe progress constructor: guards zero/negative limits, NaN and
  /// infinite values so a bad configuration can never crash the UI.
  factory LimitProgress.of({
    required NutrientTotals totals,
    required DailyLimit limit,
  }) {
    final value = DailyLimits.valueOf(totals, limit);
    final safeValue = value.isFinite && value > 0 ? value : 0.0;
    if (limit.limit <= 0) {
      return LimitProgress(
        limit: limit,
        value: safeValue,
        percent: 0,
        level: LimitLevel.ok,
      );
    }
    final percent = safeValue / limit.limit * 100;
    final level = safeValue > limit.limit
        ? LimitLevel.over
        : (percent >= 70 ? LimitLevel.warn : LimitLevel.ok);
    return LimitProgress(
      limit: limit,
      value: safeValue,
      percent: percent,
      level: level,
    );
  }
}
