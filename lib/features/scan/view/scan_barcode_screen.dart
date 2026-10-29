import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../model/scan_mode.dart';
import '../view_model/scan_view_model.dart';
import 'widgets/scan_camera_shell.dart';
import 'widgets/scan_camera_support.dart';

/// HTML screen 7 — Barcode scanner: the live camera lens with a bracket
/// frame and moving scan line. A detected barcode advances the flow to
/// the flag step automatically; the shutter still completes the capture
/// manually. When no camera is available the screen falls back to the
/// demo capture so the flow keeps working.
class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

/// Corner-bracket guide with the animated scan line sweeping inside it.
class _BarcodeFrame extends StatelessWidget {
  const _BarcodeFrame();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dynamicWidth(240),
      height: dynamicHeight(130),
      child: const Stack(
        children: [
          Positioned(top: 0, left: 0, child: _Corner(top: true, left: true)),
          Positioned(top: 0, right: 0, child: _Corner(top: true)),
          Positioned(bottom: 0, left: 0, child: _Corner(left: true)),
          Positioned(bottom: 0, right: 0, child: _Corner()),
          Positioned.fill(child: _ScanLine()),
        ],
      ),
    );
  }
}

/// One L-shaped bracket corner of the scan frame.
class _Corner extends StatelessWidget {
  final bool top;

  final bool left;
  const _Corner({this.top = false, this.left = false});

  @override
  Widget build(BuildContext context) {
    final side = dynamicWidth(26);
    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: AppColors.brandBright, width: 3)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: AppColors.brandBright, width: 3)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: AppColors.brandBright, width: 3)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: AppColors.brandBright, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _scanner;
  bool _unavailable = false;
  bool _handledDetect = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ScanViewModel>();
    if (_handledDetect && viewModel.phase == ScanPhase.idle) {
      _handledDetect = false;
    }

    final scanner = _scanner;
    return ScanCameraShell(
      hint: l10n.scanBarcodeHint,
      torchOn: viewModel.torchOn,
      onToggleTorch: _toggleTorch,
      onClose: () {
        if (context.canPop()) {
          context.read<ScanViewModel>().restoreResult();
          context.pop();
        } else {
          context.go(AppRoutes.scan);
        }
      },
      onShutter: () {
        if (viewModel.capture()) {
          context.push(AppRoutes.scanFlags);
        }
      },
      preview: !_unavailable && scanner != null
          ? MobileScanner(
              controller: scanner,
              onDetect: _onDetect,
              placeholderBuilder: (context) =>
                  const ColoredBox(color: AppColors.ink),
              errorBuilder: (context, error) =>
                  const ColoredBox(color: AppColors.ink),
            )
          : null,
      frame: _unavailable
          ? ScanCameraUnavailable(
              title: l10n.scanCameraUnavailableTitle,
              body: l10n.scanCameraUnavailableBody,
            )
          : const _BarcodeFrame(),
      footerNote: ScanCameraNote(
        text: l10n.scanNoBarcode,
        action: l10n.scanSwitchToPhoto,
        onAction: _switchToPhoto,
      ),
      trailingControl: Semantics(
        button: true,
        label: l10n.scanSwitchToPhoto,
        child: GestureDetector(
          onTap: _switchToPhoto,
          child: const Icon(
            Icons.image_outlined,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final scanner = _scanner;
    if (scanner == null || _unavailable) return;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        unawaited(scanner.pause().catchError((_) {}));
      case AppLifecycleState.resumed:
        unawaited(scanner.start().catchError((_) {}));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final scanner = _scanner;
    _scanner = null;
    if (scanner != null) {
      scanner.removeListener(_onScannerChanged);
      unawaited(_disposeScanner(scanner));
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (scanCameraDisabled) {
      _unavailable = true;
    } else {
      // The controller must exist before the first build so the
      // MobileScanner widget can attach to it. Starting it here (rather
      // than after the frame) previously made start() time out waiting
      // for the widget, which always showed the "camera unavailable"
      // fallback on real devices.
      final scanner = MobileScannerController(
        facing: CameraFacing.back,
        detectionSpeed: DetectionSpeed.noDuplicates,
      );
      scanner.addListener(_onScannerChanged);
      _scanner = scanner;
    }
  }

  Future<void> _disposeScanner(MobileScannerController scanner) async {
    try {
      await scanner.dispose();
    } catch (_) {
      // Best effort — the platform session may already be gone.
    }
  }

  /// Replaces the live lens with the fallback notice when the plugin
  /// reports a camera failure (permission denied, no hardware, ...).
  void _onScannerChanged() {
    final scanner = _scanner;
    if (!mounted || _unavailable || scanner == null) return;
    if (scanner.value.error == null) return;

    setState(() => _unavailable = true);
    _scanner = null;
    scanner.removeListener(_onScannerChanged);
    // Drop the preview widget first, then release the controller, so the
    // preview never touches a disposed notifier.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_disposeScanner(scanner));
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (!mounted || _handledDetect || _unavailable) return;
    final raw = capture.barcodes.isEmpty
        ? null
        : capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;

    final viewModel = context.read<ScanViewModel>();
    if (viewModel.phase != ScanPhase.idle) return;
    _handledDetect = true;
    if (viewModel.capture(barcode: raw)) {
      context.push(AppRoutes.scanFlags);
    }
  }

  void _switchToPhoto() {
    context.read<ScanViewModel>().switchMode(ScanMode.photo);
    context.pushReplacement(AppRoutes.scanPhoto);
  }

  void _toggleTorch() {
    final viewModel = context.read<ScanViewModel>();
    viewModel.toggleTorch();

    final scanner = _scanner;
    if (scanner == null || !scanner.value.isRunning) return;
    final isOn = scanner.value.torchState == TorchState.on;
    if (viewModel.torchOn != isOn) {
      unawaited(scanner.toggleTorch().catchError((_) {}));
    }
  }
}

/// The moving scan line (`.scan-line` of the HTML design).
class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..repeat(reverse: true);

  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          final alignment = Alignment(0, -1 + 2 * _progress.value);
          return Stack(
            fit: StackFit.expand,
            children: [
              // Soft halo trailing the line so the sweep reads clearly
              // over bright parts of the camera feed.
              Align(
                alignment: alignment,
                child: IgnorePointer(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 0.24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.brandBright.withValues(alpha: 0),
                            AppColors.brandBright.withValues(alpha: 0.13),
                            AppColors.brandBright.withValues(alpha: 0),
                          ],
                          stops: const [0, 0.5, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: alignment,
                child: IgnorePointer(
                  child: Container(
                    height: dynamicHeight(2),
                    margin: EdgeInsets.symmetric(horizontal: dynamicWidth(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.brandBright.withValues(alpha: 0),
                          AppColors.brandBright,
                          AppColors.brandBright.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.5, 1],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandBright.withValues(alpha: 0.6),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
