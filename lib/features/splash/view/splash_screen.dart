import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/storage/app_prefs.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../l10n/generated/app_localizations.dart';

/// HTML screen 1 — splash with gradient background, brand mark,
/// product name and the one-line promise.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _minSplashDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _proceed();
  }

  Future<void> _proceed() async {
    // Preferences are already restored in main() before the first frame.
    await Future<void>.delayed(_minSplashDuration);
    if (!mounted) return;
    final location = AppRouter.resolveStartLocation(
      isAuthenticated: AppPrefs.demoAuthenticated,
      onboardingComplete: AppPrefs.onboardingComplete,
      termsAccepted: AppPrefs.termsAccepted,
    );
    if (!mounted) return;
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dynamicWidth(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: dynamicWidth(88),
                    height: dynamicHeight(88),
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: CustomPaint(
                      painter: BrandMarkPainter(color: AppColors.surface),
                      size: Size.square(dynamicWidth(44)),
                    ),
                  ),
                  SizedBox(height: dynamicHeight(22)),
                  Text(
                    l10n.appName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: dynamicHeight(10)),
                  Text(
                    l10n.appTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.inkSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Hand-drawn reproduction of the SVG brand mark from the HTML reference:
/// an outlined droplet with a vertical stroke inside.
class BrandMarkPainter extends CustomPainter {
  BrandMarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    final droplet = Path()
      ..moveTo(12 * scale, 2 * scale)
      ..cubicTo(
        8 * scale,
        6 * scale,
        5 * scale,
        9.5 * scale,
        5 * scale,
        13 * scale,
      )
      ..arcTo(
        Rect.fromCircle(
          center: Offset(12 * scale, 13 * scale),
          radius: 7 * scale,
        ),
        math.pi,
        -math.pi,
        false,
      )
      ..cubicTo(
        19 * scale,
        9.5 * scale,
        16 * scale,
        6 * scale,
        12 * scale,
        2 * scale,
      )
      ..close();

    canvas.drawPath(droplet, paint);

    final stroke = Path()
      ..moveTo(12 * scale, 8 * scale)
      ..lineTo(12 * scale, 13 * scale);
    canvas.drawPath(stroke, paint);
  }

  @override
  bool shouldRepaint(BrandMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
