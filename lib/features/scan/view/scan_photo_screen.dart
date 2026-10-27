import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/common_toast.dart';
import '../view_model/scan_view_model.dart';
import 'widgets/scan_camera_shell.dart';
import 'widgets/scan_camera_support.dart';

/// HTML screen 8 — Camera capture: two photos per the product spec
/// (nutrition panel, then ingredients), taken with the live camera. The
/// thumbnail strip tracks progress; the second shutter completes the
/// capture and the flow moves on to the flag step. Without a camera the
/// screen falls back to the demo capture so the flow keeps working.
class ScanPhotoScreen extends StatefulWidget {
  const ScanPhotoScreen({super.key});

  @override
  State<ScanPhotoScreen> createState() => _ScanPhotoScreenState();
}

/// Label-shaped guide frame (`.label-box` of the HTML design).
class _LabelFrame extends StatelessWidget {
  const _LabelFrame();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dynamicWidth(210),
      height: dynamicHeight(250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
    );
  }
}

/// Two numbered thumbnails showing which of the two photos are done.
class _PhotoThumbs extends StatelessWidget {
  final int captured;

  const _PhotoThumbs({required this.captured});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dynamicHeight(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) SizedBox(width: dynamicWidth(8)),
            Container(
              width: dynamicWidth(34),
              height: dynamicWidth(34),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i < captured
                    ? AppColors.brand
                    : Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: i < captured
                      ? AppColors.brand
                      : Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                '${i + 1}',
                style: AppTextStyle.create(
                  fontSize: 13,
                  weight: FontWeights.bold,
                  color: i < captured
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScanPhotoScreenState extends State<ScanPhotoScreen> {
  CameraController? _camera;
  bool _unavailable = false;
  bool _starting = false;
  bool _capturing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ScanViewModel>();
    final camera = _camera;

    return ScanCameraShell(
      hint: viewModel.photoCount == 0
          ? l10n.scanPhotoHint1
          : l10n.scanPhotoHint2,
      torchOn: viewModel.torchOn,
      onToggleTorch: _toggleTorch,
      onClose: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.scan),
      onShutter: _onShutter,
      preview: !_unavailable && camera != null && camera.value.isInitialized
          // Loose constraints keep CameraPreview's AspectRatio honest
          // (a tight fill would stretch the texture).
          ? Center(child: CameraPreview(camera))
          : null,
      frame: _unavailable
          ? ScanCameraUnavailable(
              title: l10n.scanCameraUnavailableTitle,
              body: l10n.scanCameraUnavailableBody,
            )
          : const _LabelFrame(),
      footerNote: _PhotoThumbs(captured: viewModel.photoCount),
      trailingControl: Semantics(
        button: true,
        label: l10n.scanGalleryUnavailable,
        child: GestureDetector(
          onTap: () => CommonToast.show(
            context,
            message: l10n.scanGalleryUnavailable,
            type: ToastType.info,
          ),
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
  void dispose() {
    final camera = _camera;
    _camera = null;
    if (camera != null) {
      unawaited(camera.dispose().catchError((_) {}));
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (scanCameraDisabled) {
      _unavailable = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
    }
  }

  Future<void> _onShutter() async {
    final viewModel = context.read<ScanViewModel>();
    final l10n = AppLocalizations.of(context);
    if (_capturing) return;

    final camera = _camera;
    if (_unavailable || camera == null || !camera.value.isInitialized) {
      if (viewModel.capture()) {
        context.push(AppRoutes.scanFlags);
      }
      return;
    }

    _capturing = true;
    try {
      final file = await camera.takePicture();
      if (!mounted) return;
      if (viewModel.capture(photoPath: file.path)) {
        context.push(AppRoutes.scanFlags);
      }
    } catch (_) {
      if (!mounted) return;
      CommonToast.show(
        context,
        message: l10n.scanCaptureFallback,
        type: ToastType.info,
      );
      if (viewModel.capture()) {
        context.push(AppRoutes.scanFlags);
      }
    } finally {
      _capturing = false;
    }
  }

  /// Boots the live preview. The camera plugins request the camera
  /// permission themselves; any failure (denied, no hardware, tests)
  /// falls back to the demo shutter.
  Future<void> _startCamera() async {
    if (!mounted || _starting || _camera != null) return;
    _starting = true;

    CameraController? controller;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('noCamera', 'No cameras available.');
      }
      var description = cameras.first;
      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          description = camera;
          break;
        }
      }

      controller = CameraController(
        description,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }
      final ready = controller;
      setState(() => _camera = ready);
    } catch (_) {
      final failed = controller;
      controller = null;
      if (failed != null) {
        try {
          await failed.dispose();
        } catch (_) {
          // Best effort — the platform session may already be gone.
        }
      }
      if (mounted) {
        setState(() => _unavailable = true);
      }
    } finally {
      _starting = false;
    }
  }

  void _toggleTorch() {
    final viewModel = context.read<ScanViewModel>();
    viewModel.toggleTorch();

    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;
    unawaited(
      camera
          .setFlashMode(viewModel.torchOn ? FlashMode.torch : FlashMode.off)
          .catchError((_) {}),
    );
  }
}
