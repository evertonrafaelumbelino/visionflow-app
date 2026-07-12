import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tipografia centralizada do VisionFlow App
class AppTypography {
  AppTypography._();

  // Labels de navegação
  static const double fontSizeNavLabel = 12.0;
  // Headline (saudação)
  static const double fontSizeHeadline = 22.0; // Use 22–24px padrão como base
  // Métricas grandes (ex: 3h 45m)
  static const double fontSizeMetric = 32.0;

  // Outras escalas auxiliares para retrocompatibilidade/conveniência
  static const double fontSizeSmall = fontSizeNavLabel;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = fontSizeMetric;

  /// Retorna o TextTheme roboto ajustado com a hierarquia VisionFlow
  static TextTheme textTheme({required bool isDark}) {
    final primary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    // Comece da base para garantir herdabilidade correta
    final baseTheme = ThemeData(brightness: isDark ? Brightness.dark : Brightness.light).textTheme;

    return GoogleFonts.robotoTextTheme(baseTheme).copyWith(
      // Headline (saudação/greeting)
      headlineMedium: TextStyle(
        fontSize: fontSizeHeadline,
        fontWeight: FontWeight.bold,
        color: primary,
        height: 1.2,
      ),
      // Métrica grande (ex: duração, números de destaque) — usar displayLarge para facilitar uso
      displayLarge: TextStyle(
        fontSize: fontSizeMetric,
        fontWeight: FontWeight.bold,
        color: primary,
        height: 1.1,
      ),
      // Labels de navegação (bottom navigation e similares)
      labelSmall: TextStyle(
        fontSize: fontSizeNavLabel,
        fontWeight: FontWeight.w500,
        color: secondary,
        letterSpacing: 0.05,
        height: 1.3,
      ),
      // Hierarquia padrão (usando nomeação do textTheme para Theme.of(context).textTheme.titleLarge etc)
      titleLarge: TextStyle(
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.w600,
        color: primary,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.normal,
        color: primary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: secondary,
        height: 1.5,
      ),
      // Outros nomes possíveis (ajustando variantes do Material)
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: primary,
        height: 1.3,
      ),
    );
  }
}
