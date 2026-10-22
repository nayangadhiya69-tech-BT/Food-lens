import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_text_style.dart';

class CommonWidgets {
  CommonWidgets._();

  static Widget loading({String? label}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.brand),
          if (label != null) ...[
            SizedBox(height: dynamicHeight(12)),
            Text(label, style: const TextStyle(color: AppColors.inkSecondary)),
          ],
        ],
      ),
    );
  }

  static Widget errorWidget({
    required String message,
    VoidCallback? onRetry,
    String? retryLabel,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(dynamicWidth(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.danger),
            SizedBox(height: dynamicHeight(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.create(
                fontSize: 15,
                color: AppColors.inkSecondary,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: dynamicHeight(20)),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(retryLabel ?? 'Retry'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(dynamicWidth(160), dynamicHeight(48)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget emptyWidget({
    required String message,
    String? subtitle,
    IconData icon = Icons.inbox_outlined,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(dynamicWidth(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: dynamicWidth(88),
              height: dynamicHeight(88),
              decoration: const BoxDecoration(
                color: AppColors.brandBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.brand),
            ),
            SizedBox(height: dynamicHeight(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.create(
                fontSize: 16,
                weight: FontWeights.bold,
                color: AppColors.ink,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: dynamicHeight(6)),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyle.create(
                  fontSize: 13,
                  color: AppColors.inkSecondary,
                ),
              ),
            ],
            if (action != null) ...[
              SizedBox(height: dynamicHeight(20)),
              action,
            ],
          ],
        ),
      ),
    );
  }

  static Widget pill({
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(10),
        vertical: dynamicHeight(4),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyle.create(
          fontSize: 11,
          weight: FontWeights.bold,
          color: foreground,
        ),
      ),
    );
  }

  static Widget sectionLabel(String text, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.fromLTRB(
            dynamicWidth(16),
            dynamicHeight(18),
            dynamicWidth(16),
            dynamicHeight(8),
          ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyle.create(
          fontSize: 12,
          weight: FontWeights.bold,
          color: AppColors.inkSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
