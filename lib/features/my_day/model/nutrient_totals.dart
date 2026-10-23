/// Aggregated nutrients for a portion, a day, or any set of entries.
///
/// Sodium is stored in milligrams and sugar/saturated fat in grams —
/// matching how food labels declare them. No rounding happens here;
/// formatting is a presentation concern.
class NutrientTotals {
  const NutrientTotals({
    this.sugarG = 0,
    this.sodiumMg = 0,
    this.saturatedFatG = 0,
  });

  static const NutrientTotals zero = NutrientTotals();

  final double sugarG;
  final double sodiumMg;
  final double saturatedFatG;

  NutrientTotals operator +(NutrientTotals other) => NutrientTotals(
    sugarG: sugarG + other.sugarG,
    sodiumMg: sodiumMg + other.sodiumMg,
    saturatedFatG: saturatedFatG + other.saturatedFatG,
  );

  @override
  bool operator ==(Object other) =>
      other is NutrientTotals &&
      other.sugarG == sugarG &&
      other.sodiumMg == sodiumMg &&
      other.saturatedFatG == saturatedFatG;

  @override
  int get hashCode => Object.hash(sugarG, sodiumMg, saturatedFatG);

  @override
  String toString() =>
      'NutrientTotals(sugarG: $sugarG, sodiumMg: $sodiumMg, satFatG: $saturatedFatG)';
}
