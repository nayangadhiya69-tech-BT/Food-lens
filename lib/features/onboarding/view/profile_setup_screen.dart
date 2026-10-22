import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/health_flag_chips.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../language/view_model/locale_provider.dart';
import '../../language/widgets/language_cards.dart';
import '../view_model/setup_view_model.dart';

/// HTML screen 4 — "A couple of quick things": preferred language and
/// optional health flags. Shown once after the first sign-in (until the
/// user completes or skips it).
class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();

    return ChangeNotifierProvider<SetupViewModel>(
      create: (_) => SetupViewModel(localeProvider: localeProvider),
      child: const _SetupBody(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: dynamicHeight(10)),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _SetupBody extends StatelessWidget {
  const _SetupBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<SetupViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: l10n.setupTitle,
        onBack: () {
          // Back returns to OTP when pushed; falls back to login when this
          // is the restored cold-start location.
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.login);
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  dynamicWidth(20),
                  dynamicHeight(20),
                  dynamicWidth(20),
                  dynamicHeight(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(l10n.preferredLanguageLabel),
                    LanguageCards(
                      selectedCode: viewModel.selectedCode,
                      onSelected: viewModel.selectLanguage,
                    ),
                    SizedBox(height: dynamicHeight(16)),
                    _SectionLabel(l10n.flagQuestionLabel),
                    HealthFlagChips(
                      selected: viewModel.selectedFlags,
                      onToggle: viewModel.toggleFlag,
                    ),
                    SizedBox(height: dynamicHeight(12)),
                    Text(
                      l10n.flagNote,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkTertiary,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                dynamicWidth(20),
                dynamicHeight(14),
                dynamicWidth(20),
                dynamicHeight(18),
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: viewModel.saving
                        ? null
                        : () => _finish(context, (vm) => vm.completeSetup()),
                    child: Text(l10n.actionContinue),
                  ),
                  TextButton(
                    onPressed: viewModel.saving
                        ? null
                        : () => _finish(context, (vm) => vm.skipSetup()),
                    child: Text(
                      l10n.actionSkipForNow,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish(
    BuildContext context,
    Future<void> Function(SetupViewModel vm) action,
  ) async {
    final viewModel = context.read<SetupViewModel>();
    await action(viewModel);
    if (!context.mounted) return;
    context.go(AppRoutes.home);
  }
}
