import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../model/food_product.dart';
import 'my_day_labels.dart';

/// One tappable row on the "Pick what you ate" screen: 26×26 checkbox,
/// product name and the pack-size / form-word meta line. Selected rows
/// get the brand border + tint fill from the reference design.
class FoodPickTile extends StatelessWidget {
  const FoodPickTile({
    super.key,
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final FoodProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = MyDayLabels.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: product.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: EdgeInsets.only(bottom: dynamicHeight(9)),
          padding: EdgeInsets.all(dynamicWidth(13)),
          decoration: BoxDecoration(
            color: selected ? AppColors.brandBackground : AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? AppColors.brand : AppColors.line,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: dynamicWidth(26),
                height: dynamicWidth(26),
                decoration: BoxDecoration(
                  color: selected ? AppColors.brand : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected ? AppColors.brand : AppColors.line,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              SizedBox(width: dynamicWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.create(
                        fontSize: 15,
                        weight: FontWeights.bold,
                        color: AppColors.ink,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(3)),
                    Text(
                      '${product.packSizeLabel} · ${MyDayLabels.formWord(l10n, product)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.create(
                        fontSize: 12,
                        color: AppColors.inkTertiary,
                        height: 1.3,
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
