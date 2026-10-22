import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/widgets.dart';

/// Last onboarding step — asks for the user's name, saves it locally and
/// marks onboarding complete before landing on the dashboard (home shell).
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _submitting = false;

  String get _name => _nameController.text.trim();

  @override
  void initState() {
    super.initState();
    // Keep the Continue button in sync while typing.
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_name.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    await AppPrefs.setUserName(_name);
    await AppPrefs.setOnboardingComplete(true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CommonScaffold(
      title: l10n.nameTitle,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.login);
        }
      },
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: dynamicWidth(64),
            height: dynamicHeight(64),
            decoration: BoxDecoration(
              color: AppColors.brandBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 30,
              color: AppColors.brand,
            ),
          ),
          SizedBox(height: dynamicHeight(22)),
          Text(
            l10n.nameTitle,
            style: AppTextStyle.create(
              fontSize: 24,
              weight: FontWeights.bold,
              color: AppColors.ink,
              height: 1.25,
            ),
          ),
          SizedBox(height: dynamicHeight(8)),
          Text(
            l10n.nameSubtitle,
            style: AppTextStyle.create(
              fontSize: 13,
              color: AppColors.inkSecondary,
              height: 1.55,
            ),
          ),
          SizedBox(height: dynamicHeight(26)),
          Text(
            l10n.nameLabel,
            style: AppTextStyle.create(
              fontSize: 13,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(8)),
          CommonTextField(
            controller: _nameController,
            hint: l10n.nameHint,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.givenName],
            maxLength: 30,
            onSubmitted: (_) => _continue(),
          ),
        ],
      ),
      footerElevated: false,
      footerPadding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
      footer: CommonButton(
        label: l10n.actionContinue,
        loading: _submitting,
        onPressed: _name.isNotEmpty && !_submitting ? _continue : null,
      ),
    );
  }
}
