import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';

/// Animated shimmer sweep used as the skeleton/loading state for any
/// screen that binds repository data (dashboard, history, profile, …).
///
/// Wrap a composed skeleton tree in a single [CommonShimmer]; the sweep
/// runs once over the whole area. Set [enabled] to false to render the
/// child as a static skeleton (e.g. while a value is already known).
class CommonShimmer extends StatelessWidget {
  const CommonShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.period,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final bool enabled;

  /// Sweep duration; defaults to a calm 1.8s.
  final Duration? period;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.lineLight,
      highlightColor: highlightColor ?? AppColors.line,
      period: period ?? const Duration(milliseconds: 1800),
      child: child,
    );
  }
}

/// Dynamic skeleton primitive — a rounded (or circular) placeholder box.
///
/// Width/height are design values on the 393pt grid and scale with the
/// device like every other layout size; radius stays unscaled (app
/// convention). Leave width null inside an `Expanded`/`FractionallySizedBox`
/// to let the parent decide the span — compose freely to mimic any card,
/// row, avatar or text line.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
    this.circle = false,
    this.color,
  });

  /// Design width (scaled by `dynamicWidth`); null → fills parent width.
  final double? width;

  /// Design height (scaled by `dynamicHeight`); null → fills parent height.
  final double? height;
  final double radius;
  final bool circle;

  /// Fill color; defaults to the app's `lineLight` skeleton tint.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == null ? null : dynamicWidth(width!),
      height: height == null ? null : dynamicHeight(height!),
      decoration: BoxDecoration(
        color: color ?? AppColors.lineLight,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton row matching `ScanRecordTile` (emoji tile + two text lines +
/// status pill + optional divider) — used by the dashboard recent-scans
/// list and the history list.
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key, this.showDivider = true});

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(16),
            vertical: dynamicHeight(12),
          ),
          child: Row(
            children: [
              ShimmerBox(
                width: 44,
                height: 44,
                radius: 10,
                color: AppColors.line,
              ),
              SizedBox(width: dynamicWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      alignment: Alignment.centerLeft,
                      child: ShimmerBox(
                        height: 13,
                        radius: 4,
                        color: AppColors.line,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(6)),
                    FractionallySizedBox(
                      widthFactor: 0.35,
                      alignment: Alignment.centerLeft,
                      child: ShimmerBox(
                        height: 10,
                        radius: 4,
                        color: AppColors.line,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: dynamicWidth(8)),
              ShimmerBox(
                width: 50,
                height: 20,
                radius: 20,
                color: AppColors.line,
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(indent: 16, endIndent: 16),
      ],
    );
  }
}
