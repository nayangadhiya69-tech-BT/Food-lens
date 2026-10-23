import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/load_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_scaffold.dart';
import '../../common/widgets/common_shimmer.dart';
import '../../common/widgets/common_toast.dart';
import '../domain/nutrition_calculator.dart';
import '../view_model/my_day_view_model.dart';
import 'widgets/day_item_tile.dart';
import 'widgets/food_pick_tile.dart';
import 'widgets/limit_progress_card.dart';
import 'widgets/my_day_note.dart';
import 'widgets/portion_amount_card.dart';

/// My Day tab: the reference's four-step daily tracker — pick what you
/// ate, say how much, see the day against WHO limits, then add more or
/// go home (where the same totals appear on the Home dashboard).
class MyDayScreen extends StatelessWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MyDayViewModel is registered app-scope (see app_providers.dart) so
    // the Home dashboard always shows the same totals.
    return const _MyDayView();
  }
}

class _MyDayView extends StatelessWidget {
  const _MyDayView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyDayViewModel>();
    final l10n = AppLocalizations.of(context);

    switch (viewModel.state) {
      case LoadState.loading:
        return CommonScaffold(
          title: l10n.myDayTitle,
          scrollable: false,
          body: const _MyDayShimmer(),
        );
      case LoadState.error:
        return CommonScaffold(
          title: l10n.myDayTitle,
          scrollable: false,
          body: CommonWidgets.errorWidget(
            message: l10n.myDayError,
            retryLabel: l10n.actionRetry,
            onRetry: viewModel.load,
          ),
        );
      case LoadState.success:
        switch (viewModel.step) {
          case MyDayStep.pick:
            return const _PickStep();
          case MyDayStep.amounts:
            return const _AmountsStep();
          case MyDayStep.summary:
            return viewModel.hasEntries
                ? const _SummaryStep()
                : const _EmptyDayStep();
        }
    }
  }
}

/// Step 1 — "Pick what you ate": the catalog with multi-select rows and
/// the "Parse and Add to List" action (disabled until something is on).
class _PickStep extends StatelessWidget {
  const _PickStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<MyDayViewModel>();
    final count = viewModel.pickedCount;

    return CommonScaffold(
      title: l10n.myDayPickTitle,
      subtitle: l10n.myDayPickSubtitle,
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.only(
          top: dynamicHeight(14),
          bottom: dynamicHeight(16),
        ),
        children: [
          CommonWidgets.sectionLabel(l10n.myDayRecentScansLabel),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Column(
              children: [
                for (final product in viewModel.catalog)
                  FoodPickTile(
                    product: product,
                    selected: viewModel.isPicked(product.id),
                    onTap: () => viewModel.togglePick(product.id),
                  ),
                MyDayNote(icon: '💡', text: l10n.myDayPickNote),
              ],
            ),
          ),
        ],
      ),
      footer: CommonButton(
        label: l10n.myDayParseAdd,
        badgeCount: count,
        onPressed: count == 0
            ? null
            : () {
                if (!viewModel.confirmSelection()) {
                  CommonToast.show(
                    context,
                    message: l10n.myDayNothingSelected,
                    type: ToastType.warning,
                  );
                }
              },
      ),
    );
  }
}

/// Step 2 — "How much did you have?": per-product presets, stepper and
/// live nutrition; every card edits its own product independently.
class _AmountsStep extends StatelessWidget {
  const _AmountsStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<MyDayViewModel>();

    return CommonScaffold(
      title: l10n.myDayAmountTitle,
      subtitle: l10n.myDayAmountSubtitle,
      onBack: viewModel.backToPick,
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.only(
          top: dynamicHeight(14),
          bottom: dynamicHeight(16),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Column(
              children: [
                for (final amount in viewModel.amounts.entries)
                  Builder(
                    builder: (context) {
                      final product = viewModel.productById(amount.key);
                      if (product == null) return const SizedBox.shrink();
                      final totals = NutritionCalculator.totalsFor(
                        product,
                        amount.value,
                      );
                      return PortionAmountCard(
                        product: product,
                        grams: amount.value,
                        itemTotals: totals,
                        onPreset: (grams) =>
                            viewModel.setAmount(product.id, grams),
                        onBump: (delta) =>
                            viewModel.bumpAmount(product.id, delta),
                      );
                    },
                  ),
                MyDayNote(icon: '⚖️', text: l10n.myDayAmountNote),
              ],
            ),
          ),
        ],
      ),
      footer: CommonButton(
        label: l10n.myDayCalculate,
        loading: viewModel.isSaving,
        loadingLabel: l10n.myDayCalculating,
        onPressed: () async {
          final ok = await viewModel.calculateDay();
          if (!context.mounted || ok) return;
          CommonToast.show(
            context,
            message: l10n.myDayQuantityInvalid,
            type: ToastType.error,
          );
        },
      ),
    );
  }
}

