import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';

/// Scaffold with the app's standard white header (back button + title) and
/// an optional sticky footer bar (surface + top hairline) for actions.
///
/// Two body modes:
/// * `scrollable: true` (default) — [body] is wrapped in a padded
///   `SingleChildScrollView` (terms, name, OTP, setup screens).
/// * `scrollable: false` — [body] is laid out as-is (screens that already
///   provide their own `ListView`/loading states, e.g. profile/history).
class CommonScaffold extends StatelessWidget {
  final String? title;

  final String? subtitle;
  final Widget? trailing;

  /// null → no back button (tab screens like Profile/History).
  final VoidCallback? onBack;

  /// Page content: a column/children tree when [scrollable], or a complete
  /// body widget (ListView, loading state, …) otherwise.
  final Widget body;

  final EdgeInsetsGeometry contentPadding;
  final bool scrollable;

  /// Pinned bottom actions (a column of buttons).
  final Widget? footer;

  final EdgeInsetsGeometry footerPadding;

  /// true → footer sits in a surface container with a top hairline;
  /// false → footer is plain (no background/border).
  final bool footerElevated;

  const CommonScaffold({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.onBack,
    required this.body,
    this.contentPadding = const EdgeInsets.fromLTRB(20, 20, 20, 16),
    this.scrollable = true,
    this.footer,
    this.footerPadding = const EdgeInsets.fromLTRB(20, 14, 20, 18),
    this.footerElevated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onBack: onBack,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(padding: contentPadding, child: body)
                  : body,
            ),
            if (footer != null)
              footerElevated
                  ? Container(
                      padding: footerPadding,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        border: Border(top: BorderSide(color: AppColors.line)),
                      ),
                      child: footer,
                    )
                  : Padding(padding: footerPadding, child: footer),
          ],
        ),
      ),
    );
  }
}
