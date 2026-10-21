import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../model/scan_record.dart';

/// Recent/history scan row from the HTML design:
/// emoji tile, name, localized relative time and a flag-count pill.
class ScanRecordTile extends StatelessWidget {
  const ScanRecordTile({
    super.key,
    required this.record,
    this.onTap,
    this.showDivider = true,
  });

  final ScanRecord record;
  final VoidCallback? onTap;
  final bool showDivider;

  String _timeLabel(BuildContext context, ScanRecord r) {
    final l10n = AppLocalizations.of(context);
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDay =
        DateTime(r.timestamp.year, r.timestamp.month, r.timestamp.day);
    final days = today.difference(recordDay).inDays;
    final time = DateFormat.jm(localeTag).format(r.timestamp);

    if (days <= 0) return l10n.labelToday(time);
    if (days == 1) return l10n.labelYesterday(time);
    if (days <= 6) return l10n.labelDaysAgo(days);
    return DateFormat.yMMMd(localeTag).format(r.timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final timeLabel = _timeLabel(context, record);

    final pill = record.isClear
        ? CommonWidgets.pill(
            label: l10n.clearPill,
            background: AppColors.brandBackground,
            foreground: AppColors.brandDark,
          )
        : CommonWidgets.pill(
            label: l10n.flagsPill(record.flagCount),
            background: AppColors.dangerBackground,
            foreground: AppColors.danger,
          );

    return Column(
      children: [
        Semantics(
          button: onTap != null,
          label: '${record.name}, $timeLabel',
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lineLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(record.emoji, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.inkSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  pill,
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Divider(indent: 16, endIndent: 16),
      ],
    );
  }
}
