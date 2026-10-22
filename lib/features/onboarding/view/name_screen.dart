import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/widgets/app_header.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Last onboarding step — asks for the user's name, saves it locally and
/// marks onboarding complete before landing on the dashboard (home shell).
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  bool _submitting = false;

  String get _name => _nameController.text.trim();

  @override
  void initState() {
    super.initState();
    // Keep the Continue button and focus border in sync while typing.
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
    _nameFocus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: l10n.nameTitle,
        onBack: () {
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
                  dynamicWidth(24),
                  dynamicHeight(28),
                  dynamicWidth(24),
                  dynamicHeight(16),
                ),
                child: Column(
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(8)),
                    Text(
                      l10n.nameSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.inkSecondary,
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(26)),
                    Text(
                      l10n.nameLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(8)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(
                        horizontal: dynamicWidth(14),
                        vertical: dynamicHeight(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _nameFocus.hasFocus
                              ? AppColors.brand
                              : AppColors.line,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        onSubmitted: (_) => _continue(),
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.givenName],
                        maxLength: 30,
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.ink,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: false,
                          hintText: l10n.nameHint,
                          hintStyle: const TextStyle(
                            color: AppColors.inkTertiary,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: dynamicHeight(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                dynamicWidth(22),
                dynamicHeight(8),
                dynamicWidth(22),
                dynamicHeight(22),
              ),
              child: ElevatedButton(
                onPressed: _name.isNotEmpty && !_submitting ? _continue : null,
                child: Text(l10n.actionContinue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
