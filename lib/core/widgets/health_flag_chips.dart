import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../models/health_flag.dart';
import '../theme/app_colors.dart';

/// Toggle chips for the health-flag preference from the HTML design.
/// Used by the profile-setup screen and the Profile tab.
class HealthFlagChips extends StatelessWidget {
  const HealthFlagChips({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final Set<HealthFlag> selected;
  final ValueChanged<HealthFlag> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final flag in HealthFlag.values)
          _FlagChip(
            label: flag.localizedLabel(l10n),
            selected: selected.contains(flag),
            onTap: () => onToggle(flag),
          ),
      ],
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.brand : AppColors.line,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected
                    ? AppColors.brandDark
                    : AppColors.inkSecondary,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 5),
              const Icon(Icons.check, size: 15, color: AppColors.brand),
            ],
          ],
        ),
      ),
    );
  }
}
