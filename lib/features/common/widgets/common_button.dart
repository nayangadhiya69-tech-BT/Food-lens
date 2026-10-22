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
  const CommonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.loadingLabel,
    this.loadingChild,
    this.style,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  /// Text next to the default loading spinner (e.g. "Verifying…").
  final String? loadingLabel;

  /// Fully custom loading child (replaces the default spinner row).
  final Widget? loadingChild;

  final ButtonStyle? style;

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
              : Text(label, key: const ValueKey('commonButtonLabel')),
        ),
      ),
    );
  }
}
