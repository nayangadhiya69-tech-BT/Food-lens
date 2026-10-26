import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Shared dark camera chrome for the barcode and photo capture screens
/// (HTML screens 7 and 8): close + torch row, hint line, framed preview
/// area, an optional note above the controls, and the shutter row.
///
/// Pure chrome — the actual frame (bracket vs label box) and the right
/// control (switch mode vs gallery) are supplied by each screen. When a
/// live [preview] is given it fills the background behind the chrome,
/// with gradients keeping the controls readable; without one the screen
/// falls back to the flat ink background of the design.
class ScanCameraShell extends StatelessWidget {
  const ScanCameraShell({
    super.key,
    required this.hint,
    required this.frame,
    required this.onClose,
    required this.onShutter,
    required this.onToggleTorch,
    required this.trailingControl,
    this.torchOn = false,
    this.footerNote,
    this.preview,
  });

  final String hint;
  final Widget frame;
  final VoidCallback onClose;
  final VoidCallback onShutter;
  final VoidCallback onToggleTorch;

  /// Right-hand control of the shutter row (mode switch / gallery).
  final Widget trailingControl;

  final bool torchOn;

  /// Optional line above the shutter row (the "No barcode?" note,
  /// the photo thumbnail strip).
  final Widget? footerNote;

  /// Live camera preview rendered full-bleed behind the chrome.
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPreview = preview != null;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Stack(
          children: [
            if (hasPreview) ...[
              Positioned.fill(child: preview!),
              const Positioned.fill(
                child: IgnorePointer(child: _CameraScrims()),
              ),
            ],
            Positioned.fill(
              child: Column(
                children: [
                  // Close + torch.
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      dynamicWidth(16),
                      dynamicHeight(8),
                      dynamicWidth(16),
                      dynamicHeight(8),
                    ),
                    child: Row(
                      children: [
                        _RoundControl(
                          key: const ValueKey('scanClose'),
                          icon: Icons.close,
                          label: l10n.actionClose,
                          onTap: onClose,
                        ),
                        const Spacer(),
                        _RoundControl(
                          icon: torchOn ? Icons.flash_on : Icons.flash_off,
                          label: l10n.scanFlashLabel,
                          active: torchOn,
                          onTap: onToggleTorch,
                        ),
                      ],
                    ),
                  ),
                  // Hint.
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dynamicWidth(24),
                      vertical: dynamicHeight(6),
                    ),
                    child: Text(
                      hint,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.create(
                        fontSize: 13,
                        weight: FontWeights.semibold,
                        color: Colors.white.withValues(alpha: 0.75),
                        height: 1.4,
                      ),
                    ),
                  ),
                  // Framed preview area.
                  Expanded(child: Center(child: frame)),
                  ?footerNote,
                  // Shutter row.
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      dynamicWidth(32),
                      dynamicHeight(10),
                      dynamicWidth(32),
                      dynamicHeight(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: dynamicWidth(44)),
                        _Shutter(hint: hint, onTap: onShutter),
                        SizedBox(
                          width: dynamicWidth(44),
                          child: trailingControl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top and bottom ink gradients laid over a live preview so the controls
/// and hint text stay readable (`.shade-top` / `.shade-bottom`).
class _CameraScrims extends StatelessWidget {
  const _CameraScrims();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.ink,
                AppColors.ink.withValues(alpha: 0.85),
                AppColors.ink.withValues(alpha: 0),
              ],
              stops: const [0, 0.4, 1],
            ),
          ),
          child: SizedBox(height: dynamicHeight(150)),
        ),
        const Spacer(),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.ink,
                AppColors.ink.withValues(alpha: 0.85),
                AppColors.ink.withValues(alpha: 0),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
          child: SizedBox(height: dynamicHeight(210)),
        ),
      ],
    );
  }
}

/// Shown in place of the frame when no live camera is available
/// (permission denied, no hardware, tests/web): explains the fallback
/// while the shutter keeps the demo flow working.
class ScanCameraUnavailable extends StatelessWidget {
  const ScanCameraUnavailable({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dynamicWidth(40)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dynamicWidth(52),
            height: dynamicWidth(52),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_off_outlined,
              size: 24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: dynamicHeight(14)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.create(
              fontSize: 15,
              weight: FontWeights.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: dynamicHeight(8)),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTextStyle.create(
              fontSize: 12.5,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular translucent icon button used on the dark camera screens.
class _RoundControl extends StatelessWidget {
  const _RoundControl({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: dynamicWidth(40),
          height: dynamicHeight(40),
          decoration: BoxDecoration(
            color: active
                ? AppColors.brand.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 19,
            color: active ? AppColors.brandBright : Colors.white,
          ),
        ),
      ),
    );
  }
}

/// The big white ring shutter (`.shutter` of the HTML design).
class _Shutter extends StatelessWidget {
  const _Shutter({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          key: const ValueKey('scanShutter'),
          width: dynamicWidth(58),
          height: dynamicHeight(58),
          padding: EdgeInsets.all(dynamicWidth(4)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small note line above the shutter row — white secondary text with an
/// optional inline brand-colored action ("No barcode? Switch to photo").
class ScanCameraNote extends StatelessWidget {
  const ScanCameraNote({
    super.key,
    required this.text,
    this.action,
    this.onAction,
  });

  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(24),
        vertical: dynamicHeight(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyle.create(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          if (action != null) ...[
            SizedBox(width: dynamicWidth(5)),
            Flexible(
              child: Semantics(
                button: true,
                label: action,
                child: GestureDetector(
                  onTap: onAction,
                  child: Text(
                    action!,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.create(
                      fontSize: 12,
                      weight: FontWeights.bold,
                      color: AppColors.brandBright,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
