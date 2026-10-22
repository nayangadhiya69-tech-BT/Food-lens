import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';

/// Rounded surface card with a light hairline border — the section card
/// used across the profile tab and similar grouped content.
/// Margin (16/4) and padding (16/4) are design values and scale with
/// the device width like every other layout size.
class CommonCard extends StatelessWidget {
  const CommonCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: dynamicWidth(16),
        vertical: dynamicHeight(4),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(16),
        vertical: dynamicHeight(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}
