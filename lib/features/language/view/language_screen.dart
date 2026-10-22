import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/widgets/app_header.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../language/view_model/locale_provider.dart';
import '../../language/widgets/language_cards.dart';

/// Language preference screen (opened from Profile). Selecting a language
/// applies it immediately — no restart, no re-login.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: l10n.languageScreenTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            dynamicWidth(16),
            dynamicHeight(20),
            dynamicWidth(16),
            dynamicHeight(24),
          ),
          children: [
            Text(
              l10n.preferredLanguageLabel.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.inkSecondary,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: dynamicHeight(10)),
            LanguageCards(
              selectedCode: localeProvider.effectiveCode,
              onSelected: (code) => localeProvider.setLocale(code),
            ),
          ],
        ),
      ),
    );
  }
}
