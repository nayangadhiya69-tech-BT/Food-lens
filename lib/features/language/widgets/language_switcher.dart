import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_locales.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../view_model/locale_provider.dart';

/// Compact segmented language switcher (`EN / हि / ગુ`) shown on the login
/// screen before sign-in, exactly like the HTML design.
///
/// Smoothness notes: the selected-chip background animates with an eased
/// curve and the label's weight/color morphs via [AnimatedDefaultTextStyle]
/// instead of snapping, so the row never "jumps" when the language changes.
/// The whole-app text swap is cross-faded separately in `app.dart`.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context);

    return Semantics(
      container: true,
      label: l10n.a11yLanguageSwitcher,
      child: Container(
        padding: EdgeInsets.all(dynamicWidth(3)),
        decoration: BoxDecoration(
          color: AppColors.lineLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final code in AppLocales.supportedCodes)
              _LanguageChip(
                label: AppLocales.chipLabels[code] ?? code.toUpperCase(),
                selected: localeProvider.effectiveCode == code,
                onTap: () => localeProvider.setLocale(code),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 240);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: _duration,
          curve: _curve,
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(11),
            vertical: dynamicHeight(6),
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: selected
                ? const [BoxShadow(color: AppColors.shadow, blurRadius: 2)]
                : null,
          ),
          // Morphs weight + color smoothly so the chip width animates too
          // instead of snapping (the main source of the visible "jerk").
          child: AnimatedDefaultTextStyle(
            duration: _duration,
            curve: _curve,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? AppColors.ink : AppColors.inkSecondary,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
