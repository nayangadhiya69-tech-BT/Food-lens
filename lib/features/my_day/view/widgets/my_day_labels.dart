import 'package:flutter/widgets.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../model/daily_limit.dart';
import '../../model/food_product.dart';

/// Localized display strings and number formatting shared by the My Day
/// screens. Technical unit expressions inside the domain model ("1 tbsp",
/// "400g pack") stay English like the product names; everything that is
/// prose is resolved here through the app's l10n.
class MyDayLabels {
  MyDayLabels._();

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context);

  /// Consumed value / limit formatting: one decimal + unit, like the
  /// reference's `fmt` ("15.4g", "2000.0mg").
  static String fmtValue(double value, String unit) =>
      '${value.toStringAsFixed(1)}$unit';

  /// Mini-chip formatting for sodium (whole milligrams).
  static String fmtMg(double value) => value.toStringAsFixed(0);

  /// Mini-chip formatting for grams (one decimal).
  static String fmtG(double value) => value.toStringAsFixed(1);

  static String nutrientLabel(AppLocalizations l10n, NutrientType nutrient) {
    switch (nutrient) {
      case NutrientType.sugar:
        return l10n.nutrientSugarLabel;
      case NutrientType.sodium:
        return l10n.nutrientSaltLabel;
      case NutrientType.saturatedFat:
        return l10n.nutrientHeavyFatLabel;
    }
  }

  /// The "measured in spoons / counted in biscuits (~8g each)" line.
  static String formWord(AppLocalizations l10n, FoodProduct product) {
    switch (product.formWord) {
      case FormWord.spoons:
        return l10n.formSpoons;
      case FormWord.glasses:
        return l10n.formGlasses;
      case FormWord.katoris:
        return l10n.formKatoris;
      case FormWord.packetsDry:
        return l10n.formPacketsDry;
      case FormWord.biscuits:
        return l10n.formBiscuits(FoodProduct.formatSize(product.pieceG ?? 1));
      case FormWord.sachets:
        return l10n.formSachets(FoodProduct.formatSize(product.sachetG ?? 1));
      case FormWord.concentrate:
        return l10n.formConcentrate(
          FoodProduct.formatSize(product.doseMl ?? 0),
          FoodProduct.formatSize(product.makesMl ?? 0),
        );
      case FormWord.serving:
        return l10n.formServing(FoodProduct.formatSize(product.serveG));
    }
  }

  /// Amber caveat text for a product form, or null when none applies.
  static String? caveat(AppLocalizations l10n, FoodProduct product) {
    switch (product.caveat) {
      case PortionCaveat.cook:
        return l10n.caveatCook;
      case PortionCaveat.concentrate:
        return l10n.caveatConcentrate;
      case PortionCaveat.piece:
        return l10n.caveatPiece(FoodProduct.formatSize(product.pieceG ?? 1));
      case null:
        return null;
    }
  }
}
