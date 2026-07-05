import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema de alto contraste para acessibilidade do VisionFlow
/// Projetado para pessoas com deficiência visual
class AppTheme {
  // Cores de alto contraste
  static const Color primaryColor = Color(0xFF000000); // Preto puro
  static const Color secondaryColor = Color(0xFFFFD700); // Amarelo dourado
  static const Color backgroundColor = Color(0xFF000000); // Fundo preto
  static const Color surfaceColor = Color(0xFF1A1A1A); // Cinza muito escuro
  static const Color errorColor = Color(0xFFFF4444); // Vermelho para erros
  static const Color successColor = Color(0xFF00FF00); // Verde para sucesso
  static const Color warningColor = Color(0xFFFFAA00); // Laranja para avisos

  // Cores de texto
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco puro
  static const Color textSecondary = Color(0xFFCCCCCC); // Cinza claro
  static const Color textOnPrimary = Color(0xFF000000); // Texto preto sobre amarelo

  // Tamanhos de fonte grandes para acessibilidade
  static const double fontSizeSmall = 18.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeLarge = 32.0;
  static const double fontSizeXLarge = 40.0;

  // Espaçamentos generosos
  static const double paddingSmall = 16.0;
  static const double paddingMedium = 24.0;
  static const double paddingLarge = 32.0;

  // Botões grandes (mínimo 48x48dp para acessibilidade)
  static const double buttonMinHeight = 64.0;
  static const double buttonMinWidth = 120.0;

  /// Tema claro (na verdade é tema escuro de alto contraste)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.dark().textTheme.copyWith(
              displayLarge: TextStyle(
                fontSize: fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                height: 1.2,
              ),
              headlineMedium: TextStyle(
                fontSize: fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                height: 1.3,
              ),
              titleLarge: TextStyle(
                fontSize: fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: textPrimary,
                height: 1.4,
              ),
              bodyLarge: TextStyle(
                fontSize: fontSizeMedium,
                color: textPrimary,
                height: 1.5,
              ),
              bodyMedium: TextStyle(
                fontSize: fontSizeSmall,
                color: textSecondary,
                height: 1.5,
              ),
            ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: textOnPrimary,
          minimumSize: const Size(buttonMinWidth, buttonMinHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: secondaryColor, width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor, width: 3),
        ),
        labelStyle: const TextStyle(
          fontSize: fontSizeMedium,
          color: textSecondary,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
    );
  }

  /// Tema alternativo (caso queira modo claro no futuro)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        error: errorColor,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.light().textTheme.copyWith(
              displayLarge: const TextStyle(
                fontSize: fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              headlineMedium: const TextStyle(
                fontSize: fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
      ),
    );
  }
}