import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/common_button.dart';
import '../../model/food_product.dart';
import '../../model/nutrient_totals.dart';
import 'my_day_labels.dart';
import 'my_day_note.dart';

/// One "How much did you have?" card: product header, four preset
/// chips, an optional amber caveat, the −/+ stepper with the human
/// amount and gram truth, and live nutrition for the current quantity.
class PortionAmountCard extends StatelessWidget {
  final FoodProduct product;

  final double grams;
  final ValueChanged<double> onPreset;
  final ValueChanged<double> onBump;
  final NutrientTotals itemTotals;
  const PortionAmountCard({
    super.key,
    required this.product,
    required this.grams,
    required this.onPreset,
    required this.onBump,
    required this.itemTotals,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = MyDayLabels.of(context);
    final presets = product.presets;
    final step = product.step;
    final caveat = MyDayLabels.caveat(l10n, product);

    return Container(
      margin: EdgeInsets.only(bottom: dynamicHeight(11)),
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hexToColor("E4DED2")),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${product.icon} ${product.name}',
            style: AppTextStyle.create(
              fontSize: 15,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(2)),
          Text(
            '${product.packSizeLabel} · ${MyDayLabels.formWord(l10n, product)}',
            style: AppTextStyle.create(
              fontSize: 12,
              color: AppColors.hexToColor("8A8377"),
            ),
          ),
          SizedBox(height: dynamicHeight(11)),
          Row(
            children: [
              for (var i = 0; i < presets.length; i++) ...[
                if (i > 0) SizedBox(width: dynamicWidth(6)),
                Expanded(
                  child: _PresetChip(
                    preset: presets[i],
                    selected: (grams - presets[i].grams).abs() < 0.6,
                    onTap: () => onPreset(presets[i].grams),
                  ),
                ),
              ],
            ],
          ),
          if (caveat != null) ...[
            SizedBox(height: dynamicHeight(10)),
            MyDayNote(text: caveat, compact: true),
          ],
          SizedBox(height: dynamicHeight(11)),
          Row(
            children: [
              _StepperButton(
                icon: Icons.remove,
                semanticsLabel: '-',
                onTap: () => onBump(-step),
              ),
              Expanded(
                child: Semantics(
                  button: true,
                  label: '${l10n.myDayEditQuantity} ${product.name}',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showEditDialog(context),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: dynamicWidth(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            product.sayAmount(grams),
                            textAlign: TextAlign.center,
                            style: AppTextStyle.create(
                              fontSize: 22,
                              weight: FontWeights.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            l10n.myDayGramsCounted(MyDayLabels.fmtG(grams)),
                            textAlign: TextAlign.center,
                            style: AppTextStyle.create(
                              fontSize: 12,
                              weight: FontWeights.semibold,
                              color: AppColors.hexToColor("8A8377"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add,
                semanticsLabel: '+',
                onTap: () => onBump(step),
              ),
            ],
          ),
          // SizedBox(height: dynamicHeight(11)),
          // NutritionMiniChips(
          //   sugarG: itemTotals.sugarG,
          //   sodiumMg: itemTotals.sodiumMg,
          //   saturatedFatG: itemTotals.saturatedFatG,
          // ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: MyDayLabels.fmtG(grams));
    String? errorText;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(product.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  suffixText: 'g',
                  errorText: errorText,
                ),
                onChanged: (_) => setState(() => errorText = ''),
              ),
              SizedBox(height: dynamicHeight(8)),
              Text(
                product.packSizeLabel,
                style: AppTextStyle.create(
                  fontSize: 12,
                  color: AppColors.inkTertiary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.actionCancel),
            ),
            CommonButton(
              label: l10n.actionSave,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(dynamicWidth(100), dynamicHeight(44)),
                padding: EdgeInsets.symmetric(
                  horizontal: dynamicWidth(16),
                  vertical: dynamicHeight(10),
                ),
              ),
              onPressed: () {
                final parsed = double.tryParse(controller.text.trim());
                if (parsed == null ||
                    !parsed.isFinite ||
                    parsed <= 0 ||
                    parsed > product.maxAmount) {
                  setState(
                    () =>
                        errorText = parsed != null && parsed > product.maxAmount
                        ? l10n.myDayQuantityTooHigh
                        : l10n.myDayQuantityInvalid,
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final parsed = double.tryParse(controller.text.trim());
      if (parsed != null) onPreset(parsed);
    }
    controller.dispose();
  }
}

class _PresetChip extends StatelessWidget {
  final FoodPreset preset;

  final bool selected;
  final VoidCallback onTap;
  const _PresetChip({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${preset.label} ${preset.sub}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(3),
            vertical: dynamicHeight(8),
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : AppColors.hexToColor("#f4f0e7"),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.brand
                  : AppColors.hexToColor("8A8377").withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                preset.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyle.create(
                  fontSize: 11.5,
                  weight: FontWeights.bold,
                  color: selected
                      ? Colors.white
                      : AppColors.hexToColor("5C574E"),
                ),
              ),

              Text(
                preset.sub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyle.create(
                  fontSize: 10,
                  weight: FontWeights.semibold,
                  color: selected
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.hexToColor("8A8377"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;

  final String semanticsLabel;
  final VoidCallback onTap;
  const _StepperButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: dynamicWidth(44),
          height: dynamicWidth(44),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.hexToColor("E4DED2"),
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: 22, color: AppColors.brandDark),
        ),
      ),
    );
  }
}
