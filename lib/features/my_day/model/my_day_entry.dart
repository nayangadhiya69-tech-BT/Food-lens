/// One saved My Day line: a product eaten today at a given gram amount.
///
/// The gram amount is the density-converted truth (see [FoodProduct]);
/// the human phrasing ("2 tbsp") is derived for display only.
class MyDayEntry {
  const MyDayEntry({required this.productId, required this.amountG});

  final String productId;

  /// Grams (or density-converted millilitres) consumed.
  final double amountG;

  MyDayEntry copyWith({double? amountG}) =>
      MyDayEntry(productId: productId, amountG: amountG ?? this.amountG);

  factory MyDayEntry.fromJson(Map<String, dynamic> json) {
    return MyDayEntry(
      productId: json['product_id'] as String,
      amountG: (json['amount_g'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'amount_g': amountG,
  };

  @override
  bool operator ==(Object other) =>
      other is MyDayEntry &&
      other.productId == productId &&
      other.amountG == amountG;

  @override
  int get hashCode => Object.hash(productId, amountG);
}
