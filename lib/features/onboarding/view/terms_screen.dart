import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../common/widgets/widgets.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Post-OTP onboarding screen — the FoodLens terms the user must accept
/// before continuing: results are AI-generated, important data must be
/// verified, and nothing is a judgement of any brand's health value.
/// The Next button unlocks only after the approval checkbox is ticked.
class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _agreed = false;
  bool _submitting = false;

  Future<void> _acceptAndContinue() async {
    if (!_agreed || _submitting) return;
    setState(() => _submitting = true);
    await AppPrefs.setTermsAccepted(true);
    if (!mounted) return;
    // Reset so the button isn't stuck if the user navigates back here.
    setState(() => _submitting = false);
    context.push(AppRoutes.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CommonScaffold(
      title: l10n.termsTitle,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.login);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.termsIntro,
            style: AppTextStyle.create(
              fontSize: 15,
              color: AppColors.inkSecondary,
              height: 1.55,
            ),
          ),
          SizedBox(height: dynamicHeight(20)),
          _TermCard(
            icon: Icons.auto_awesome_outlined,
            title: l10n.termsAiHeading,
            body: l10n.termsAiBody,
          ),
          SizedBox(height: dynamicHeight(12)),
          _TermCard(
            icon: Icons.fact_check_outlined,
            title: l10n.termsVerifyHeading,
            body: l10n.termsVerifyBody,
          ),
          SizedBox(height: dynamicHeight(12)),
          _TermCard(
            icon: Icons.favorite_outline,
            title: l10n.termsHealthHeading,
            body: l10n.termsHealthBody,
          ),
        ],
      ),
      footerPadding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreed,
                onChanged: _submitting
                    ? null
                    : (value) => setState(() => _agreed = value ?? false),
                activeColor: AppColors.brand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _submitting
                      ? null
                      : () => setState(() => _agreed = !_agreed),
                  child: Padding(
                    padding: EdgeInsets.only(top: dynamicHeight(14)),
                    child: Text(
                      l10n.termsAgreeLabel,
                      style: AppTextStyle.create(
                        fontSize: 14,
                        color: AppColors.ink,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: dynamicHeight(8)),
          CommonButton(
            label: l10n.termsNext,
            loading: _submitting,
            onPressed: _agreed && !_submitting ? _acceptAndContinue : null,
          ),
        ],
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  const _TermCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dynamicWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.brand),
              SizedBox(width: dynamicWidth(10)),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.create(
                    fontSize: 14,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: dynamicHeight(8)),
          Text(
            body,
            style: AppTextStyle.create(
              fontSize: 13,
              color: AppColors.inkSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