/// Step 3 — "My day": totals against the limits, the correction note
/// when relevant, and the itemized breakdown with remove buttons.
class _SummaryStep extends StatelessWidget {
  const _SummaryStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<MyDayViewModel>();

    return CommonScaffold(
      title: l10n.myDayTitle,
      subtitle: l10n.myDaySummarySubtitle(viewModel.entries.length),
      onBack: viewModel.backToAmounts,
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.only(
          top: dynamicHeight(14),
          bottom: dynamicHeight(16),
        ),
        children: [
          CommonWidgets.sectionLabel(l10n.myDayAgainstLimitLabel),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Column(
              children: [
                for (final progress in viewModel.limitProgress)
                  LimitProgressCard(progress: progress),
              ],
            ),
          ),
          if (viewModel.hasFreeSugarCorrection)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
              child: MyDayNote(icon: '🍯', text: l10n.myDayHoneyNote),
            ),
          CommonWidgets.sectionLabel(l10n.myDayWhatMadeItUp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Column(
              children: [
                for (final entry in viewModel.entries)
                  Builder(
                    builder: (context) {
                      final product = viewModel.productById(entry.productId);
                      if (product == null) return const SizedBox.shrink();
                      return DayItemTile(
                        product: product,
                        entry: entry,
                        itemTotals: NutritionCalculator.totalsFor(
                          product,
                          entry.amountG,
                        ),
                        onRemove: () async {
                          final saved = await viewModel.removeEntry(
                            entry.productId,
                          );
                          if (!context.mounted || saved) return;
                          CommonToast.show(
                            context,
                            message: l10n.myDaySaveError,
                            type: ToastType.error,
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dynamicWidth(20),
              vertical: dynamicHeight(12),
            ),
            child: Text(
              l10n.myDaySourceNote,
              textAlign: TextAlign.center,
              style: AppTextStyle.create(
                fontSize: 11,
                color: AppColors.inkTertiary,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonButton(
            label: l10n.myDayAddAnother,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.ink,
              side: const BorderSide(color: AppColors.line, width: 1.5),
            ),
            onPressed: viewModel.goToPick,
          ),
          SizedBox(height: dynamicHeight(10)),
          CommonButton(
            label: l10n.myDayGoHome,
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}

/// Step 4 — empty state shown when the day has no items left.
class _EmptyDayStep extends StatelessWidget {
  const _EmptyDayStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<MyDayViewModel>();

    return CommonScaffold(
      title: l10n.myDayTitle,
      subtitle: l10n.myDayNothingAddedYet,
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.only(
          top: dynamicHeight(14),
          bottom: dynamicHeight(16),
        ),
        children: [
          CommonWidgets.emptyWidget(
            icon: Icons.restaurant_outlined,
            message: l10n.myDayEmptyBody,
          ),
          CommonWidgets.sectionLabel(l10n.myDayWhyBotherLabel),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Container(
              padding: EdgeInsets.all(dynamicWidth(15)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.myDayWhyBotherTitle,
                    style: AppTextStyle.create(
                      fontSize: 15,
                      weight: FontWeights.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: dynamicHeight(4)),
                  Text(
                    l10n.myDayWhyBotherBody,
                    style: AppTextStyle.create(
                      fontSize: 12,
                      color: AppColors.inkSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      footer: CommonButton(
        label: l10n.myDayAddFirstItem,
        onPressed: viewModel.goToPick,
      ),
    );
  }
}

/// First-load skeleton matching the pick layout.
class _MyDayShimmer extends StatelessWidget {
  const _MyDayShimmer();

  @override
  Widget build(BuildContext context) {
    return CommonShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: dynamicHeight(14)),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              dynamicWidth(16),
              dynamicHeight(18),
              dynamicWidth(16),
              dynamicHeight(8),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              alignment: Alignment.centerLeft,
              child: ShimmerBox(height: 10, radius: 4, color: AppColors.line),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicWidth(16)),
            child: Column(
              children: [
                for (var i = 0; i < 5; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: dynamicHeight(9)),
                    child: ShimmerBox(
                      height: 66,
                      radius: 15,
                      color: AppColors.line,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
