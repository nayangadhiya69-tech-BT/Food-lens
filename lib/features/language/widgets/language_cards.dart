import 'package:flutter/material.dart';

import '../../../core/constants/app_locales.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Radio-style language cards from the HTML design
/// (profile setup / language screens).
class LanguageCards extends StatelessWidget {
  const LanguageCards({
    super.key,
    required this.selectedCode,
    required this.onSelected,
  });

  final String selectedCode;
  final ValueChanged<String> onSelected;

  String _labelFor(AppLocalizations l10n, String code) => switch (code) {
        'hi' => l10n.languageHindi,
        'gu' => l10n.languageGujarati,
        _ => l10n.languageEnglish,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        for (final code in AppLocales.supportedCodes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _LanguageCard(
              label: _labelFor(l10n, code),
              selected: selectedCode == code,
              onTap: () => onSelected(code),
            ),
          ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
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
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.brand : AppColors.line,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.brand : AppColors.line,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: selected
                    ? Container(
                        key: const ValueKey('selected'),
                        decoration: const BoxDecoration(
                          color: AppColors.brand,
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('unselected')),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
