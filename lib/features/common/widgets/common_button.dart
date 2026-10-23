import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';

/// Full-width elevated button matching the app's theme, with an animated
/// loader swap (fade + scale, same curves as the OTP verify button).
///
/// * [onPressed] null (or [loading] true) disables the button.
/// * While loading, [loadingChild] is shown if provided (custom spinner),
///   otherwise a default spinner row with an optional [loadingLabel].
class CommonButton extends StatelessWidget {
  final String label;

  final VoidCallback? onPressed;
  final bool loading;

  /// Optional count rendered as a translucent pill after the label
  /// (the My Day pick screen's "Parse and Add to List (3)").
  final int? badgeCount;

  /// Text next to the default loading spinner (e.g. "Verifying…").
  final String? loadingLabel;

  /// Fully custom loading child (replaces the default spinner row).
  final Widget? loadingChild;

  final ButtonStyle? style;

  const CommonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.badgeCount,
    this.loadingLabel,
    this.loadingChild,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;

    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
              child: child,
            ),
          ),
          child: loading
              ? (loadingChild ??
                    Row(
                      key: const ValueKey('commonButtonLoading'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: dynamicWidth(18),
                          height: dynamicHeight(18),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surface,
                          ),
                        ),
                        if (loadingLabel != null) ...[
                          SizedBox(width: dynamicWidth(10)),
                          Text(loadingLabel!),
                        ],
                      ],
                    ))
              : Row(
                  key: const ValueKey('commonButtonLabel'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Flexible: long localized labels (or the count badge)
                    // must never overflow the button on narrow screens.
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeCount != null) ...[
                      SizedBox(width: dynamicWidth(8)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dynamicWidth(10),
                          vertical: dynamicHeight(2),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
