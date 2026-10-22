import 'package:flutter/widgets.dart';

/// Responsive sizing helper based on the design's reference width.
///
/// Every static size in the UI is expressed against a 393pt-wide phone
/// (the design baseline). [dynamicWidth]/[dynamicHeight] multiply a design
/// value by the current screen-width ratio, so on the reference phone the
/// rendered size is pixel-identical to the design, and on wider screens
/// every gap/box scales proportionally.
///
/// Heights intentionally use the *width* ratio too (there is no separate
/// height ratio) — both axes scale together so the layout never skews.
///
/// [init] must be called from a context below `MediaQuery` (the
/// `MaterialApp.router` builder does this automatically).
class AppSize {
  AppSize._();

  /// Reference (design) width of an average phone.
  static const double designWidth = 393;

  static double _scale = 1;

  /// Current device-width ratio (screen width / [designWidth]).
  static double get scale => _scale;

  /// Reads the screen width from [context] and updates the scale factor.
  /// Safe to call on every rebuild; the value only changes on real
  /// size/orientation changes.
  static void init(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 0) {
      _scale = width / designWidth;
    }
  }

  /// Scales a design value by the device-width ratio.
  static double apply(double size) => size * _scale;
}

/// Scales a design width value to the current screen (see [AppSize.apply]).
///
/// Use instead of raw numbers: `SizedBox(width: dynamicWidth(10))`.
double dynamicWidth(double size) => AppSize.apply(size);

/// Scales a design height value — same width-based ratio as
/// [dynamicWidth] (no separate height ratio is used).
///
/// Use instead of raw numbers: `SizedBox(height: dynamicHeight(16))`.
double dynamicHeight(double size) => AppSize.apply(size);
