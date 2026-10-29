import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_locales.dart';
import '../../../core/models/health_flag.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/voice_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/common_toast.dart';
import '../../language/view_model/locale_provider.dart';
import '../../language/widgets/language_cards.dart';
import '../data/scan_story_copy.dart';
import '../data/scan_story_voice.dart';
import '../model/scan_mode.dart';
import '../model/scan_result.dart';
import '../view_model/scan_view_model.dart';

/// Status-style scan result: the decoded label told as a swipeable story
/// (progress segments, tap zones, hold-to-pause, jump dots and a spoken
/// voiceover). Text is always English; the Listen player uses the voice
/// language chosen in Profile.
class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen({super.key});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

/// The "Decoded in depth" card: one nutrient read down to its ingredient.
class _DepthCard extends StatelessWidget {
  final DepthDecode depth;

  const _DepthCard({required this.depth});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scanDepthLabel.toUpperCase(),
            style: AppTextStyle.create(
              fontSize: 10,
              weight: FontWeights.bold,
              color: AppColors.inkSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: dynamicHeight(8)),
          Text(
            depth.title,
            style: AppTextStyle.create(
              fontSize: 13,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(4)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: depth.amount,
                  style: AppTextStyle.create(
                    fontSize: 15,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
                TextSpan(
                  text: ' ${depth.detail} ',
                  style: AppTextStyle.create(
                    fontSize: 11,
                    color: AppColors.inkSecondary,
                  ),
                ),
                TextSpan(
                  text: depth.percent,
                  style: AppTextStyle.create(
                    fontSize: 11,
                    weight: FontWeights.bold,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: dynamicHeight(10)),
          Container(height: 1, color: AppColors.lineLight),
          SizedBox(height: dynamicHeight(10)),
          CommonWidgets.pill(
            label: depth.pill,
            background: AppColors.lineLight,
            foreground: AppColors.inkSecondary,
          ),
          SizedBox(height: dynamicHeight(7)),
          Text(
            depth.ingredient,
            style: AppTextStyle.create(
              fontSize: 12,
              weight: FontWeights.bold,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: dynamicHeight(3)),
          Text(
            depth.note,
            style: AppTextStyle.create(
              fontSize: 11.5,
              color: AppColors.inkSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

/// Danger-tinted banner: how many things are flagged, and why they are.
class _FlagBanner extends StatelessWidget {
  final int count;

  final String body;
  const _FlagBanner({required this.count, required this.body});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.dangerBackground,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.dangerLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scanBannerTitle(count),
            style: AppTextStyle.create(
              fontSize: 13,
              weight: FontWeights.bold,
              color: AppColors.danger,
            ),
          ),
          SizedBox(height: dynamicHeight(5)),
          Text(
            body,
            style: AppTextStyle.create(
              fontSize: 11.5,
              color: AppColors.dangerText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;

  final String label;
  final VoidCallback onTap;
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: dynamicWidth(34),
          height: dynamicWidth(34),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, size: 19, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _IdRow extends StatelessWidget {
  final String label;

  final String value;
  const _IdRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dynamicHeight(7)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.create(
                fontSize: 11.5,
                color: AppColors.inkSecondary,
              ),
            ),
          ),
          SizedBox(width: dynamicWidth(10)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyle.create(
                fontSize: 11.5,
                weight: FontWeights.bold,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Flags on this label" card: each finding with its figure.
class _LabelFlagsCard extends StatelessWidget {
  final List<LabelFlag> flags;

  const _LabelFlagsCard({required this.flags});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scanLabelFlagsLabel.toUpperCase(),
            style: AppTextStyle.create(
              fontSize: 10,
              weight: FontWeights.bold,
              color: AppColors.inkSecondary,
              letterSpacing: 0.5,
            ),
          ),
          for (var i = 0; i < flags.length; i++) ...[
            if (i > 0) ...[
              SizedBox(height: dynamicHeight(9)),
              Container(height: 1, color: AppColors.lineLight),
              SizedBox(height: dynamicHeight(9)),
            ] else
              SizedBox(height: dynamicHeight(10)),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 15,
                  color: AppColors.danger,
                ),
                SizedBox(width: dynamicWidth(7)),
                Expanded(
                  child: Text(
                    flags[i].title,
                    style: AppTextStyle.create(
                      fontSize: 12,
                      weight: FontWeights.semibold,
                      color: AppColors.ink,
                      height: 1.35,
                    ),
                  ),
                ),
                SizedBox(width: dynamicWidth(8)),
                Text(
                  flags[i].value,
                  style: AppTextStyle.create(
                    fontSize: 12,
                    weight: FontWeights.bold,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ListenPill extends StatelessWidget {
  final bool listening;

  final VoidCallback? onTap;
  const _ListenPill({required this.listening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: listening ? ScanStoryCopy.pause : 'Listen to this card',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(10),
            vertical: dynamicHeight(6),
          ),
          decoration: BoxDecoration(
            color: listening ? AppColors.brand : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: listening
                  ? AppColors.brand
                  : AppColors.brand.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                listening ? Icons.pause_rounded : Icons.volume_up_rounded,
                size: 14,
                color: listening ? AppColors.surface : AppColors.brand,
              ),
              SizedBox(width: dynamicWidth(4)),
              Text(
                listening ? ScanStoryCopy.pause : ScanStoryCopy.listen,
                style: AppTextStyle.create(
                  fontSize: 10,
                  weight: FontWeights.bold,
                  color: listening ? AppColors.surface : AppColors.brandDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final List<ScanStat> stats;

  const _MetricsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : dynamicWidth(4)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: dynamicHeight(9)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  children: [
                    Text(
                      stats[i].value,
                      style: AppTextStyle.create(
                        fontSize: 15,
                        weight: FontWeights.bold,
                        color: _colorFor(stats[i].key),
                      ),
                    ),
                    SizedBox(height: dynamicHeight(3)),
                    Text(
                      _labelFor(stats[i].key),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.create(
                        fontSize: 6.5,
                        weight: FontWeights.bold,
                        color: AppColors.inkSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Color _colorFor(ScanStatKey key) => switch (key) {
    ScanStatKey.sodium => AppColors.danger,
    ScanStatKey.condition => AppColors.warning,
    ScanStatKey.additives => AppColors.ink,
    ScanStatKey.allergens => AppColors.ink,
    ScanStatKey.score => AppColors.brand,
  };

  static String _labelFor(ScanStatKey key) => switch (key) {
    ScanStatKey.sodium => ScanStoryCopy.metricSodium,
    ScanStatKey.condition => ScanStoryCopy.metricFlags,
    ScanStatKey.additives => ScanStoryCopy.metricAdditives,
    ScanStatKey.allergens => ScanStoryCopy.metricAllergens,
    ScanStatKey.score => ScanStoryCopy.metricScore,
  };
}

class _PersonalFlagsCard extends StatelessWidget {
  const _PersonalFlagsCard({
    required this.flags,
    required this.l10n,
    required this.applied,
    required this.friendlyFlags,
  });

  final List<HealthFlag> flags;
  final AppLocalizations l10n;
  final int applied;
  final Set<HealthFlag> friendlyFlags;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite_outline,
                size: 14,
                color: AppColors.brand,
              ),
              SizedBox(width: dynamicWidth(6)),
              Text(
                ScanStoryCopy.yourFlags.toUpperCase(),
                style: AppTextStyle.create(
                  fontSize: 9.5,
                  weight: FontWeights.bold,
                  color: AppColors.inkSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: dynamicHeight(9)),
          if (flags.isEmpty)
            Text(
              ScanStoryCopy.noFlags,
              style: AppTextStyle.create(
                fontSize: 12,
                color: AppColors.inkSecondary,
                height: 1.45,
              ),
            )
          else
            Wrap(
              spacing: dynamicWidth(6),
              runSpacing: dynamicHeight(6),
              children: [
                for (final flag in flags)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dynamicWidth(9),
                      vertical: dynamicHeight(5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.brand.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: AppColors.brand,
                        ),
                        SizedBox(width: dynamicWidth(4)),
                        Text(
                          flag.localizedLabel(l10n),
                          style: AppTextStyle.create(
                            fontSize: 11,
                            weight: FontWeights.bold,
                            color: AppColors.brandDark,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          if (flags.isNotEmpty) ...[
            ..._statusRows(),
            Text(
              ScanStoryCopy.flagsApplied(applied),
              style: AppTextStyle.create(
                fontSize: 10.5,
                color: AppColors.inkSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _statusRows() {
    final rows = <Widget>[];
    for (final flag in flags) {
      rows.add(
        _FlagStatusRow(
          flag: flag,
          friendly: friendlyFlags.contains(flag),
        ),
      );
      rows.add(SizedBox(height: dynamicHeight(8)));
    }
    return rows;
  }
}

/// One personal flag with its status against the scanned product: is the
/// product friendly for it, or not?
class _FlagStatusRow extends StatelessWidget {
  final HealthFlag flag;
  final bool friendly;

  const _FlagStatusRow({required this.flag, required this.friendly});

  @override
  Widget build(BuildContext context) {
    final label = flag.localizedLabel(AppLocalizations.of(context));
    final color = friendly ? AppColors.brandDark : AppColors.inkSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          friendly ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
          size: 14,
          color: friendly ? AppColors.brand : AppColors.warning,
        ),
        SizedBox(width: dynamicWidth(6)),
        Expanded(
          child: Text(
            friendly
                ? ScanStoryCopy.friendlyStatus(label)
                : ScanStoryCopy.notFriendlyStatus(label),
            style: AppTextStyle.create(
              fontSize: 11,
              color: color,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _RefChip extends StatelessWidget {
  final String text;

  const _RefChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(10),
        vertical: dynamicHeight(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.lineLight,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(
        text,
        style: AppTextStyle.create(
          fontSize: 10.5,
          color: AppColors.inkSecondary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _ScanResultScreenState extends State<ScanResultScreen>
    with SingleTickerProviderStateMixin {
  static const int _cardCount = 6;
  static const Duration _cardDuration = Duration(seconds: 8);
  static const Set<int> _flaggedCards = {2, 3, 4};

  late final AnimationController _progress;
  final VoiceService _voice = VoiceService();

  int _index = 0;
  bool _paused = false;
  bool _speaking = false;
  int _speechToken = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<ScanViewModel>();
    final localeProvider = context.watch<LocaleProvider>();
    final result = viewModel.result;

    if (result == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: CommonWidgets.loading()),
      );
    }

    final voiceCode = localeProvider.effectiveCode;
    final languageName = ScanStoryCopy.languageName(voiceCode);
    final titles = _titles(result);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.brandBackground,
              AppColors.background,
              AppColors.background,
            ],
            stops: [0, 0.34, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  dynamicWidth(16),
                  dynamicHeight(10),
                  dynamicWidth(16),
                  0,
                ),
                child: _StoryProgress(
                  progress: _progress,
                  index: _index,
                  count: _cardCount,
                ),
              ),
              _StoryHeader(
                title: result.name,
                subtitle: result.subtitle,
                voiceCode: voiceCode,
                onBack: _close,
                onVoiceLanguage: _showVoiceLanguageSheet,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return GestureDetector(
                      key: const ValueKey('storyTapArea'),
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) {
                        if (details.localPosition.dx < width * 0.32) {
                          _previous();
                        } else {
                          _next();
                        }
                      },
                      onLongPressStart: (_) => _pause(),
                      onLongPressEnd: (_) => _resume(),
                      onHorizontalDragEnd: (details) {
                        final velocity = details.primaryVelocity ?? 0;
                        if (velocity < -80) {
                          _next();
                        } else if (velocity > 80) {
                          _previous();
                        }
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: KeyedSubtree(
                              key: ValueKey<int>(_index),
                              child: _buildCard(
                                _index,
                                result,
                                viewModel,
                                l10n,
                                languageName,
                              ),
                            ),
                          ),
                          Positioned(
                            top: dynamicHeight(6),
                            left: 0,
                            right: 0,
                            child: IgnorePointer(
                              child: Center(
                                child: AnimatedOpacity(
                                  opacity: _paused ? 1 : 0,
                                  duration: const Duration(milliseconds: 160),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: dynamicWidth(13),
                                      vertical: dynamicHeight(6),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.ink.withValues(
                                        alpha: 0.82,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.pause_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: dynamicWidth(4)),
                                        Text(
                                          ScanStoryCopy.paused,
                                          style: AppTextStyle.create(
                                            fontSize: 10.5,
                                            weight: FontWeights.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _StoryBottomBar(
                index: _index,
                count: _cardCount,
                flaggedCards: _flaggedCards,
                titles: titles,
                onJump: _goTo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progress.dispose();
    _speechToken++;
    unawaited(_voice.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: _cardDuration)
      ..addStatusListener(_onProgressStatus)
      ..forward();
  }

  Widget _buildCard(
    int index,
    ScanResult result,
    ScanViewModel viewModel,
    AppLocalizations l10n,
    String languageName,
  ) {
    final listening = _speaking && _index == index;
    void onListen() => unawaited(_toggleVoice(index));

    switch (index) {
      case 0:
        final selected = viewModel.selectedFlags
            .where((flag) => !flag.isNone)
            .toList(growable: false);
        final applied =
            result.stats
                .where((stat) => stat.key == ScanStatKey.condition)
                .map((stat) => int.tryParse(stat.value) ?? 0)
                .firstOrNull ??
            0;
        return _StoryCard(
          tag: ScanStoryCopy.tag,
          tagIcon: Icons.auto_awesome,
          tone: _StoryTone.brand,
          title: ScanStoryCopy.overviewTitle,
          showListen: false,
          children: [
            Text(
              result.name,
              style: AppTextStyle.create(
                fontSize: 17,
                weight: FontWeights.bold,
                color: AppColors.ink,
              ),
            ),
            SizedBox(height: dynamicHeight(2)),
            Text(
              result.subtitle,
              style: AppTextStyle.create(
                fontSize: 12,
                color: AppColors.inkSecondary,
              ),
            ),
            SizedBox(height: dynamicHeight(14)),
            _VoicePlayer(
              playing: listening,
              languageName: languageName,
              onTap: onListen,
            ),
            SizedBox(height: dynamicHeight(12)),
            _PersonalFlagsCard(
              flags: selected,
              l10n: l10n,
              applied: applied,
              friendlyFlags: result.friendlyFlags,
            ),
            SizedBox(height: dynamicHeight(14)),
            _SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ScanStoryCopy.shortVersion.toUpperCase(),
                    style: AppTextStyle.create(
                      fontSize: 9.5,
                      weight: FontWeights.bold,
                      color: AppColors.inkSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: dynamicHeight(7)),
                  Text(
                    result.bannerBody,
                    style: AppTextStyle.create(
                      fontSize: 12.5,
                      color: AppColors.ink,
                      height: 1.55,
                    ),
                  ),
                  SizedBox(height: dynamicHeight(10)),
                  _RefChip(text: ScanStoryCopy.reference),
                ],
              ),
            ),
          ],
        );

      case 1:
        final nameParts = result.name.split(' ');
        final brand = nameParts.length > 1 ? nameParts.first : result.name;
        final product = nameParts.length > 1
            ? nameParts.skip(1).join(' ')
            : result.subtitle;
        final barcode = viewModel.barcodeValue;
        final hasBarcode = barcode != null && barcode.trim().isNotEmpty;
        return _StoryCard(
          tag: ScanStoryCopy.productId.toUpperCase(),
          tagIcon: Icons.inventory_2_outlined,
          tone: _StoryTone.brand,
          title: ScanStoryCopy.productId,
          listening: listening,
          onListen: onListen,
          children: [
            _SurfaceCard(
              child: Column(
                children: [
                  _IdRow(label: ScanStoryCopy.brand, value: brand),
                  const Divider(height: 1),
                  _IdRow(label: ScanStoryCopy.product, value: product),
                  const Divider(height: 1),
                  _IdRow(label: ScanStoryCopy.netQty, value: result.subtitle),
                  const Divider(height: 1),
                  _IdRow(
                    label: ScanStoryCopy.barcode,
                    value: hasBarcode ? barcode : ScanStoryCopy.notCaptured,
                  ),
                  const Divider(height: 1),
                  _IdRow(
                    label: ScanStoryCopy.scanType,
                    value: viewModel.mode == ScanMode.barcode
                        ? l10n.scanModeBarcodeTitle
                        : l10n.scanModePhotoTitle,
                  ),
                ],
              ),
            ),
            SizedBox(height: dynamicHeight(10)),
            _RefChip(
              text: hasBarcode
                  ? ScanStoryCopy.barcodeNote
                  : ScanStoryCopy.labelOnlyNote,
            ),
          ],
        );

      case 2:
        return _StoryCard(
          tag: ScanStoryCopy.primaryLens.toUpperCase(),
          tagIcon: Icons.crisis_alert,
          tone: _StoryTone.danger,
          title: ScanStoryCopy.whatStandsOut,
          listening: listening,
          onListen: onListen,
          children: [
            _MetricsRow(stats: result.stats),
            SizedBox(height: dynamicHeight(12)),
            _FlagBanner(count: result.flaggedCount, body: result.bannerBody),
          ],
        );

      case 3:
        return _StoryCard(
          tag: ScanStoryCopy.decodedInDepth.toUpperCase(),
          tagIcon: Icons.science_outlined,
          tone: _StoryTone.warning,
          title: result.depth.title,
          listening: listening,
          onListen: onListen,
          children: [
            _SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: result.depth.amount,
                          style: AppTextStyle.create(
                            fontSize: 17,
                            weight: FontWeights.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        TextSpan(
                          text: ' ${result.depth.detail} ',
                          style: AppTextStyle.create(
                            fontSize: 11.5,
                            color: AppColors.inkSecondary,
                          ),
                        ),
                        TextSpan(
                          text: result.depth.percent,
                          style: AppTextStyle.create(
                            fontSize: 11.5,
                            weight: FontWeights.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: dynamicHeight(10)),
                  Container(height: 1, color: AppColors.lineLight),
                  SizedBox(height: dynamicHeight(10)),
                  _SoftPill(text: result.depth.pill),
                  SizedBox(height: dynamicHeight(8)),
                  Text(
                    result.depth.ingredient,
                    style: AppTextStyle.create(
                      fontSize: 12.5,
                      weight: FontWeights.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: dynamicHeight(4)),
                  Text(
                    result.depth.note,
                    style: AppTextStyle.create(
                      fontSize: 11.5,
                      color: AppColors.inkSecondary,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case 4:
        return _StoryCard(
          tag: l10n.scanLabelFlagsLabel.toUpperCase(),
          tagIcon: Icons.flag_outlined,
          tone: _StoryTone.danger,
          title: ScanStoryCopy.flagsTitle,
          listening: listening,
          onListen: onListen,
          children: [
            _SurfaceCard(
              child: Column(
                children: [
                  for (var i = 0; i < result.labelFlags.length; i++) ...[
                    if (i > 0) ...[
                      SizedBox(height: dynamicHeight(9)),
                      Container(height: 1, color: AppColors.lineLight),
                      SizedBox(height: dynamicHeight(9)),
                    ],
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.danger,
                        ),
                        SizedBox(width: dynamicWidth(7)),
                        Expanded(
                          child: Text(
                            result.labelFlags[i].title,
                            style: AppTextStyle.create(
                              fontSize: 12.5,
                              weight: FontWeights.semibold,
                              color: AppColors.ink,
                              height: 1.35,
                            ),
                          ),
                        ),
                        SizedBox(width: dynamicWidth(8)),
                        Text(
                          result.labelFlags[i].value,
                          style: AppTextStyle.create(
                            fontSize: 12,
                            weight: FontWeights.bold,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: dynamicHeight(10)),
            _RefChip(text: l10n.flagNote),
          ],
        );

      default:
        return _StoryCard(
          tag: ScanStoryCopy.sources.toUpperCase(),
          tagIcon: Icons.library_books_outlined,
          tone: _StoryTone.success,
          title: ScanStoryCopy.sources,
          listening: listening,
          onListen: onListen,
          children: [
            _SurfaceCard(
              child: Column(
                children: const [
                  _IdRow(
                    label: ScanStoryCopy.sodiumSource,
                    value: ScanStoryCopy.sodiumLimit,
                  ),
                  Divider(height: 1),
                  _IdRow(
                    label: ScanStoryCopy.sugarSource,
                    value: ScanStoryCopy.sugarLimit,
                  ),
                ],
              ),
            ),
            SizedBox(height: dynamicHeight(10)),
            _WarningNote(text: ScanStoryCopy.fssaiNote),
            SizedBox(height: dynamicHeight(10)),
            _RefChip(text: l10n.disclaimerText),
            SizedBox(height: dynamicHeight(16)),
            SizedBox(
              height: dynamicHeight(48),
              child: ElevatedButton.icon(
                onPressed: _replay,
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: Text(ScanStoryCopy.replay),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTextStyle.create(
                    fontSize: 13.5,
                    weight: FontWeights.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: dynamicHeight(8)),
            SizedBox(
              height: dynamicHeight(48),
              child: OutlinedButton(
                onPressed: () => _showFullList(result, l10n),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: BorderSide(color: AppColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTextStyle.create(
                    fontSize: 12.5,
                    weight: FontWeights.bold,
                  ),
                ),
                child: Text(l10n.scanFullDecode),
              ),
            ),
          ],
        );
    }
  }

  void _cancelSpeech({bool resumeProgress = true}) {
    _speechToken++;
    unawaited(_voice.stop());
    if (_speaking) {
      setState(() => _speaking = false);
    }
    if (resumeProgress && !_paused && _index < _cardCount - 1) {
      _progress.forward();
    }
  }

  void _close() {
    context.read<ScanViewModel>().endSession();
    context.go(AppRoutes.home);
  }

  void _goTo(int next) {
    final target = next.clamp(0, _cardCount - 1);
    if (target == _index) return;
    _speechToken++;
    unawaited(_voice.stop());
    _progress.stop();
    setState(() {
      _index = target;
      _paused = false;
      _speaking = false;
    });
    _progress.forward(from: 0);
  }

  void _next() {
    if (_index >= _cardCount - 1) {
      _progress.stop();
      _progress.value = 1;
      return;
    }
    _goTo(_index + 1);
  }

  void _onProgressStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _index < _cardCount - 1) {
      _goTo(_index + 1);
    }
  }

  void _pause() {
    if (_paused) return;
    _progress.stop();
    setState(() => _paused = true);
  }

  void _previous() {
    if (_index == 0) return;
    _goTo(_index - 1);
  }

  void _replay() {
    _speechToken++;
    unawaited(_voice.stop());
    _progress.stop();
    setState(() {
      _index = 0;
      _paused = false;
      _speaking = false;
    });
    _progress.forward(from: 0);
  }

  void _resume() {
    if (!_paused) return;
    setState(() => _paused = false);
    if (!_speaking && _index < _cardCount - 1) {
      _progress.forward();
    }
  }

  Future<void> _showFullList(ScanResult result, AppLocalizations l10n) async {
    _pause();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  dynamicWidth(20),
                  dynamicHeight(14),
                  dynamicWidth(12),
                  dynamicHeight(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.scanFullDecode,
                            style: AppTextStyle.create(
                              fontSize: 17,
                              weight: FontWeights.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: dynamicHeight(2)),
                          Text(
                            result.name,
                            style: AppTextStyle.create(
                              fontSize: 12.5,
                              color: AppColors.inkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: l10n.actionClose,
                      child: GestureDetector(
                        onTap: () => Navigator.of(sheetContext).pop(),
                        child: Container(
                          width: dynamicWidth(34),
                          height: dynamicWidth(34),
                          decoration: const BoxDecoration(
                            color: AppColors.lineLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    dynamicWidth(16),
                    0,
                    dynamicWidth(16),
                    dynamicHeight(28),
                  ),
                  children: [
                    _StatStrip(stats: result.stats),
                    SizedBox(height: dynamicHeight(14)),
                    _FlagBanner(
                      count: result.flaggedCount,
                      body: result.bannerBody,
                    ),
                    SizedBox(height: dynamicHeight(14)),
                    _DepthCard(depth: result.depth),
                    SizedBox(height: dynamicHeight(10)),
                    _LabelFlagsCard(flags: result.labelFlags),
                    SizedBox(height: dynamicHeight(16)),
                    Text(
                      l10n.disclaimerText,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.create(
                        fontSize: 10.5,
                        color: AppColors.inkTertiary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (mounted) _resume();
  }

  Future<void> _showVoiceLanguageSheet() async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            dynamicWidth(20),
            dynamicHeight(18),
            dynamicWidth(20),
            dynamicHeight(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: dynamicWidth(38),
                  height: dynamicHeight(4),
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: dynamicHeight(16)),
              Text(
                l10n.languageScreenTitle,
                style: AppTextStyle.create(
                  fontSize: 17,
                  weight: FontWeights.bold,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: dynamicHeight(6)),
              Text(
                l10n.languageVoiceNote,
                style: AppTextStyle.create(
                  fontSize: 12.5,
                  color: AppColors.inkSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: dynamicHeight(16)),
              Consumer<LocaleProvider>(
                builder: (context, provider, _) => LanguageCards(
                  selectedCode: provider.effectiveCode,
                  onSelected: (code) {
                    _cancelSpeech();
                    provider.setLocale(code);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _titles(ScanResult result) => [
    ScanStoryCopy.overviewTitle,
    ScanStoryCopy.productId,
    ScanStoryCopy.whatStandsOut,
    ScanStoryCopy.decodedInDepth,
    ScanStoryCopy.flagsTitle,
    ScanStoryCopy.sources,
  ];

  Future<void> _toggleVoice(int cardIndex) async {
    if (_speaking) {
      _cancelSpeech();
      return;
    }

    final result = context.read<ScanViewModel>().result;
    if (result == null) return;
    final viewModel = context.read<ScanViewModel>();
    final languageCode = context.read<LocaleProvider>().effectiveCode;
    final text = ScanStoryVoice.scriptFor(
      card: cardIndex,
      languageCode: languageCode,
      result: result,
      flags: viewModel.selectedFlags,
      barcode: viewModel.barcodeValue,
    );

    final token = ++_speechToken;
    _progress.stop();
    setState(() => _speaking = true);

    final ok = await _voice.speak(text: text, languageCode: languageCode);
    if (!mounted || token != _speechToken) return;

    setState(() => _speaking = false);
    if (!_paused && _index < _cardCount - 1) {
      _progress.forward();
    }
    if (!ok) {
      CommonToast.show(
        context,
        message: ScanStoryCopy.voiceUnavailable,
        type: ToastType.warning,
      );
    }
  }
}

class _SoftPill extends StatelessWidget {
  final String text;

  const _SoftPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(9),
        vertical: dynamicHeight(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.lineLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyle.create(
          fontSize: 9.5,
          weight: FontWeights.bold,
          color: AppColors.inkSecondary,
        ),
      ),
    );
  }
}

/// Horizontally scrolling strip of the five result figures.
class _StatStrip extends StatelessWidget {
  final List<ScanStat> stats;

  const _StatStrip({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String labelOf(ScanStatKey key) => switch (key) {
      ScanStatKey.sodium => l10n.scanStatSodiumLabel,
      ScanStatKey.condition => l10n.scanStatConditionLabel,
      ScanStatKey.additives => l10n.scanStatAdditivesLabel,
      ScanStatKey.allergens => l10n.scanStatAllergensLabel,
      ScanStatKey.score => l10n.scanStatScoreLabel,
    };

    Color colorOf(ScanStatKey key) => switch (key) {
      ScanStatKey.sodium => AppColors.danger,
      ScanStatKey.condition => AppColors.warning,
      ScanStatKey.additives => AppColors.ink,
      ScanStatKey.allergens => AppColors.ink,
      ScanStatKey.score => AppColors.brand,
    };

    return SizedBox(
      height: dynamicHeight(84),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, _) => SizedBox(width: dynamicWidth(8)),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            width: dynamicWidth(96),
            padding: EdgeInsets.symmetric(
              horizontal: dynamicWidth(8),
              vertical: dynamicHeight(12),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                Text(
                  stat.value,
                  style: AppTextStyle.create(
                    fontSize: 18,
                    weight: FontWeights.bold,
                    color: colorOf(stat.key),
                  ),
                ),
                SizedBox(height: dynamicHeight(4)),
                Expanded(
                  child: Text(
                    labelOf(stat.key).toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.create(
                      fontSize: 9.5,
                      weight: FontWeights.bold,
                      color: AppColors.inkSecondary,
                      letterSpacing: 0.3,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoryBottomBar extends StatelessWidget {
  final int index;

  final int count;
  final Set<int> flaggedCards;
  final List<String> titles;
  final ValueChanged<int> onJump;
  const _StoryBottomBar({
    required this.index,
    required this.count,
    required this.flaggedCards,
    required this.titles,
    required this.onJump,
  });

  @override
  Widget build(BuildContext context) {
    final nextTitle = index < count - 1 ? titles[index + 1] : null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dynamicWidth(16),
        dynamicHeight(2),
        dynamicWidth(16),
        dynamicHeight(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < count; i++)
                Semantics(
                  button: true,
                  label: 'Story card ${i + 1}',
                  child: GestureDetector(
                    onTap: () => onJump(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      margin: EdgeInsets.symmetric(horizontal: dynamicWidth(2)),
                      width: i == index ? dynamicWidth(18) : dynamicWidth(6),
                      height: dynamicHeight(6),
                      decoration: BoxDecoration(
                        color: i == index
                            ? AppColors.brand
                            : flaggedCards.contains(i)
                            ? AppColors.danger.withValues(alpha: 0.45)
                            : AppColors.line,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: dynamicHeight(8)),
          Row(
            children: [
              Expanded(
                child: index > 0
                    ? Row(
                        children: [
                          const Icon(
                            Icons.west_rounded,
                            size: 13,
                            color: AppColors.inkTertiary,
                          ),
                          SizedBox(width: dynamicWidth(4)),
                          Flexible(
                            child: Text(
                              ScanStoryCopy.tapBack,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.create(
                                fontSize: 10.5,
                                color: AppColors.inkTertiary,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(width: dynamicWidth(8)),
              Expanded(
                child: nextTitle != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              'Next: $nextTitle',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: AppTextStyle.create(
                                fontSize: 10.5,
                                weight: FontWeights.bold,
                                color: AppColors.brandDark,
                              ),
                            ),
                          ),
                          SizedBox(width: dynamicWidth(4)),
                          const Icon(
                            Icons.east_rounded,
                            size: 13,
                            color: AppColors.brand,
                          ),
                        ],
                      )
                    : Text(
                        ScanStoryCopy.endOfStory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTextStyle.create(
                          fontSize: 10.5,
                          weight: FontWeights.bold,
                          color: AppColors.inkSecondary,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String tag;

  final IconData tagIcon;
  final _StoryTone tone;
  final String title;
  final List<Widget> children;
  final bool showListen;
  final bool listening;
  final VoidCallback? onListen;
  const _StoryCard({
    required this.tag,
    required this.tagIcon,
    required this.tone,
    required this.title,
    required this.children,
    this.showListen = true,
    this.listening = false,
    this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        dynamicWidth(16),
        dynamicHeight(12),
        dynamicWidth(16),
        dynamicHeight(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _StoryTag(text: tag, icon: tagIcon, tone: tone),
                ),
              ),
              if (showListen) ...[
                SizedBox(width: dynamicWidth(8)),
                _ListenPill(listening: listening, onTap: onListen),
              ],
            ],
          ),
          SizedBox(height: dynamicHeight(10)),
          Text(
            title,
            style: AppTextStyle.create(
              fontSize: 20,
              weight: FontWeights.bold,
              color: AppColors.ink,
              height: 1.2,
            ),
          ),
          SizedBox(height: dynamicHeight(12)),
          ...children,
        ],
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  final String title;

  final String subtitle;
  final String voiceCode;
  final VoidCallback onBack;
  final VoidCallback onVoiceLanguage;
  const _StoryHeader({
    required this.title,
    required this.subtitle,
    required this.voiceCode,
    required this.onBack,
    required this.onVoiceLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dynamicWidth(12),
        dynamicHeight(8),
        dynamicWidth(12),
        dynamicHeight(4),
      ),
      child: Row(
        children: [
          _HeaderButton(
            icon: Icons.chevron_left,
            label: l10n.a11yBack,
            onTap: onBack,
          ),
          SizedBox(width: dynamicWidth(8)),
          Container(
            width: dynamicWidth(38),
            height: dynamicWidth(38),
            decoration: BoxDecoration(
              color: AppColors.brandBackground,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: AppColors.brand.withValues(alpha: 0.18),
              ),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              size: 21,
              color: AppColors.brand,
            ),
          ),
          SizedBox(width: dynamicWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.create(
                    fontSize: 14,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: dynamicHeight(1)),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.create(
                    fontSize: 10.5,
                    color: AppColors.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: dynamicWidth(6)),
          _VoiceLanguageChip(code: voiceCode, onTap: onVoiceLanguage),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Story chrome
// ---------------------------------------------------------------------------

class _StoryProgress extends StatelessWidget {
  final Animation<double> progress;

  final int index;
  final int count;
  const _StoryProgress({
    required this.progress,
    required this.index,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return Row(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) SizedBox(width: dynamicWidth(4)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox(
                    height: dynamicHeight(3),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(color: AppColors.line),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: i < index
                                ? 1
                                : i == index
                                ? progress.value
                                : 0,
                            heightFactor: 1,
                            child: const ColoredBox(color: AppColors.brand),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _StoryTag extends StatelessWidget {
  final String text;

  final IconData icon;
  final _StoryTone tone;
  const _StoryTag({required this.text, required this.icon, required this.tone});

  @override
  Widget build(BuildContext context) {
    final (background, border, foreground) = switch (tone) {
      _StoryTone.brand => (
        AppColors.brandBackground,
        AppColors.brand.withValues(alpha: 0.22),
        AppColors.brandDark,
      ),
      _StoryTone.danger => (
        AppColors.dangerBackground,
        AppColors.dangerLine,
        AppColors.danger,
      ),
      _StoryTone.warning => (
        AppColors.warningBackground,
        AppColors.warningLine,
        AppColors.warningText,
      ),
      _StoryTone.success => (
        AppColors.brandBackground,
        AppColors.brand.withValues(alpha: 0.3),
        AppColors.brandDark,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(9),
        vertical: dynamicHeight(5),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: foreground),
          SizedBox(width: dynamicWidth(4)),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.create(
                fontSize: 9,
                weight: FontWeights.bold,
                color: foreground,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Story cards
// ---------------------------------------------------------------------------

enum _StoryTone { brand, danger, warning, success }

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dynamicWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _VoiceLanguageChip extends StatelessWidget {
  final String code;

  final VoidCallback onTap;
  const _VoiceLanguageChip({required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = AppLocales.chipLabels[code] ?? code.toUpperCase();
    return Semantics(
      button: true,
      label: 'Voice language: ${ScanStoryCopy.languageName(code)}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(8),
            vertical: dynamicHeight(6),
          ),
          decoration: BoxDecoration(
            color: AppColors.brandBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.brand.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.record_voice_over_outlined,
                size: 12,
                color: AppColors.brand,
              ),
              SizedBox(width: dynamicWidth(4)),
              Text(
                label,
                style: AppTextStyle.create(
                  fontSize: 10,
                  weight: FontWeights.bold,
                  color: AppColors.brandDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Full list (former result screen) shown from the story's last card
// ---------------------------------------------------------------------------

class _VoicePlayer extends StatelessWidget {
  final bool playing;

  final String languageName;
  final VoidCallback onTap;
  const _VoicePlayer({
    required this.playing,
    required this.languageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Row(
        children: [
          Semantics(
            button: true,
            label: playing ? ScanStoryCopy.pause : 'Play voiceover',
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: dynamicWidth(44),
                height: dynamicWidth(44),
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brand.withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 24,
                  color: AppColors.surface,
                ),
              ),
            ),
          ),
          SizedBox(width: dynamicWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ScanStoryCopy.listenVoiceover,
                  style: AppTextStyle.create(
                    fontSize: 13,
                    weight: FontWeights.bold,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: dynamicHeight(2)),
                Text(
                  ScanStoryCopy.listenHint(languageName),
                  style: AppTextStyle.create(
                    fontSize: 10.5,
                    color: AppColors.inkSecondary,
                  ),
                ),
                SizedBox(height: dynamicHeight(6)),
                _VoiceWave(active: playing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceWave extends StatefulWidget {
  final bool active;

  const _VoiceWave({required this.active});

  @override
  State<_VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<_VoiceWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dynamicHeight(20),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < 18; i++) ...[
                if (i > 0) SizedBox(width: dynamicWidth(2)),
                Expanded(
                  child: Container(
                    height: _barHeight(i),
                    decoration: BoxDecoration(
                      color: AppColors.brand.withValues(
                        alpha: widget.active ? 0.8 : 0.25,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _VoiceWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.active) _controller.repeat();
  }

  double _barHeight(int index) {
    if (!widget.active) return dynamicHeight(4);
    final wave = (math.sin(_controller.value * math.pi * 2 + index * 0.55))
        .abs();
    return dynamicHeight(4 + wave * 14);
  }
}

class _WarningNote extends StatelessWidget {
  final String text;

  const _WarningNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: dynamicWidth(11),
        vertical: dynamicHeight(9),
      ),
      decoration: BoxDecoration(
        color: AppColors.warningBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warningLine),
      ),
      child: Text(
        text,
        style: AppTextStyle.create(
          fontSize: 10,
          color: AppColors.warningText,
          height: 1.5,
        ),
      ),
    );
  }
}
