import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/app_utils.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../language/widgets/language_switcher.dart';
import '../view_model/auth_view_model.dart';

/// HTML screen 2 — phone-number sign-in with a pre-login language switcher.
/// Works fully offline: the number is only validated locally and the demo
/// code is produced by [AuthViewModel] without sending any SMS.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Cross-fades the wrapped subtree when the app locale changes so switching
/// language feels like a smooth fade instead of a hard full-page blink.
///
/// The swap is keyed by the locale code, so regular rebuilds (typing,
/// focus changes, loading state, …) update the child in place without
/// triggering any animation — only an actual language change fades.
class _LocaleFade extends StatelessWidget {
  final Widget child;

  const _LocaleFade({required this.child});

  @override
  Widget build(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return SizedBox(
      width: double.infinity,
      // Smoothly animates height when the new language wraps to a
      // different number of lines.
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          reverseDuration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          // The new child decides the size; the old one is pinned top-left
          // and just fades out, so nothing shifts or jumps.
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.topLeft,
            clipBehavior: Clip.none,
            children: [
              for (final p in previous)
                Positioned(top: 0, left: 0, right: 0, child: p),
              ?current,
            ],
          ),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(key: ValueKey<String>(code), child: child),
        ),
      ),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  String? _errorText;
  bool _focused = false;
  bool _submitting = false;

  String get _digits => _phoneController.text.replaceAll(RegExp(r'[\s-]'), '');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: dynamicHeight(12),
              right: dynamicWidth(14),
              child: LanguageSwitcher(),
            ),
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        dynamicWidth(24),
                        dynamicHeight(32),
                        dynamicWidth(24),
                        dynamicHeight(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                              Icons.phone_outlined,
                              size: 30,
                              color: AppColors.brand,
                            ),
                          ),
                          SizedBox(height: dynamicHeight(22)),
                          // Localized texts cross-fade (instead of snapping in
                          // one frame) when the language changes, so the switch
                          // feels smooth. The phone field stays outside the
                          // fade to keep focus/controller state rock solid.
                          _LocaleFade(
                            child: Column(
                              key: const ValueKey('loginHeaderTexts'),
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.loginTitle,
                                  style: AppTextStyle.create(
                                    fontSize: 24,
                                    weight: FontWeights.bold,
                                    color: AppColors.ink,
                                    height: 1.25,
                                  ),
                                ),
                                SizedBox(height: dynamicHeight(8)),
                                Text(
                                  l10n.loginSubtitle,
                                  style: AppTextStyle.create(
                                    fontSize: 12,
                                    color: AppColors.inkSecondary,
                                    height: 1.55,
                                  ),
                                ),
                                SizedBox(height: dynamicHeight(26)),
                                Text(
                                  l10n.mobileNumberLabel,
                                  style: AppTextStyle.create(
                                    fontSize: 13,
                                    weight: FontWeights.bold,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dynamicHeight(8)),
                          _PhoneField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            focused: _focused,
                            prefix: l10n.phonePrefix,
                            hint: l10n.phoneHint,
                            errorText: _errorText,
                            onFocusChange: (focused) {
                              if (mounted) setState(() => _focused = focused);
                            },
                            onSubmitted: (_) => _submit(),
                          ),
                        ],
                      ),
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
                  child: _LocaleFade(
                    child: Column(
                      key: const ValueKey('loginFooterTexts'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: dynamicWidth(12),
                            vertical: dynamicHeight(10),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _LocaleFade(
                            child: Text(
                              l10n.demoSignInNotice,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.create(
                                fontSize: 12,
                                color: AppColors.brandDark,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: dynamicHeight(12)),
                        // The button collapses into a compact pill with a
                        // loader while the OTP request is in flight, then
                        // restores itself when the user comes back.
                        Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final loading =
                                  _submitting || authViewModel.requestLoading;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                width: constraints.maxWidth,
                                child: ElevatedButton(
                                  onPressed: loading ? null : _submit,
                                  style: loading
                                      ? ElevatedButton.styleFrom(
                                          disabledBackgroundColor:
                                              AppColors.brand,
                                          disabledForegroundColor:
                                              AppColors.surface,
                                        )
                                      : null,
                                  child: ClipRect(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      switchInCurve: Curves.easeOutCubic,
                                      switchOutCurve: Curves.easeInCubic,
                                      transitionBuilder: (child, animation) =>
                                          FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(
                                                begin: 0.8,
                                                end: 1,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          ),
                                      child: loading
                                          ? SizedBox(
                                              key: const ValueKey(
                                                'sendOtpLoader',
                                              ),
                                              width: dynamicWidth(20),
                                              height: dynamicHeight(20),
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: AppColors.surface,
                                                  ),
                                            )
                                          : Text(
                                              l10n.sendOtp,
                                              key: const ValueKey(
                                                'sendOtpLabel',
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: dynamicHeight(12)),
                        _LocaleFade(
                          child: Text(
                            l10n.termsCaption,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.create(
                              fontSize: 13,
                              color: AppColors.inkTertiary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Keep the button collapsed (loading) while the OTP screen covers us, and
    // restore it to "Send OTP" once the user navigates back here.
    final route = ModalRoute.of(context);
    if (_submitting && (route == null || route.isCurrent)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _submitting) setState(() => _submitting = false);
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final digits = _digits;

    final String? error;
    if (digits.isEmpty) {
      error = l10n.phoneRequiredError;
    } else if (!AppUtils.isValidIndianMobile(digits)) {
      error = l10n.phoneInvalidError;
    } else {
      error = null;
    }

    setState(() => _errorText = error);
    if (error != null) {
      _phoneFocus.requestFocus();
      return;
    }

    // Collapse the button into its loader state right away so the swap
    // animates before the round-trip completes.
    setState(() => _submitting = true);
    AppUtils.hideKeyboard(context);
    final viewModel = context.read<AuthViewModel>();
    // In demo mode this only validates locally and starts the local resend
    // countdown — nothing is transmitted.
    await viewModel.requestOtp(digits);
    if (!mounted) return;
    // _submitting stays true until the user returns (didChangeDependencies),
    // so the button never flickers back to its label during the push.
    context.push(AppRoutes.otpLocation(digits));
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;

  final FocusNode focusNode;
  final bool focused;
  final String prefix;
  final String hint;
  final String? errorText;
  final ValueChanged<bool> onFocusChange;
  final ValueChanged<String> onSubmitted;
  const _PhoneField({
    required this.controller,
    required this.focusNode,
    required this.focused,
    required this.prefix,
    required this.hint,
    required this.errorText,
    required this.onFocusChange,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = errorText != null
        ? AppColors.danger
        : (focused ? AppColors.brand : AppColors.line);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(14),
            vertical: dynamicHeight(4),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Text(
                prefix,
                style: AppTextStyle.create(
                  fontSize: 16,
                  weight: FontWeights.bold,
                  color: AppColors.inkSecondary,
                ),
              ),
              SizedBox(width: dynamicWidth(10)),
              Container(
                width: dynamicWidth(1),
                height: dynamicHeight(22),
                color: AppColors.line,
              ),
              SizedBox(width: dynamicWidth(10)),
              Expanded(
                child: Focus(
                  onFocusChange: onFocusChange,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onSubmitted: onSubmitted,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: AppTextStyle.create(
                      fontSize: 17,
                      color: AppColors.ink,
                      letterSpacing: 0.4,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      hintText: hint,
                      hintStyle: const TextStyle(color: AppColors.inkTertiary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: dynamicHeight(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(
              top: dynamicHeight(8),
              left: dynamicWidth(4),
            ),
            child: Text(
              errorText!,
              style: AppTextStyle.create(fontSize: 13, color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}
