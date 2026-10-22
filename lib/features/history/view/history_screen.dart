import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/load_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/widgets.dart';
import '../repository/history_repository.dart';
import '../view_model/history_view_model.dart';
import '../view/widgets/scan_record_tile.dart';

/// History tab — full list of scans with loading, empty and error states.
/// The HTML design does not define this screen; it follows the same
/// visual language (header, rows, pills) as the reference.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryViewModel>(
      create: (context) =>
          HistoryViewModel(context.read<HistoryRepository>())..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<HistoryViewModel>();

    return CommonScaffold(
      title: l10n.historyTitle,
      trailing: CommonWidgets.pill(
        label: l10n.demoDataBadge,
        background: AppColors.lineLight,
        foreground: AppColors.inkSecondary,
      ),
      scrollable: false,
      body: _buildBody(context, l10n, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    HistoryViewModel viewModel,
  ) {
    switch (viewModel.state) {
      case LoadState.loading:
        // First load: skeleton rows matching ScanRecordTile. On
        // pull-to-refresh the loaded list stays visible instead.
        return CommonShimmer(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: dynamicHeight(12)),
            children: const [
              ShimmerListTile(),
              ShimmerListTile(),
              ShimmerListTile(),
              ShimmerListTile(showDivider: false),
            ],
          ),
        );
      case LoadState.error:
        return CommonWidgets.errorWidget(
          message: l10n.historyError,
          retryLabel: l10n.actionRetry,
          onRetry: viewModel.load,
        );
      case LoadState.success:
        if (viewModel.isEmpty) {
          return CommonWidgets.emptyWidget(
            icon: Icons.history,
            message: l10n.historyEmptyTitle,
            subtitle: l10n.historyEmptySubtitle,
          );
        }
        final records = viewModel.records;
        return RefreshIndicator(
          onRefresh: viewModel.load,
          color: AppColors.brand,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: dynamicHeight(12)),
            itemCount: records.length,
            itemBuilder: (context, index) => ScanRecordTile(
              record: records[index],
              showDivider: index != records.length - 1,
              onTap: () => AppUtils.showSnackBar(
                context,
                message: l10n.recentScanUnavailable,
                type: SnackBarType.info,
              ),
            ),
          ),
        );
    }
  }
}
