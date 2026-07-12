import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Decorações Soft UI do VisionFlow App
class AppDecorations {
  AppDecorations._();

  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 16.0;
  static const double chipBorderRadius = 12.0;
  static const double quickActionBorderRadius = 16.0;

  /// SoftCardDecoration — dupla sombra (highlight + shadow)
  static BoxDecoration softCard({required bool isDark, Color? color}) {
    final Color bg =
        color ?? (isDark ? const Color(0xFF1C252E) : const Color(0xFFE8EEF3));
    if (isDark) {
      // Sombra dupla para dark: highlight sutil + shadow "embaixo"
      return BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          // Highlight sutil no topo (fake source light)
          const BoxShadow(
            color: Color(0xFF223049), // um azul escuro suave como highlight
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(-3, -3),
          ),
          // Shadow dark principal
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(4, 8),
          ),
        ],
      );
    } else {
      // Sombra dupla para light: highlight + shadow
      return BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          // Highlight
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 8,
            offset: const Offset(-4, -4),
            spreadRadius: 1,
          ),
          // Shadow principal
          BoxShadow(
            color: const Color(0xFFB0BEC5).withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(4, 6),
            spreadRadius: 2,
          ),
        ],
      );
    }
  }

  /// QuickActionDecoration — botões quadrados arredondados (raio 16)
  static BoxDecoration quickAction({required bool isDark}) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1C252E) : const Color(0xFFE8EEF3),
      borderRadius: BorderRadius.circular(quickActionBorderRadius),
      boxShadow: [
        if (!isDark)
          BoxShadow(
            color: const Color(0xFF4F7D8C).withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(2, 4),
          )
        else
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
      ],
      // Para ícone em #4F7D8C, o usuário deve setar explicitamente nos ícones deste botão.
    );
  }

  /// Estilo do botão primário - #6FA8DC
  static ButtonStyle primaryButton({required bool isDark}) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6FA8DC),
      foregroundColor: AppColors.textOnPrimary,
      minimumSize: const Size(120, 56),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
      elevation: isDark ? 0 : 2,
    );
  }

  /// Estilo do botão secundário - #A8C9E6
  static ButtonStyle secondaryButton({required bool isDark}) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA8C9E6),
      foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      minimumSize: const Size(120, 56),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
      elevation: 0,
    );
  }
}
