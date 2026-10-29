import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/widgets.dart';
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

    return CommonScaffold(
      title: l10n.languageScreenTitle,
      onBack: () => Navigator.of(context).maybePop(),
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          dynamicWidth(16),
          dynamicHeight(20),
          dynamicWidth(16),
          dynamicHeight(24),
        ),
        children: [
          Text(
            l10n.preferredLanguageLabel.toUpperCase(),
            style: AppTextStyle.create(
              fontSize: 12,
              weight: FontWeights.bold,
              color: AppColors.inkSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: dynamicHeight(6)),
          Text(
            l10n.languageVoiceNote,
            style: AppTextStyle.create(
              fontSize: 12.5,
              color: AppColors.inkSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: dynamicHeight(14)),
          LanguageCards(
            selectedCode: localeProvider.effectiveCode,
            onSelected: (code) => localeProvider.setLocale(code),
          ),
        ],
      ),
    );
  }
}
