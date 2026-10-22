import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/load_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/widgets.dart';
import '../../history/view/widgets/scan_record_tile.dart';
import '../model/home_overview.dart';
import '../repository/home_repository.dart';
import '../view_model/home_view_model.dart';

/// HTML screen 5 — Home: greeting, scan CTA, quick stats and recent scans.
/// The scan flow itself is not part of this build, so scan entry points
/// show an honest "not available" notice instead of pretending to work.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) =>
          HomeViewModel(context.read<HomeRepository>())..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _scanUnavailable(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    AppUtils.showSnackBar(
      context,
      message: l10n.scanUnavailable,
      type: SnackBarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildBody(context, l10n, viewModel)),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    HomeViewModel viewModel,
  ) {
    switch (viewModel.state) {
      case LoadState.loading:
        // First load: skeleton shimmer matching the real layout. On
        // pull-to-refresh the loaded content stays visible instead.
        return const _HomeShimmer();
      case LoadState.error:
        return CommonWidgets.errorWidget(
          message: l10n.homeError,
          retryLabel: l10n.actionRetry,
          onRetry: viewModel.load,
        );
      case LoadState.success:
        final overview = viewModel.overview!;
        return RefreshIndicator(
          onRefresh: viewModel.load,
          color: AppColors.brand,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: dynamicHeight(20)),
            children: [
              _Greeting(overview: overview),
              _ScanCta(onTap: () => _scanUnavailable(context)),
              _StatsRow(overview: overview),
              CommonWidgets.sectionLabel(l10n.recentScansLabel),
              if (viewModel.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
                  child: CommonWidgets.emptyWidget(
                    icon: Icons.qr_code_scanner,
                    message: l10n.homeEmptyTitle,
                    subtitle: l10n.homeEmptySubtitle,
                  ),
                )
              else
                for (var i = 0; i < overview.recentScans.length; i++)
                  ScanRecordTile(
                    record: overview.recentScans[i],
                    showDivider: i != overview.recentScans.length - 1,
                    onTap: () {
                      final l10n = AppLocalizations.of(context);
                      AppUtils.showSnackBar(
                        context,
                        message: l10n.recentScanUnavailable,
                        type: SnackBarType.info,
                      );
                    },
                  ),
            ],
          ),
        );
    }
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.overview});

  final HomeOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        dynamicWidth(16),
        dynamicHeight(18),
        dynamicWidth(16),
        dynamicHeight(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeGreeting(overview.userName),
            style: AppTextStyle.create(
              fontSize: 21,
              weight: FontWeights.bold,
              color: AppColors.ink,
              height: 1.3,
            ),
          ),
          SizedBox(height: dynamicHeight(4)),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.inkSecondary,
              ),
              SizedBox(width: dynamicWidth(4)),
              Text(
                overview.location.isEmpty
                    ? l10n.homeLocation
                    : overview.location,
                style: AppTextStyle.create(
                  fontSize: 13,
                  color: AppColors.inkSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScanCta extends StatelessWidget {
  const _ScanCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: l10n.scanCtaSemantics,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            dynamicWidth(16),
            dynamicHeight(14),
            dynamicWidth(16),
            dynamicHeight(16),
          ),
          padding: EdgeInsets.all(dynamicWidth(18)),
          decoration: BoxDecoration(
            color: AppColors.brand,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: dynamicWidth(54),
                height: dynamicHeight(54),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: dynamicWidth(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scanCtaTitle,
                      style: AppTextStyle.create(
                        fontSize: 17,
                        weight: FontWeights.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(3)),
                    Text(
                      l10n.scanCtaSubtitle,
                      style: AppTextStyle.create(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.overview});

  final HomeOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              value: overview.scansThisWeek.toString(),
              label: l10n.statScansWeekLabel,
            ),
          ),
          SizedBox(width: dynamicWidth(8)),
          Expanded(
            child: _StatCard(
              value: overview.flagsCaught.toString(),
              label: l10n.statFlagsLabel,
            ),
          ),
          SizedBox(width: dynamicWidth(8)),
          Expanded(
            child: _StatCard(
              value: overview.languagesUsed.toString(),
              label: l10n.statLanguagesLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(6),
        vertical: dynamicHeight(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyle.create(
              fontSize: 22,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(3)),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.create(
              fontSize: 10,
              weight: FontWeights.bold,
              color: AppColors.inkSecondary,
              letterSpacing: 0.4,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// First-load skeleton mirroring the real home layout (greeting, scan CTA,
/// stats row, section label, recent-scan rows) so data snaps into place.
class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return CommonShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: dynamicHeight(20)),
        children: [
          // Greeting block — same padding as _Greeting.
          Padding(
            padding: EdgeInsets.fromLTRB(
              dynamicWidth(16),
              dynamicHeight(18),
              dynamicWidth(16),
              dynamicHeight(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  alignment: Alignment.centerLeft,
                  child: ShimmerBox(
                    height: 20,
                    radius: 4,
                    color: AppColors.line,
                  ),
                ),
                SizedBox(height: dynamicHeight(6)),
                Row(
                  children: [
                    const ShimmerBox(
                      width: 14,
                      height: 14,
                      circle: true,
                      color: AppColors.line,
                    ),
                    SizedBox(width: dynamicWidth(6)),
                    const Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 0.3,
                        alignment: Alignment.centerLeft,
                        child: ShimmerBox(
                          height: 10,
                          radius: 4,
                          color: AppColors.line,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Scan CTA card — same margin/padding/radius as _ScanCta.
          Container(
            margin: EdgeInsets.fromLTRB(
              dynamicWidth(16),
              dynamicHeight(14),
              dynamicWidth(16),
              dynamicHeight(16),
            ),
            padding: EdgeInsets.all(dynamicWidth(18)),
            decoration: BoxDecoration(
              color: AppColors.lineLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ShimmerBox(
                  width: 54,
                  height: 54,
                  radius: 14,
                  color: AppColors.line,
                ),
                SizedBox(width: dynamicWidth(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        alignment: Alignment.centerLeft,
                        child: ShimmerBox(
                          height: 14,
                          radius: 4,
                          color: AppColors.line,
                        ),
                      ),
                      SizedBox(height: dynamicHeight(6)),
                      FractionallySizedBox(
                        widthFactor: 0.7,
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
              ],
            ),
          ),
          // Stats row — same metrics as _StatsRow/_StatCard.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Row(
              children: [
                const Expanded(child: _ShimmerStatCard()),
                SizedBox(width: dynamicWidth(8)),
                const Expanded(child: _ShimmerStatCard()),
                SizedBox(width: dynamicWidth(8)),
                const Expanded(child: _ShimmerStatCard()),
              ],
            ),
          ),
          // Section label — same padding as CommonWidgets.sectionLabel.
          Padding(
            padding: EdgeInsets.fromLTRB(
              dynamicWidth(16),
              dynamicHeight(18),
              dynamicWidth(16),
              dynamicHeight(8),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.25,
              alignment: Alignment.centerLeft,
              child: ShimmerBox(height: 10, radius: 4, color: AppColors.line),
            ),
          ),
          const ShimmerListTile(),
          const ShimmerListTile(),
          const ShimmerListTile(showDivider: false),
        ],
      ),
    );
  }
}

/// Stat-card skeleton with the real card's surface, border and padding.
class _ShimmerStatCard extends StatelessWidget {
  const _ShimmerStatCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(6),
        vertical: dynamicHeight(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.4,
            child: ShimmerBox(height: 18, radius: 4, color: AppColors.line),
          ),
          SizedBox(height: dynamicHeight(5)),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: ShimmerBox(height: 8, radius: 4, color: AppColors.line),
          ),
        ],
      ),
    );
  }
}
