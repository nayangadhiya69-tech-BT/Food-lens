import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../model/daily_limit.dart';
import 'my_day_labels.dart';

/// One "today against the daily limit" card from the My Day reference:
/// nutrient name + consumed value, a rounded progress track with the
/// ok/warn/over gradient, and a footer with the limit source plus a
/// "left" or "over" pill.
///
/// Shared between the My Day summary and the Home dashboard so both
/// always render identical figures and styling.
class LimitProgressCard extends StatelessWidget {
  const LimitProgressCard({super.key, required this.progress});

  final LimitProgress progress;

  static const List<Color> _okGradient = [Color(0xFF4FBE8B), AppColors.brand];
  static const List<Color> _warnGradient = [
    Color(0xFFD9A441),
    AppColors.warning,
  ];
  static const List<Color> _overGradient = [
    Color(0xFFD4763F),
    AppColors.danger,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = MyDayLabels.of(context);
    final limit = progress.limit;
    final over = progress.isOver;
    final fillWidth = math.min(progress.percent, 100) / 100;
    final gradient = switch (progress.level) {
      LimitLevel.ok => _okGradient,
      LimitLevel.warn => _warnGradient,
      LimitLevel.over => _overGradient,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: dynamicHeight(12)),
      child: Container(
        padding: EdgeInsets.all(dynamicWidth(15)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    MyDayLabels.nutrientLabel(l10n, limit.nutrient),
                    style: AppTextStyle.create(
                      fontSize: 15,
                      weight: FontWeights.bold,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Text(
                  MyDayLabels.fmtValue(progress.value, limit.unit),
                  style: AppTextStyle.create(
                    fontSize: 15,
                    weight: FontWeights.bold,
                    color: over ? AppColors.dangerText : AppColors.ink,
                  ),
                ),
              ],
            ),
            SizedBox(height: dynamicHeight(7)),
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Container(
                height: dynamicHeight(16),
                color: const Color(0xFFEDE7DB),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fillWidth == 0 ? 0.001 : fillWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: dynamicHeight(7)),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${l10n.myDayDailyLimit} ',
                          style: AppTextStyle.create(
                            fontSize: 12,
                            color: AppColors.inkTertiary,
                          ),
                        ),
                        TextSpan(
                          text: MyDayLabels.fmtValue(limit.limit, limit.unit),
                          style: AppTextStyle.create(
                            fontSize: 12,
                            weight: FontWeights.bold,
                            color: AppColors.inkTertiary,
                          ),
                        ),
                        TextSpan(
                          text: ' · ${limit.source}',
                          style: AppTextStyle.create(
                            fontSize: 12,
                            color: AppColors.inkTertiary,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: dynamicWidth(8)),
                CommonWidgets.pill(
                  label: over
                      ? l10n.myDayOverBy(
                          MyDayLabels.fmtValue(
                            progress.remaining.abs(),
                            limit.unit,
                          ),
                        )
                      : l10n.myDayRemaining(
                          MyDayLabels.fmtValue(progress.remaining, limit.unit),
                        ),
                  background: over
                      ? AppColors.dangerBackground
                      : AppColors.brandBackground,
                  foreground: over ? AppColors.dangerText : AppColors.brandDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
