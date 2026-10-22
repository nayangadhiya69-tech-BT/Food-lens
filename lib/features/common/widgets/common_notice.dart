import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';

/// Full-width informational banner on the brand tint background
/// (demo notices on the login and OTP screens, and similar callouts).
class CommonNotice extends StatelessWidget {
  const CommonNotice({
    super.key,
    required this.text,
    this.weight = FontWeights.semibold,
  });

  final String text;
  final FontWeights? weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(12),
        vertical: dynamicHeight(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.brandBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyle.create(
          fontSize: 12,
          weight: weight,
          color: AppColors.brandDark,
          height: 1.45,
        ),
      ),
    );
  }
}
