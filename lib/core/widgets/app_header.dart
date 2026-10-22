import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_text_style.dart';

/// White header with a light back button, title and optional subtitle —
/// matches the `.hdr` component of the HTML design.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Size get preferredSize =>
      Size.fromHeight(dynamicHeight(subtitle == null ? 56 : 74));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              if (onBack != null) ...[
                Semantics(
                  button: true,
                  label: l10n.a11yBack,
                  child: Material(
                    color: AppColors.lineLight,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: dynamicWidth(36),
                        height: dynamicHeight(36),
                        child: Icon(
                          Icons.chevron_left,
                          size: 24,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: dynamicWidth(12)),
              ],
              if (title != null || subtitle != null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.create(
                            fontSize: 17,
                            weight: FontWeights.bold,
                            color: AppColors.ink,
                          ),
                        ),
                      if (subtitle != null) ...[
                        SizedBox(height: dynamicHeight(2)),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.create(
                            fontSize: 13,
                            color: AppColors.inkSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ?trailing,
            ],          ),
        ),
      ),
    );
  }
}
