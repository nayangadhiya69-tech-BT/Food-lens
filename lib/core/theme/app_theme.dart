import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_text_style.dart';

/// Theme derived from the HTML reference. The HTML mock renders a 270px-wide
/// phone, so type sizes are mapped ~1.4x to a real ~390px viewport.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.brand,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brand,
        onPrimary: AppColors.surface,
        secondary: AppColors.brandBright,
        onSecondary: AppColors.surface,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.danger,
        onError: AppColors.surface,
        outline: AppColors.line,
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyle.create(
          fontSize: 17,
          weight: FontWeights.bold,
          color: AppColors.ink,
        ),
        iconTheme: IconThemeData(color: AppColors.ink),
        shape: Border(bottom: BorderSide(color: AppColors.line, width: 1)),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyle.create(
          fontSize: 30,
          weight: FontWeights.bold,
          color: AppColors.ink,
          height: 1.2,
        ),
        headlineMedium: AppTextStyle.create(
          fontSize: 24,
          weight: FontWeights.bold,
          color: AppColors.ink,
          height: 1.25,
        ),
        titleLarge: AppTextStyle.create(
          fontSize: 20,
          weight: FontWeights.bold,
          color: AppColors.ink,
          height: 1.3,
        ),
        titleMedium: AppTextStyle.create(
          fontSize: 17,
          weight: FontWeights.semibold,
          color: AppColors.ink,
          height: 1.35,
        ),
        titleSmall: AppTextStyle.create(
          fontSize: 15,
          weight: FontWeights.semibold,
          color: AppColors.ink,
          height: 1.35,
        ),
        bodyLarge: AppTextStyle.create(
          fontSize: 16,
          color: AppColors.ink,
          height: 1.45,
        ),
        bodyMedium: AppTextStyle.create(
          fontSize: 14,
          color: AppColors.inkSecondary,
          height: 1.5,
        ),
        bodySmall: AppTextStyle.create(
          fontSize: 12,
          color: AppColors.inkTertiary,
          height: 1.45,
        ),
        labelLarge: AppTextStyle.create(
          fontSize: 13,
          weight: FontWeights.bold,
          color: AppColors.ink,
        ),
        labelMedium: AppTextStyle.create(
          fontSize: 12,
          weight: FontWeights.semibold,
          color: AppColors.inkSecondary,
        ),
        labelSmall: AppTextStyle.create(
          fontSize: 11,
          weight: FontWeights.semibold,
          color: AppColors.inkTertiary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.lineLight,
          disabledForegroundColor: AppColors.inkTertiary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(24),
            vertical: dynamicHeight(16),
          ),
          minimumSize: Size.fromHeight(dynamicHeight(52)),
          textStyle: AppTextStyle.create(
            fontSize: 16,
            weight: FontWeights.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.inkTertiary,
          side: const BorderSide(color: AppColors.line),
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(24),
            vertical: dynamicHeight(14),
          ),
          minimumSize: Size.fromHeight(dynamicHeight(48)),
          textStyle: AppTextStyle.create(
            fontSize: 15,
            weight: FontWeights.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.inkSecondary,
          textStyle: AppTextStyle.create(
            fontSize: 14,
            weight: FontWeights.semibold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: dynamicWidth(16),
          vertical: dynamicHeight(16),
        ),
        labelStyle: const TextStyle(color: AppColors.inkTertiary),
        hintStyle: const TextStyle(color: AppColors.inkTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brand, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.line, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lineLight,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTextStyle.create(
          fontSize: 14,
          color: AppColors.surface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get dark => light.copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.ink,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.brand,
          onPrimary: AppColors.surface,
          secondary: AppColors.brandBright,
          onSecondary: AppColors.surface,
          surface: Color(0xFF1F2937),
          onSurface: Colors.white,
          error: AppColors.danger,
          onError: AppColors.surface,
          outline: Color(0xFF374151),
        ),
      );
}
