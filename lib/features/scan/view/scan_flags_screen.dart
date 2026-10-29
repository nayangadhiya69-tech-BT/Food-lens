import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/health_flag_chips.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_scaffold.dart';
import '../view_model/scan_view_model.dart';

/// The flag step between capture and processing: "Anything we should
/// flag for, if present?" (the same preference the profile-setup screen
/// collects, pre-filled from what's already saved — see `flagNote` for
/// what it does). Continue persists the selection and pushes the
/// processing checklist.
class ScanFlagsScreen extends StatelessWidget {
  const ScanFlagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ScanViewModel>();

    return CommonScaffold(
      title: l10n.healthFlagsSheetTitle,
      onBack: () {
        if (context.canPop()) {
          context.read<ScanViewModel>().restoreResult();
          context.pop();
        } else {
          context.go(AppRoutes.scan);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.flagQuestionLabel,
            style: AppTextStyle.create(
              fontSize: 13,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(12)),
          HealthFlagChips(
            selected: viewModel.selectedFlags,
            onToggle: viewModel.toggleFlag,
          ),
          SizedBox(height: dynamicHeight(12)),
          Text(
            l10n.flagNote,
            style: AppTextStyle.create(
              fontSize: 12,
              color: AppColors.inkTertiary,
              height: 1.55,
            ),
          ),
        ],
      ),
      footer: CommonButton(
        label: l10n.actionContinue,
        onPressed: () async {
          await context.read<ScanViewModel>().confirmFlags();
          if (!context.mounted) return;
          context.push(AppRoutes.scanProcessing);
        },
      ),
    );
  }
}
