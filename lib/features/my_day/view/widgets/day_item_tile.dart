import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../model/food_product.dart';
import '../../model/my_day_entry.dart';
import '../../model/nutrient_totals.dart';
import 'my_day_labels.dart';
import 'nutrition_mini_chips.dart';

/// One "What made it up" row on the summary: emoji tile, name, the
/// human amount with gram truth and pack percentage, mini nutrition
/// chips, and a remove (✕) button.
class DayItemTile extends StatelessWidget {
  final FoodProduct product;

  final MyDayEntry entry;
  final NutrientTotals itemTotals;
  final VoidCallback onRemove;
  const DayItemTile({
    super.key,
    required this.product,
    required this.entry,
    required this.itemTotals,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = MyDayLabels.of(context);
    final max = product.maxAmount;
    final percentOfPack = max > 0 ? (entry.amountG / max * 100).round() : 0;

    return Container(
      margin: EdgeInsets.only(bottom: dynamicHeight(8)),
      padding: EdgeInsets.all(dynamicWidth(11)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hexToColor("E4DED2")),
      ),
      child: Row(
        children: [
          Container(
            width: dynamicWidth(40),
            height: dynamicWidth(40),
            decoration: BoxDecoration(
              color: AppColors.hexToColor("E4DED2"),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(
                product.icon,
                style: TextStyle(fontSize: dynamicWidth(20)),
              ),
            ),
          ),
          SizedBox(width: dynamicWidth(11)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.create(
                    fontSize: 14,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: dynamicHeight(2)),
                Text(
                  '${product.sayAmount(entry.amountG)} · '
                  '${MyDayLabels.fmtG(entry.amountG)}g · $percentOfPack% of pack',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.create(
                    fontSize: 11.5,
                    color: AppColors.hexToColor("8f887e"),
                  ),
                ),
                SizedBox(height: dynamicHeight(6)),
                NutritionMiniChips(
                  sugarG: itemTotals.sugarG,
                  sodiumMg: itemTotals.sodiumMg,
                  saturatedFatG: itemTotals.saturatedFatG,
                ),
              ],
            ),
          ),
          SizedBox(width: dynamicWidth(8)),
          Semantics(
            button: true,
            label: l10n.myDayRemoveItem(product.name),
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Container(
                width: dynamicWidth(32),
                height: dynamicWidth(32),
                decoration: BoxDecoration(
                  color: AppColors.hexToColor("F4F0E7"),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.hexToColor("C2410C"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
