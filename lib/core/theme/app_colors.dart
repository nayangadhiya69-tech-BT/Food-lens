import 'package:flutter/material.dart';

/// Design tokens taken directly from the HTML reference
/// (`foodlens_app_fresh.html` `:root` variables).
class AppColors {
  // Brand
  static const Color brand = Color(0xFF059669);

  static const Color brandBright = Color(0xFF10B981);
  static const Color brandBackground = Color(0xFFECFDF5);
  static const Color brandDark = Color(0xFF065F46);
  // Ink / text
  static const Color ink = Color(0xFF111827);

  static const Color inkSecondary = Color(0xFF6B7280);
  static const Color inkTertiary = Color(0xFF9CA3AF);
  // Lines / surfaces
  static const Color line = Color(0xFFE5E7EB);

  static const Color lineLight = Color(0xFFF3F4F6);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  // Status
  static const Color danger = Color(0xFFDC2626);

  static const Color dangerBackground = Color(0xFFFEF2F2);
  static const Color dangerLine = Color(0xFFFECACA);
  static const Color dangerText = Color(0xFF9F3A3A);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningLine = Color(0xFFFDE68A);
  static const Color warningText = Color(0xFF8A6D1F);
  static const Color success = brand;
  static const Color info = Color(0xFF2196F3);
  static const Color error = danger;
  // Shadows
  static const Color shadow = Color(0x1A000000);

  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), brandBackground],
  );

  static const List<Color> primaryGradient = [brand, brandBright];

  AppColors._();
}
