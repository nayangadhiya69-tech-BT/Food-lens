import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_scaffold.dart';
import '../../common/widgets/common_toast.dart';
import '../model/scan_result.dart';
import '../view_model/scan_view_model.dart';

/// HTML screen 10 — Result: stat strip, flag banner (flag-count
/// language, never a verdict about the product), the depth card and the
/// flags found on this label. Back returns Home like the design;
/// "See full label decode" (screen 11) is not part of this build, so it
/// shows an honest notice.
class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ScanViewModel>();
    final result = viewModel.result;

    if (result == null) {
      // The processing screen only pushes here once the analysis is
      // done; a direct entry shows the shared loading state instead.
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: CommonWidgets.loading()),
      );
    }

    return CommonScaffold(
      title: result.name,
      subtitle: result.subtitle,
      onBack: () {
        context.read<ScanViewModel>().endSession();
        context.go(AppRoutes.home);
      },
      trailing: Semantics(
        button: true,
        label: l10n.shareUnavailable,
        child: GestureDetector(
          onTap: () => CommonToast.show(
            context,
            message: l10n.shareUnavailable,
            type: ToastType.info,
          ),
          child: Container(
            width: dynamicWidth(30),
            height: dynamicWidth(30),
            decoration: const BoxDecoration(
              color: AppColors.brandBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, size: 15, color: AppColors.brand),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatStrip(stats: result.stats),
          SizedBox(height: dynamicHeight(14)),
          _FlagBanner(count: result.flaggedCount, body: result.bannerBody),
          SizedBox(height: dynamicHeight(14)),
          _DepthCard(depth: result.depth),
          SizedBox(height: dynamicHeight(10)),
          _LabelFlagsCard(flags: result.labelFlags),
          SizedBox(height: dynamicHeight(16)),
          CommonButton(
            label: l10n.scanFullDecode,
            onPressed: () => CommonToast.show(
              context,
              message: l10n.fullDecodeUnavailable,
              type: ToastType.info,
            ),
          ),
          SizedBox(height: dynamicHeight(10)),
          Text(
            l10n.disclaimerText,
            textAlign: TextAlign.center,
            style: AppTextStyle.create(
              fontSize: 10.5,
              color: AppColors.inkTertiary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontally scrolling strip of the five result figures.
class _StatStrip extends StatelessWidget {
  const _StatStrip({required this.stats});

  final List<ScanStat> stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String labelOf(ScanStatKey key) => switch (key) {
      ScanStatKey.sodium => l10n.scanStatSodiumLabel,
      ScanStatKey.condition => l10n.scanStatConditionLabel,
      ScanStatKey.additives => l10n.scanStatAdditivesLabel,
      ScanStatKey.allergens => l10n.scanStatAllergensLabel,
      ScanStatKey.score => l10n.scanStatScoreLabel,
    };

    Color colorOf(ScanStatKey key) => switch (key) {
      ScanStatKey.sodium => AppColors.danger,
      ScanStatKey.condition => AppColors.warning,
      ScanStatKey.additives => AppColors.ink,
      ScanStatKey.allergens => AppColors.ink,
      ScanStatKey.score => AppColors.brand,
    };

    return SizedBox(
      height: dynamicHeight(84),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, _) => SizedBox(width: dynamicWidth(8)),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            width: dynamicWidth(96),
            padding: EdgeInsets.symmetric(
              horizontal: dynamicWidth(8),
              vertical: dynamicHeight(12),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                Text(
                  stat.value,
                  style: AppTextStyle.create(
                    fontSize: 18,
                    weight: FontWeights.bold,
                    color: colorOf(stat.key),
                  ),
                ),
                SizedBox(height: dynamicHeight(4)),
                Expanded(
                  child: Text(
                    labelOf(stat.key).toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.create(
                      fontSize: 9.5,
                      weight: FontWeights.bold,
                      color: AppColors.inkSecondary,
                      letterSpacing: 0.3,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Danger-tinted banner: how many things are flagged, and why they are.
class _FlagBanner extends StatelessWidget {
  const _FlagBanner({required this.count, required this.body});

  final int count;
  final String body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.dangerBackground,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.dangerLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scanBannerTitle(count),
            style: AppTextStyle.create(
              fontSize: 13,
              weight: FontWeights.bold,
              color: AppColors.danger,
            ),
          ),
          SizedBox(height: dynamicHeight(5)),
          Text(
            body,
            style: AppTextStyle.create(
              fontSize: 11.5,
              color: AppColors.dangerText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Decoded in depth" card: one nutrient read down to its ingredient.
class _DepthCard extends StatelessWidget {
  const _DepthCard({required this.depth});

  final DepthDecode depth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scanDepthLabel.toUpperCase(),
            style: AppTextStyle.create(
              fontSize: 10,
              weight: FontWeights.bold,
              color: AppColors.inkSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: dynamicHeight(8)),
          Text(
            depth.title,
            style: AppTextStyle.create(
              fontSize: 13,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(4)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: depth.amount,
                  style: AppTextStyle.create(
                    fontSize: 15,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
                TextSpan(
                  text: ' ${depth.detail} ',
                  style: AppTextStyle.create(
                    fontSize: 11,
                    color: AppColors.inkSecondary,
                  ),
                ),
                TextSpan(
                  text: depth.percent,
                  style: AppTextStyle.create(
                    fontSize: 11,
                    weight: FontWeights.bold,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: dynamicHeight(10)),
          Container(height: 1, color: AppColors.lineLight),
          SizedBox(height: dynamicHeight(10)),
          CommonWidgets.pill(
            label: depth.pill,
            background: AppColors.lineLight,
            foreground: AppColors.inkSecondary,
          ),
          SizedBox(height: dynamicHeight(7)),
          Text(
            depth.ingredient,
            style: AppTextStyle.create(
              fontSize: 12,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(3)),
          Text(
            depth.note,
            style: AppTextStyle.create(
              fontSize: 11.5,
              color: AppColors.inkSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Flags on this label" card: each finding with its figure.
class _LabelFlagsCard extends StatelessWidget {
  const _LabelFlagsCard({required this.flags});

  final List<LabelFlag> flags;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scanLabelFlagsLabel.toUpperCase(),
            style: AppTextStyle.create(
              fontSize: 10,
              weight: FontWeights.bold,
              color: AppColors.inkSecondary,
              letterSpacing: 0.5,
            ),
          ),
          for (var i = 0; i < flags.length; i++) ...[
            if (i > 0) ...[
              SizedBox(height: dynamicHeight(9)),
              Container(height: 1, color: AppColors.lineLight),
              SizedBox(height: dynamicHeight(9)),
            ] else
              SizedBox(height: dynamicHeight(10)),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 15,
                  color: AppColors.danger,
                ),
                SizedBox(width: dynamicWidth(7)),
                Expanded(
                  child: Text(
                    flags[i].title,
                    style: AppTextStyle.create(
                      fontSize: 12,
                      weight: FontWeights.semibold,
                      color: AppColors.ink,
                      height: 1.35,
                    ),
                  ),
                ),
                SizedBox(width: dynamicWidth(8)),
                Text(
                  flags[i].value,
                  style: AppTextStyle.create(
                    fontSize: 12,
                    weight: FontWeights.bold,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
