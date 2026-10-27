import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../model/scan_mode.dart';
import '../view_model/scan_view_model.dart';

/// HTML screen 9 — Processing: a checklist of what is actually
/// happening (barcode match, extraction, additive check, scoring)
/// instead of a bare spinner. The shared view model drives the steps
/// and the analysis; when the result lands this screen replaces itself
/// with the result screen.
class ScanProcessingScreen extends StatefulWidget {
  const ScanProcessingScreen({super.key});

  @override
  State<ScanProcessingScreen> createState() => _ScanProcessingScreenState();
}

/// Indeterminate-looking ring that fills across the whole checklist —
/// same partial fill as the design's SVG ring.
class _ProgressRing extends StatelessWidget {
  final Animation<double> animation;

  const _ProgressRing({required this.animation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dynamicWidth(84),
      height: dynamicWidth(84),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => CircularProgressIndicator(
          // The design's ring sits at ~73% when the last step runs.
          value: animation.value * 0.73,
          strokeWidth: 7,
          backgroundColor: AppColors.lineLight,
          valueColor: const AlwaysStoppedAnimation(AppColors.brand),
        ),
      ),
    );
  }
}

class _ScanProcessingScreenState extends State<ScanProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: ScanViewModel.stepDuration * ScanViewModel.totalSteps,
  );

  /// Looked up once in initState — ancestor lookups are unsafe in
  /// dispose (this screen is unmounted by the replacement itself).
  late final ScanViewModel _viewModel;

  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ScanViewModel>();

    if (viewModel.phase == ScanPhase.error) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: CommonWidgets.errorWidget(
            message: l10n.scanError,
            retryLabel: l10n.actionRetry,
            onRetry: viewModel.startProcessing,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(28)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ProgressRing(animation: _ring),
                SizedBox(height: dynamicHeight(18)),
                Text(
                  l10n.scanProcessingTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.create(
                    fontSize: 15,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: dynamicHeight(4)),
                Text(
                  viewModel.workingName,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.create(
                    fontSize: 12.5,
                    color: AppColors.inkSecondary,
                  ),
                ),
                SizedBox(height: dynamicHeight(22)),
                for (var i = 0; i < ScanViewModel.totalSteps; i++)
                  _StepRow(
                    label: _stepLabel(l10n, viewModel.mode, i),
                    status: i < viewModel.completedSteps
                        ? _StepStatus.done
                        : i == viewModel.completedSteps
                        ? _StepStatus.active
                        : _StepStatus.pending,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onProgress);
    _ring.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ScanViewModel>();
    _viewModel.addListener(_onProgress);
    _ring.forward(from: 0);
    // The steps must start *after* the first build: notifying providers
    // while the tree is building throws. Post-frame also means a retry
    // or a fresh entry always begins a clean run.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _viewModel.startProcessing();
    });
  }

  void _onProgress() {
    if (!mounted || _navigated) return;
    if (_viewModel.phase != ScanPhase.resultReady) return;
    _navigated = true;
    context.pushReplacement(AppRoutes.scanResult);
  }

  String _stepLabel(AppLocalizations l10n, ScanMode mode, int index) =>
      switch (index) {
        0 =>
          mode == ScanMode.barcode
              ? l10n.scanStepBarcodeMatched
              : l10n.scanStepPhotosReceived,
        1 => l10n.scanStepNutrition,
        2 => l10n.scanStepAdditives,
        _ => l10n.scanStepScoring,
      };
}

class _StepDot extends StatelessWidget {
  final _StepStatus status;

  const _StepDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final size = dynamicWidth(18);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (status) {
          _StepStatus.done => AppColors.brand,
          _StepStatus.active => AppColors.surface,
          _StepStatus.pending => AppColors.lineLight,
        },
        border: status == _StepStatus.active
            ? Border.all(color: AppColors.brand, width: 2)
            : null,
      ),
      child: switch (status) {
        _StepStatus.done => const Icon(
          Icons.check,
          size: 12,
          color: Colors.white,
        ),
        _StepStatus.active => Container(
          width: dynamicWidth(6),
          height: dynamicWidth(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.brand,
          ),
        ),
        _StepStatus.pending => null,
      },
    );
  }
}

class _StepRow extends StatelessWidget {
  final String label;

  final _StepStatus status;
  const _StepRow({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _StepStatus.done => AppColors.ink,
      _StepStatus.active => AppColors.ink,
      _StepStatus.pending => AppColors.inkTertiary,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: dynamicHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepDot(status: status),
          SizedBox(width: dynamicWidth(12)),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.create(
                fontSize: 13,
                weight: status == _StepStatus.active
                    ? FontWeights.bold
                    : FontWeights.reg,
                color: color,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepStatus { done, active, pending }
