import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';

/// Amber informational banner matching the reference's `.note` /
/// `.caveat` blocks (pick-screen hint, amounts note, portion caveats,
/// honey correction, …).
class MyDayNote extends StatelessWidget {
  final String text;

  final String? icon;

  /// Smaller padding for the per-card caveat lines.
  final bool compact;

  const MyDayNote({
    super.key,
    required this.text,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(compact ? 10 : 12),
        vertical: dynamicHeight(compact ? 8 : 11),
      ),
      decoration: BoxDecoration(
        color: AppColors.warningBackground,
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
        border: Border.all(color: AppColors.warningLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Text(icon!, style: TextStyle(fontSize: compact ? 12 : 14)),
            SizedBox(width: dynamicWidth(8)),
          ],
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.create(
                fontSize: compact ? 11.5 : 12,
                color: AppColors.warningText,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
