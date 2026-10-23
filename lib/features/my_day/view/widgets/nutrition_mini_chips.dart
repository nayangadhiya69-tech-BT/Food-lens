import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'my_day_labels.dart';

/// The small "sugar 15.4g · salt 3mg · fat 0.0g" chips from the
/// reference. A chip turns amber-red ("hot") when its value passes the
/// reference's per-item thresholds (sugar > 15 g, salt > 500 mg,
/// fat > 7 g).
class NutritionMiniChips extends StatelessWidget {
  const NutritionMiniChips({
    super.key,
    required this.sugarG,
    required this.sodiumMg,
    required this.saturatedFatG,
  });

  final double sugarG;
  final double sodiumMg;
  final double saturatedFatG;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    Widget chip(String label, bool hot) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(7),
        vertical: dynamicHeight(3),
      ),
      decoration: BoxDecoration(
        color: hot ? AppColors.dangerBackground : AppColors.lineLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyle.create(
          fontSize: 11,
          weight: FontWeights.bold,
          color: hot ? AppColors.dangerText : AppColors.inkSecondary,
        ),
      ),
    );

    // Wrap, not Row: on narrow screens (or with longer localizations)
    // the third chip must drop to a second line instead of overflowing.
    return Wrap(
      spacing: dynamicWidth(5),
      runSpacing: dynamicHeight(5),
      children: [
        chip(l10n.myDayChipSugar(MyDayLabels.fmtG(sugarG)), sugarG > 15),
        chip(l10n.myDayChipSalt(MyDayLabels.fmtMg(sodiumMg)), sodiumMg > 500),
        chip(
          l10n.myDayChipFat(MyDayLabels.fmtG(saturatedFatG)),
          saturatedFatG > 7,
        ),
      ],
    );
  }
}
