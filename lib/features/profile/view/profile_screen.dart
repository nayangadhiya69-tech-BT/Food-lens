import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_config.dart';
import '../../../core/models/load_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/health_flag_chips.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../authentication/view_model/auth_view_model.dart';
import '../../common/widgets/widgets.dart';
import '../repository/profile_repository.dart';
import '../view_model/profile_view_model.dart';

/// Profile tab: user card, language entry, health flags (sheet) and
/// sign-out confirmation.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (context) =>
          ProfileViewModel(context.read<ProfileRepository>())..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _confirmSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppUtils.showConfirmDialog(
      context,
      title: l10n.signOutTitle,
      message: l10n.signOutMessage,
      confirmText: l10n.actionSignOut,
      cancelText: l10n.actionCancel,
    );
    if (!confirmed || !context.mounted) return;

    await context.read<AuthViewModel>().signOut();
    if (context.mounted) context.go(AppRoutes.login);
  }

  void _showHealthFlagsSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<ProfileViewModel>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return ChangeNotifierProvider<ProfileViewModel>.value(
          value: viewModel,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              dynamicWidth(20),
              dynamicHeight(20),
              dynamicWidth(20),
              dynamicHeight(20) + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.healthFlagsSheetTitle,
                        style: AppTextStyle.create(
                          fontSize: 18,
                          weight: FontWeights.bold,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.inkSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: dynamicHeight(4)),
                Text(
                  l10n.flagNote,
                  style: AppTextStyle.create(
                    fontSize: 13,
                    color: AppColors.inkSecondary,
                  ),
                ),
                SizedBox(height: dynamicHeight(16)),
                Consumer<ProfileViewModel>(
                  builder: (context, vm, _) => HealthFlagChips(
                    selected: vm.healthFlags,
                    onToggle: vm.toggleFlag,
                  ),
                ),
                SizedBox(height: dynamicHeight(20)),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(l10n.actionClose),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ProfileViewModel>();

    return CommonScaffold(
      title: l10n.profileTitle,
      scrollable: false,
      body: _buildBody(context, l10n, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ProfileViewModel viewModel,
  ) {
    switch (viewModel.state) {
      case LoadState.loading:
        return CommonWidgets.loading(label: l10n.loadingLabel);
      case LoadState.error:
        return CommonWidgets.errorWidget(
          message: l10n.profileError,
          retryLabel: l10n.actionRetry,
          onRetry: viewModel.load,
        );
      case LoadState.success:
        final user = viewModel.user!;
        return ListView(
          padding: EdgeInsets.symmetric(vertical: dynamicHeight(16)),
          children: [
            _UserCard(name: user.name, phone: user.phoneDigits),
            CommonCard(
              child: Column(
                children: [
                  _NavRow(
                    icon: Icons.language_outlined,
                    label: l10n.languageRowLabel,
                    onTap: () => context.push(AppRoutes.language),
                  ),
                  const Divider(),
                  _NavRow(
                    icon: Icons.favorite_outline,
                    label: l10n.healthFlagsRowLabel,
                    subtitle: viewModel.healthFlags.isEmpty
                        ? l10n.noFlagsSet
                        : l10n.onThisDevice,
                    onTap: () => _showHealthFlagsSheet(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(dynamicWidth(16)),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  minimumSize: Size.fromHeight(dynamicHeight(48)),
                ),
                onPressed: () => _confirmSignOut(context),
                icon: const Icon(Icons.logout, size: 20),
                label: Text(l10n.actionSignOut),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: dynamicHeight(8)),
              child: Column(
                children: [
                  Text(
                    l10n.disclaimerText,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.create(
                      fontSize: 12,
                      color: AppColors.inkTertiary,
                    ),
                  ),
                  SizedBox(height: dynamicHeight(4)),
                  Text(
                    '${l10n.appVersionLabel} ${AppConfig.appVersion}',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.create(
                      fontSize: 12,
                      color: AppColors.inkTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: dynamicWidth(16),
        vertical: dynamicHeight(4),
      ),
      padding: EdgeInsets.all(dynamicWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: dynamicWidth(56),
            height: dynamicHeight(56),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.brandBackground,
              shape: BoxShape.circle,
            ),
            child: Text(
              name.isEmpty ? '?' : name.characters.first.toUpperCase(),
              style: AppTextStyle.create(
                fontSize: 22,
                weight: FontWeights.bold,
                color: AppColors.brand,
              ),
            ),
          ),
          SizedBox(width: dynamicWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyle.create(
                    fontSize: 17,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: dynamicHeight(2)),
                Text(
                  phone.isEmpty
                      ? l10n.profileDemoBadge
                      : AppUtils.formatMobile(phone),
                  style: AppTextStyle.create(
                    fontSize: 13,
                    color: AppColors.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
          CommonWidgets.pill(
            label: l10n.profileDemoBadge,
            background: AppColors.lineLight,
            foreground: AppColors.inkSecondary,
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: dynamicHeight(12)),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.brand),
              SizedBox(width: dynamicWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyle.create(
                        fontSize: 15,
                        weight: FontWeights.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: dynamicHeight(2)),
                      Text(
                        subtitle!,
                        style: AppTextStyle.create(
                          fontSize: 12,
                          color: AppColors.inkSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.inkTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
