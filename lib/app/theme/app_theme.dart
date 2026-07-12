import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_decorations.dart';
import 'app_typography.dart';

/// Tema do VisionFlow App
class AppTheme {
  AppTheme._();

  // Re-export tokens for backward compatibility
  static const Color primaryBackground = AppColors.primaryBackground;
  static const Color surfaceColor = AppColors.surfaceColor;
  static const Color primaryColor = AppColors.primaryColor;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color secondaryColor = AppColors.secondaryColor;

  // Corrigidos conforme a paleta fornecida
  static const Color iconColor = Color(0xFF4F7D8C);
  static const Color successColor = Color(0xFF7BCFA4);
  static const Color warningColor = Color(0xFFF2C97D);

  static const Color errorColor = AppColors.errorColor;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textOnPrimary = AppColors.textOnPrimary;
  static const Color textDisabled = AppColors.textDisabled;

  static const double fontSizeSmall = AppTypography.fontSizeSmall;
  static const double fontSizeMedium = AppTypography.fontSizeMedium;
  static const double fontSizeLarge = AppTypography.fontSizeLarge;
  static const double fontSizeXLarge = AppTypography.fontSizeXLarge;
  static const double fontSizeXXLarge = AppTypography.fontSizeXXLarge;

  static const double paddingSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double buttonMinHeight = 56.0;
  static const double buttonMinWidth = 120.0;
  static const double buttonBorderRadius = AppDecorations.buttonBorderRadius;
  static const double cardBorderRadius = AppDecorations.cardBorderRadius;
  static const double cardElevation = 4.0;

  static const double iconSizeSmall = 24.0;
  static const double iconSizeMedium = 32.0;
  static const double iconSizeLarge = 48.0;

  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 20.0;
  static const double cardShadow = 4.0;

  static ThemeData get lightTheme => _buildTheme(isDark: false);

  static ThemeData get darkTheme => _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    final primary = isDark ? AppColors.darkPrimary : AppColors.primaryColor;
    final secondary =
        isDark ? AppColors.darkSecondary : AppColors.secondaryColor;
    final surface = isDark ? AppColors.darkSurface : AppColors.surfaceColor;
    final scaffoldBg =
        isDark ? AppColors.darkBackground : AppColors.primaryBackground;
    final onSurface =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.cardLight;



    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: secondary,
        onSecondary: onSurface,
        error: AppColors.errorColor,
        onError: AppColors.textOnPrimary,
        surface: surface,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: AppTypography.textTheme(isDark: isDark),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppDecorations.primaryButton(isDark: isDark),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: isDark ? 0 : cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.textTheme(isDark: isDark).titleLarge,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardLight,
        selectedItemColor: primary,
        unselectedItemColor:
            isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSecondary : AppColors.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingMedium,
        ),
        labelStyle: TextStyle(
          fontSize: fontSizeMedium,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      dividerColor: isDark
          ? AppColors.darkTextSecondary.withValues(alpha: 0.2)
          : AppColors.textSecondary.withValues(alpha: 0.2),
    );
  }
}
