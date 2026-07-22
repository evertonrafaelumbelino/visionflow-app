import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  int _selectedIndex = 0; // Português (Brasil) selecionado por padrão

  static const List<Map<String, String>> _languages = [
    {'flag': '🇧🇷', 'name': 'Português (Brasil)'},
    {'flag': '🇺🇸', 'name': 'English (United States)'},
    {'flag': '🇪🇸', 'name': 'Español (España)'},
    {'flag': '🇲🇽', 'name': 'Español (México)'},
    {'flag': '🇫🇷', 'name': 'Français'},
    {'flag': '🇩🇪', 'name': 'Deutsch'},
    {'flag': '🇮🇹', 'name': 'Italiano'},
    {'flag': '🇯🇵', 'name': '日本語 (Nihongo)'},
    {'flag': '🇨🇳', 'name': '中文 (Zhōngwén)'},
    {'flag': '🇰🇷', 'name': '한국어 (Hangug-eo)'},
    {'flag': '🇷🇺', 'name': 'Русский (Russkiy)'},
    {'flag': '🇮🇳', 'name': 'हिन्दी (Hindi)'},
    {'flag': '🇸🇦', 'name': "العربية (Al-'Arabīyah)"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Idioma',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Subtítulo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Escolha o idioma do aplicativo',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lista de idiomas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = _selectedIndex == index;
                final isFirst = index == 0;

                return Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        borderRadius: isFirst
                            ? BorderRadius.circular(16)
                            : BorderRadius.circular(0),
                        splashColor:
                            AppColors.primaryColor.withValues(alpha: 0.1),
                        highlightColor:
                            AppColors.primaryColor.withValues(alpha: 0.05),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: isFirst
                                ? (isDark
                                    ? AppColors.darkSurface
                                    : Colors.white)
                                : Colors.transparent,
                            borderRadius: isFirst
                                ? BorderRadius.circular(16)
                                : null,
                            border: isFirst
                                ? Border.all(
                                    color: isDark
                                        ? AppColors.primaryColor
                                            .withValues(alpha: 0.3)
                                        : AppColors.iconColor
                                            .withValues(alpha: 0.2),
                                  )
                                : null,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                lang['flag']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: isDark
                                      ? AppColors.primaryColor
                                      : AppColors.iconColor,
                                  size: 24,
                                )
                              else
                                Icon(
                                  Icons.radio_button_unchecked_rounded,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!isFirst && index < _languages.length - 1)
                      Divider(
                        height: 1,
                        indent: 60,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                    if (isFirst) const SizedBox(height: 8),
                  ],
                )
                    .animate()
                    .fade(duration: 300.ms, delay: (index * 40).ms)
                    .slideX(begin: 0.05, end: 0);
              },
            ),
          ),

          // Nota de rodapé
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'O idioma selecionado será aplicado em todo o aplicativo.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
