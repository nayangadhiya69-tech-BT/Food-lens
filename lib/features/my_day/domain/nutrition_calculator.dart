import '../model/daily_limit.dart';
import '../model/food_product.dart';
import '../model/my_day_entry.dart';
import '../model/nutrient_totals.dart';

/// Single source of truth for My Day nutrition maths.
///
/// Every figure shown on the amount screen, the summary and the Home
/// dashboard is produced here — UI widgets never re-implement formulas.
///
/// Quantity rule (identical for gram- and millilitre-based products,
/// because [FoodProduct] converts household measures to grams using
/// each product's own density first):
///
///     nutrient = per-100g value × (grams eaten ÷ 100)
///
/// e.g. 10 g sugar per 100 g in a 150 g serving → 15 g.
class NutritionCalculator {
  NutritionCalculator._();

  /// Nutrients contributed by one product at [grams] consumed.
  ///
  /// Zero, negative, NaN and infinite amounts contribute nothing —
  /// missing/invalid quantities never fabricate nutrition.
  static NutrientTotals totalsFor(FoodProduct product, double grams) {
    if (!grams.isFinite || grams <= 0) return NutrientTotals.zero;
    final factor = grams / 100;
    return NutrientTotals(
      sugarG: product.per100.sugarG * factor,
      sodiumMg: product.per100.sodiumMg * factor,
      saturatedFatG: product.per100.saturatedFatG * factor,
    );
  }

  /// Sums a set of (product, grams) portions.
  static NutrientTotals aggregate(
    Iterable<MapEntry<FoodProduct, double>> items,
  ) {
    var total = NutrientTotals.zero;
    for (final item in items) {
      total += totalsFor(item.key, item.value);
    }
    return total;
  }

  /// Sums whole day entries against a product lookup.
  ///
  /// Entries whose product is unknown (missing catalog data) are
  /// skipped rather than counted as zero-nutrition food, and invalid
  /// amounts fall through to [totalsFor]'s zero guard.
  static NutrientTotals aggregateEntries({
    required List<MyDayEntry> entries,
    required Map<String, FoodProduct> productsById,
  }) {
    var total = NutrientTotals.zero;
    for (final entry in entries) {
      final product = productsById[entry.productId];
      if (product == null) continue;
      total += totalsFor(product, entry.amountG);
    }
    return total;
  }

  /// Day progress against every reference limit, in display order.
  static List<LimitProgress> limitsFor(NutrientTotals totals) => [
    for (final limit in DailyLimits.all)
      LimitProgress.of(totals: totals, limit: limit),
  ];

  /// Standard labeling conversion: salt (g) ≈ sodium (g) × 2.5.
  ///
  /// The My Day UI stores and shows *sodium* labelled "Salt (sodium)"
  /// against the WHO sodium limit, so this helper is deliberately not
  /// applied to the displayed totals — it exists for callers that need
  /// a true salt equivalent (e.g. a future salt-labelled report).
  static double saltEquivalentG(double sodiumMg) {
    if (!sodiumMg.isFinite || sodiumMg <= 0) return 0;
    return (sodiumMg / 1000) * 2.5;
  }
}
