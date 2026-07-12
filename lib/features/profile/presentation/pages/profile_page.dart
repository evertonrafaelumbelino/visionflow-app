import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../core/mock/app_mock_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _highContrast = true;
  bool _ttsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de Perfil do Usuário
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar Acessível
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                        width: 2.5,
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 54,
                      color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nome e Versão do App
                  Text(
                    AppMockData.displayUserName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aplicativo VisionFlow - ${AppMockData.versionLabel}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Seção de Preferências e Acessibilidade (Alto Contraste / Toggles)
            Text(
              'Acessibilidade',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ).animate().fade(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 12),

            Column(
              children: [
                _buildToggleTile(
                  icon: Icons.contrast_rounded,
                  title: 'Alto Contraste',
                  value: _highContrast,
                  isDark: isDark,
                  onChanged: (val) {
                    setState(() {
                      _highContrast = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildToggleTile(
                  icon: Icons.record_voice_over_rounded,
                  title: 'Leitor de Tela (TTS)',
                  value: _ttsEnabled,
                  isDark: isDark,
                  onChanged: (val) {
                    setState(() {
                      _ttsEnabled = val;
                    });
                  },
                ),
              ],
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Seção de Menu Adicional
            Text(
              'Configurações',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ).animate().fade(duration: 400.ms, delay: 150.ms),

            const SizedBox(height: 12),

            Column(
              children: [
                _buildMenuTile(
                  icon: Icons.account_circle_outlined,
                  title: 'Configurações da conta',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildMenuTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Ajuda e suporte',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildMenuTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Sobre o VisionFlow',
                  isDark: isDark,
                  onTap: () {},
                ),
              ],
            ).animate().fade(duration: 600.ms, delay: 150.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      height: 64, // Altura acessível
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDark ? AppColors.primaryColor : AppColors.iconColor, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 64, // Altura acessível
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isDark ? AppColors.primaryColor : AppColors.iconColor, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
