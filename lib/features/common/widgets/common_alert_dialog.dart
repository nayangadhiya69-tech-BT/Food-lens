import 'package:flutter/material.dart';

import 'common_button.dart';

/// The app's one and only alert box: a rounded-16 dialog with an optional
/// message (or a custom [content]), one primary (brand) action and an
/// optional basic (text) action.
///
/// Show every alert in the project through this class so dialogs keep the
/// same shape, buttons and behaviour:
///
/// * [showConfirm] — primary → `true`, basic action or barrier tap →
///   `false` (used by `AppUtils.showConfirmDialog`).
/// * [showInfo] — single primary action, closes with `null`.
/// * Direct `showDialog` with a custom [content] — the caller validates in
///   [onPrimary] and closes only when valid (the portion "edit grams"
///   dialog works this way).
class CommonAlertDialog extends StatelessWidget {
  const CommonAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    required this.primaryText,
    required this.onPrimary,
    this.primaryStyle,
    this.basicText,
    this.onBasic,
  });

  final String title;

  /// Short body text; rendered alone when [content] is null.
  final String? message;

  /// Custom body (input fields, lists…) instead of — or after — [message].
  final Widget? content;

  final String primaryText;

  /// Primary action; the caller decides when (and with what) to pop.
  final VoidCallback onPrimary;

  /// Optional style for the primary button (defaults to the theme).
  final ButtonStyle? primaryStyle;

  final String? basicText;

  /// Basic (text) action; defaults to popping with a `null` result.
  final VoidCallback? onBasic;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: _buildContent(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        if (basicText != null)
          TextButton(
            onPressed: onBasic ?? () => Navigator.of(context).pop(),
            child: Text(basicText!),
          ),
        CommonButton(
          label: primaryText,
          style: primaryStyle,
          onPressed: onPrimary,
        ),
      ],
    );
  }

  Widget? _buildContent() {
    if (message != null && content != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(message!), content!],
      );
    }
    if (message != null) return Text(message!);
    return content;
  }

  /// Confirm-style alert: primary → `true`, basic action or barrier tap →
  /// `false`.
  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => CommonAlertDialog(
        title: title,
        message: message,
        primaryText: confirmText,
        onPrimary: () => Navigator.of(dialogContext).pop(true),
        basicText: cancelText,
        onBasic: () => Navigator.of(dialogContext).pop(false),
      ),
    );
    return result ?? false;
  }

  /// Information alert with a single primary action; closes on tap or
  /// barrier. [buttonText] defaults to the platform's localized "OK".
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CommonAlertDialog(
        title: title,
        message: message,
        primaryText:
            buttonText ?? MaterialLocalizations.of(context).okButtonLabel,
        onPrimary: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
