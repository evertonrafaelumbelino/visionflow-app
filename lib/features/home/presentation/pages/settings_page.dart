import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          'Configurações',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Sobre',
              style: TextStyle(
                color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Conectividade e Dispositivo ──
            _buildSectionHeader(
              icon: Icons.bluetooth_rounded,
              title: 'Conectividade e Dispositivo',
              isDark: isDark,
            ).animate().fade(duration: 300.ms),
            const SizedBox(height: 12),
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.bluetooth_connected_rounded,
                    title: 'Conexão Bluetooth',
                    subtitle: 'SmartGlass v2 (Ativo)',
                    isDark: isDark,
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.add_rounded,
                    title: 'Parear Novo Óculos',
                    isDark: isDark,
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: 0.08, end: 0),

            const SizedBox(height: 24),

            // ── Preferências das Funções ──
            _buildSectionHeader(
              icon: Icons.tune_rounded,
              title: 'Preferências das Funções',
              isDark: isDark,
            ).animate().fade(duration: 300.ms, delay: 50.ms),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PreferenceCard(
                    icon: Icons.camera_alt_rounded,
                    title: 'Câmera',
                    subtitle: 'Captura de mídia\ne Privacidade',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PreferenceCard(
                    icon: Icons.navigation_rounded,
                    title: 'Navegação',
                    subtitle: 'Mapas & Rota\npadrão',
                    isDark: isDark,
                  ),
                ),
              ],
            ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.08, end: 0),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PreferenceCard(
                    icon: Icons.translate_rounded,
                    title: 'Tradução',
                    subtitle: 'Idiomas e\nAtalhos',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PreferenceCard(
                    icon: Icons.volume_up_rounded,
                    title: 'Áudio e Voz',
                    subtitle: 'Volume &\nComandos',
                    isDark: isDark,
                  ),
                ),
              ],
            ).animate().fade(duration: 400.ms, delay: 150.ms).slideY(begin: 0.08, end: 0),

            const SizedBox(height: 24),

            // ── Notificações e Alertas ──
            _buildSectionHeader(
              icon: Icons.notifications_rounded,
              title: 'Notificações e Alertas',
              isDark: isDark,
            ).animate().fade(duration: 300.ms, delay: 100.ms),
            const SizedBox(height: 12),
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.tune_rounded,
                    title: 'Gerenciar Notificações',
                    subtitle: 'Filtros de apps & Prioridade',
                    isDark: isDark,
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.do_not_disturb_on_outlined,
                    title: 'Modo Não Perturbe',
                    isDark: isDark,
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms, delay: 150.ms).slideY(begin: 0.08, end: 0),

            const SizedBox(height: 24),

            // ── Conta e Suporte ──
            _buildSectionHeader(
              icon: Icons.person_rounded,
              title: 'Conta e Suporte',
              isDark: isDark,
            ).animate().fade(duration: 300.ms, delay: 150.ms),
            const SizedBox(height: 12),
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Perfil do Usuário',
                    subtitle: 'Informações da conta & Segurança',
                    isDark: isDark,
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Ajuda & Suporte',
                    subtitle: 'Tutoriais & FAQ',
                    isDark: isDark,
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Termos de Uso',
                    isDark: isDark,
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms, delay: 200.ms).slideY(begin: 0.08, end: 0),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.primaryColor : AppColors.iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Tile individual de configuração ──
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDark;
  final bool showDivider;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isDark,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
            highlightColor: AppColors.primaryColor.withValues(alpha: 0.05),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(icon,
                      color: isDark
                          ? AppColors.primaryColor
                          : AppColors.iconColor,
                      size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 54,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
      ],
    );
  }
}

// ── Card de preferência (grid 2x2) ──
class _PreferenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _PreferenceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
        highlightColor: AppColors.primaryColor.withValues(alpha: 0.05),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color:
                    isDark ? AppColors.primaryColor : AppColors.iconColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
