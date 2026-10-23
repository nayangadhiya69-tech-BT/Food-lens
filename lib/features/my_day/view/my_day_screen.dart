import 'package:flutter/material.dart';

import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/widgets.dart';

/// My Day tab — daily view placeholder.
/// The HTML design does not define this screen yet; it follows the same
/// visual language as the other shell tabs (header + empty state).
class MyDayScreen extends StatelessWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CommonScaffold(
      title: l10n.myDayTitle,
      scrollable: false,
      body: CommonWidgets.emptyWidget(
        icon: Icons.wb_sunny_outlined,
        message: l10n.myDayEmptyTitle,
        subtitle: l10n.myDayEmptySubtitle,
      ),
    );
  }
}
