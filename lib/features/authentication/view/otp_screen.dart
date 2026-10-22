import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/app_utils.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/widgets.dart';
import '../model/auth_result.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/otp_input.dart';

/// HTML screen 3 — 6-box OTP verification with resend countdown and limits.
/// Verification is completely local; no SMS is ever sent or claimed.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';
  bool _autoVerifyQueued = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<AuthViewModel>();

    final phoneLabel =
        '${l10n.phonePrefix} ${AppUtils.formatMobile(viewModel.phone)}';

    return CommonScaffold(
      onBack: () => Navigator.of(context).maybePop(),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.otpTitle,
            style: AppTextStyle.create(
              fontSize: 24,
              weight: FontWeights.bold,
              color: AppColors.ink,
              height: 1.25,
            ),
          ),
          SizedBox(height: dynamicHeight(8)),
          Text(
            l10n.otpSubtitle(phoneLabel),
            style: AppTextStyle.create(
              fontSize: 15,
              color: AppColors.inkSecondary,
              height: 1.55,
            ),
          ),
          SizedBox(height: dynamicHeight(16)),
          CommonNotice(text: l10n.otpDemoNotice(viewModel.demoOtpCode)),
          SizedBox(height: dynamicHeight(26)),
          OtpInput(onChanged: _onOtpChanged),
          if (viewModel.verifyError != null) ...[
            SizedBox(height: dynamicHeight(16)),
            SizedBox(
              width: double.infinity,
              child: Text(
                _verifyErrorMessage(l10n, viewModel.verifyError!),
                textAlign: TextAlign.center,
                style: AppTextStyle.create(
                  fontSize: 13,
                  color: AppColors.danger,
                  height: 1.45,
                ),
              ),
            ),
          ],
          SizedBox(height: dynamicHeight(20)),
          Center(child: _buildResendArea(l10n, viewModel)),
        ],
      ),
      footerElevated: false,
      footerPadding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
      // While verifying the button stays disabled (no double taps)
      // but keeps the brand colors instead of greying out.
      footer: CommonButton(
        label: l10n.otpVerify,
        loading: viewModel.verifyLoading,
        loadingLabel: l10n.otpVerifying,
        onPressed: viewModel.verifyLoading ? null : _verify,
        style: viewModel.verifyLoading
            ? ElevatedButton.styleFrom(
                disabledBackgroundColor: AppColors.brand,
                disabledForegroundColor: AppColors.surface,
                overlayColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              )
            : null,
      ),
    );
  }

  Widget _buildResendArea(AppLocalizations l10n, AuthViewModel viewModel) {
    if (viewModel.resendLimitReached) {
      return Text(
        l10n.otpResendLimitReached,
        textAlign: TextAlign.center,
        style: AppTextStyle.create(fontSize: 12, color: AppColors.warning),
      );
    }
    if (viewModel.resendSecondsLeft > 0) {
      return Text(
        l10n.otpResendIn(_formatSeconds(viewModel.resendSecondsLeft)),
        textAlign: TextAlign.center,
        style: AppTextStyle.create(
          fontSize: 13,
          weight: FontWeights.semibold,
          color: AppColors.inkSecondary,
        ),
      );
    }
    return TextButton(
      onPressed: viewModel.requestLoading ? null : _resend,
      child: Text(
        l10n.otpResendReady,
        style: AppTextStyle.create(
          fontSize: 14,
          weight: FontWeights.bold,
          color: AppColors.brand,
        ),
      ),
    );
  }

  String _formatSeconds(int total) {
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onOtpChanged(String value) {
    _code = value;
    final viewModel = context.read<AuthViewModel>();
    if (viewModel.verifyError != null) {
      viewModel.clearVerifyError();
    }
    // Auto-verify shortly after the 6th digit lands so the final box
    // animation can settle first. Guards keep it from double-firing while a
    // verify is running or after we've already navigated away.
    if (value.length == 6 && !_autoVerifyQueued && !viewModel.verifyLoading) {
      _autoVerifyQueued = true;
      Future.delayed(const Duration(milliseconds: 180), () {
        _autoVerifyQueued = false;
        if (!mounted || _code.length != 6) return;
        final route = ModalRoute.of(context);
        if (route != null && !route.isCurrent) return;
        final vm = context.read<AuthViewModel>();
        if (vm.verifyLoading) return;
        _verify();
      });
    }
  }

  Future<void> _resend() async {
    final viewModel = context.read<AuthViewModel>();
    if (!viewModel.resendReady) return;
    final outcome = await viewModel.requestOtp(viewModel.phone);
    if (!mounted) return;
    if (outcome == OtpRequestOutcome.accepted) {
      final l10n = AppLocalizations.of(context);
      AppUtils.showSnackBar(
        context,
        message: l10n.otpResent(viewModel.demoOtpCode),
        type: SnackBarType.success,
      );
    }
  }

  Future<void> _verify() async {
    final viewModel = context.read<AuthViewModel>();
    final outcome = await viewModel.verify(_code);
    if (!mounted) return;

    if (outcome == OtpVerifyOutcome.success) {
      if (AppPrefs.onboardingComplete) {
        context.go(AppRoutes.home);
      } else {
        // First-time onboarding: terms acceptance → name → dashboard.
        // A user who already accepted the terms resumes at the name step.
        context.push(AppPrefs.termsAccepted ? AppRoutes.name : AppRoutes.terms);
      }
    }
  }

  String _verifyErrorMessage(AppLocalizations l10n, OtpVerifyOutcome outcome) {
    return switch (outcome) {
      OtpVerifyOutcome.incomplete => l10n.otpIncompleteError,
      OtpVerifyOutcome.mismatch => l10n.otpMismatchError,
      OtpVerifyOutcome.tooManyAttempts => l10n.otpTooManyAttemptsError,
      _ => l10n.errorGeneric,
    };
  }
}
