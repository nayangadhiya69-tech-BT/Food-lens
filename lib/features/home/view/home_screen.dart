import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/load_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
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
        return CommonWidgets.loading(label: l10n.loadingLabel);
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
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              _Greeting(overview: overview),
              _ScanCta(onTap: () => _scanUnavailable(context)),
              _StatsRow(overview: overview),
              CommonWidgets.sectionLabel(l10n.recentScansLabel),
              if (viewModel.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeGreeting(overview.userName),
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.inkSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                overview.location.isEmpty
                    ? l10n.homeLocation
                    : overview.location,
                style: const TextStyle(
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
          margin: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.brand,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scanCtaTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.scanCtaSubtitle,
                      style: TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              value: overview.scansThisWeek.toString(),
              label: l10n.statScansWeekLabel,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              value: overview.flagsCaught.toString(),
              label: l10n.statFlagsLabel,
            ),
          ),
          const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
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
