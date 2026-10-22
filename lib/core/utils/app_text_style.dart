import 'package:flutter/material.dart';

import 'app_size.dart';

/// Text styles whose [fontSize] scales with the device-width ratio —
/// the same scale as [AppSize]/[dynamicWidth] — so type grows and
/// shrinks together with the layout on every device.
///
/// On the 393pt reference phone the rendered size is pixel-identical to
/// the design; on wider screens every font scales proportionally.
///
/// [weight] is `null` by default so ambient inheritance (e.g. button
/// theme weights) is preserved exactly like a plain `TextStyle`.
class AppTextStyle {
  AppTextStyle._();

  /// Builds a width-ratio-scaled [TextStyle]. [fontSize] is the design
  /// value; all other properties pass through unchanged (letter-spacing
  /// also scales, being a horizontal measure).
  static TextStyle create({
    required double fontSize,
    FontWeights? weight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    FontStyle? fontStyle,
    TextOverflow? overflow,
  }) {
    return TextStyle(
      fontSize: dynamicWidth(fontSize),
      fontWeight: weight == null ? null : FW.of(weight),
      color: color,
      height: height,
      letterSpacing: letterSpacing == null ? null : dynamicWidth(letterSpacing),
      decoration: decoration,
      decorationColor: decorationColor,
      fontStyle: fontStyle,
      overflow: overflow,
    );
  }
}

/// Named font weights used across the app.
enum FontWeights { light, reg, mid, semibold, bold }

/// Font-weight resolver with an explicit switch-case mapping:
/// light → w300, reg → w400, mid → w500, semibold → w600, bold → w700.
class FW {
  FW._();

  static FontWeight of(FontWeights weight) {
    switch (weight) {
      case FontWeights.light:
        return FontWeight.w300;
      case FontWeights.reg:
        return FontWeight.w400;
      case FontWeights.mid:
        return FontWeight.w500;
      case FontWeights.semibold:
        return FontWeight.w600;
      case FontWeights.bold:
        return FontWeight.w700;
    }
  }
}
