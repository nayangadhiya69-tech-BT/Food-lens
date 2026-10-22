import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';

/// Common top-positioned toast for every transient alert in the app
/// (scan-unavailable notices, OTP resent confirmation, …).
///
/// Usage:
/// ```dart
/// CommonToast.show(context, message: l10n.someMessage);
/// CommonToast.show(context, message: msg, type: ToastType.success);
/// ```
///
/// * Shows at the **top** of the screen (below the status bar).
/// * Slides down + fades in, auto-dismisses after [duration] (3s default).
/// * Tapping the toast dismisses it early.
/// * Showing a new toast replaces the current one (single toast at a time).
///
/// Deliberately simple — intended to be customized later (icon, actions,
/// placement) without touching call sites: they only pass message + type.
class CommonToast extends StatefulWidget {
  /// Currently inserted toast, if any (single-toast semantics).
  static OverlayEntry? _current;

  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;

  const CommonToast({
    super.key,
    required this.message,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  State<CommonToast> createState() => _CommonToastState();

  /// Removes the visible toast immediately, if any.
  static void hide() {
    final entry = _current;
    _current = null;
    if (entry != null) _safeRemove(entry);
  }

  /// Shows a top toast, replacing any visible one.
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    hide();
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => CommonToast(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_current == entry) _current = null;
          _safeRemove(entry);
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }

  static void _safeRemove(OverlayEntry entry) {
    if (!entry.mounted) return;
    try {
      entry.remove();
    } catch (_) {
      // The overlay is already disposed (e.g. app/test teardown) —
      // nothing left to remove.
    }
  }
}

/// Toast severity — maps 1:1 to the app's existing message colors
/// (success → brand green, error → danger red, warning → amber,
/// info → near-black ink).
enum ToastType { success, error, warning, info }

class _CommonToastState extends State<CommonToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    reverseDuration: const Duration(milliseconds: 200),
  );
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      );
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final color = switch (widget.type) {
      ToastType.success => AppColors.brand,
      ToastType.error => AppColors.danger,
      ToastType.warning => AppColors.warning,
      ToastType.info => AppColors.ink,
    };

    return Positioned(
      top: MediaQuery.paddingOf(context).top + dynamicHeight(8),
      left: dynamicWidth(16),
      right: dynamicWidth(16),
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _controller,
          child: GestureDetector(
            onTap: _dismiss,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: dynamicWidth(14),
                  vertical: dynamicHeight(12),
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  widget.message,
                  style: AppTextStyle.create(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    _timer = null;
    if (!mounted) return;
    await _controller.reverse();
    if (!mounted) return;
    widget.onDismiss?.call();
  }
}
