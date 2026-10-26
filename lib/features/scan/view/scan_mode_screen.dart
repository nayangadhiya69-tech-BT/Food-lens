import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/common_scaffold.dart';
import '../model/scan_mode.dart';
import '../view_model/scan_view_model.dart';

/// HTML screen 6 — Scan mode: the two entry points of the scan flow,
/// barcode (fast path) or photo (two-shot fallback). Picked from Home's
/// "Scan a product" CTA; choosing an option starts a fresh session and
/// pushes the matching capture screen.
class ScanModeScreen extends StatelessWidget {
  const ScanModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    void open(ScanMode mode) {
      context.read<ScanViewModel>().startSession(mode);
      context.push(
        mode == ScanMode.barcode ? AppRoutes.scanBarcode : AppRoutes.scanPhoto,
      );
    }

    return CommonScaffold(
      title: l10n.scanModeTitle,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.home);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ScanOptionCard(
            icon: Icons.qr_code_scanner,
            title: l10n.scanModeBarcodeTitle,
            body: l10n.scanModeBarcodeBody,
            onTap: () => open(ScanMode.barcode),
          ),
          SizedBox(height: dynamicHeight(14)),
          _ScanOptionCard(
            icon: Icons.photo_camera_outlined,
            title: l10n.scanModePhotoTitle,
            body: l10n.scanModePhotoBody,
            onTap: () => open(ScanMode.photo),
          ),
        ],
      ),
    );
  }
}

/// White option card with a brand-tinted icon tile — the `.scan-opt`
/// component of the HTML design.
class _ScanOptionCard extends StatelessWidget {
  final IconData icon;

  final String title;
  final String body;
  final VoidCallback onTap;
  const _ScanOptionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(dynamicWidth(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: dynamicWidth(44),
                height: dynamicHeight(44),
                decoration: BoxDecoration(
                  color: AppColors.brandBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: AppColors.brand),
              ),
              SizedBox(width: dynamicWidth(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.create(
                        fontSize: 15,
                        weight: FontWeights.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: dynamicHeight(4)),
                    Text(
                      body,
                      style: AppTextStyle.create(
                        fontSize: 12.5,
                        color: AppColors.inkSecondary,
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
  }
}
