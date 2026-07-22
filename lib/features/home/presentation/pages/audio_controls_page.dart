import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';

class AudioControlsPage extends StatefulWidget {
  const AudioControlsPage({super.key});

  @override
  State<AudioControlsPage> createState() => _AudioControlsPageState();
}

class _AudioControlsPageState extends State<AudioControlsPage> {
  double _volume = 0.75;
  int _selectedAudioMode = 0; // 0: Transparência, 1: Cancelamento, 2: Melhoria
  int _selectedEqualizer = 0; // 0: Padrão, 1: Graves Boost, 2: Voz Clara

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header com gradiente ──
            Container(
              padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [const Color(0xFF2E3A46), const Color(0xFF4F7D8C)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botão voltar
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Controles de Áudio',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tudo certo com seus óculos',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Seus Óculos Estão\nConectados',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.successColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, color: AppColors.successColor, size: 8),
                                  SizedBox(width: 6),
                                  Text(
                                    'Conectado',
                                    style: TextStyle(
                                      color: AppColors.successColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Imagem dos óculos
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/glasses_hero.png',
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.headphones_rounded,
                                  size: 48, color: Colors.white54),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms),

            const SizedBox(height: 24),

            // ── Painel de Volume ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: AppDecorations.softCard(
                  isDark: isDark,
                  color: isDark ? AppColors.darkSurface : Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Painel de Volume',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${(_volume * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Slider de Volume
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: isDark ? AppColors.primaryColor : AppColors.iconColor,
                        inactiveTrackColor: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.2),
                        thumbColor: isDark ? AppColors.primaryColor : AppColors.iconColor,
                        overlayColor: AppColors.primaryColor.withValues(alpha: 0.1),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: (val) => setState(() => _volume = val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Ícones de controle rápido
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _VolumeControlButton(
                          icon: Icons.volume_up_rounded,
                          isActive: true,
                          isDark: isDark,
                          onTap: () => setState(() => _volume = 1.0),
                        ),
                        _VolumeControlButton(
                          icon: Icons.volume_off_rounded,
                          isActive: false,
                          isDark: isDark,
                          onTap: () => setState(() => _volume = 0.0),
                        ),
                        _VolumeControlButton(
                          icon: Icons.mic_rounded,
                          isActive: false,
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // ── Modos de Áudio ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Modos de Áudio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _AudioModeChip(
                    icon: Icons.hearing_rounded,
                    label: 'Modo\nTransparência',
                    isSelected: _selectedAudioMode == 0,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedAudioMode = 0),
                  ),
                  const SizedBox(width: 10),
                  _AudioModeChip(
                    icon: Icons.noise_control_off_rounded,
                    label: 'Cancelamento\nde Ruído',
                    isSelected: _selectedAudioMode == 1,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedAudioMode = 1),
                  ),
                  const SizedBox(width: 10),
                  _AudioModeChip(
                    icon: Icons.record_voice_over_rounded,
                    label: 'Melhoria de\nVoz',
                    isSelected: _selectedAudioMode == 2,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedAudioMode = 2),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // ── Equalizador ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Equalizador',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _EqualizerChip(
                    label: 'Padrão',
                    isSelected: _selectedEqualizer == 0,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedEqualizer = 0),
                  ),
                  const SizedBox(width: 10),
                  _EqualizerChip(
                    label: 'Graves Boost',
                    isSelected: _selectedEqualizer == 1,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedEqualizer = 1),
                  ),
                  const SizedBox(width: 10),
                  _EqualizerChip(
                    label: 'Voz Clara',
                    isSelected: _selectedEqualizer == 2,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedEqualizer = 2),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Botão circular de controle de volume ──
class _VolumeControlButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _VolumeControlButton({
    required this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: AppColors.primaryColor.withValues(alpha: 0.2),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                    ? AppColors.primaryColor.withValues(alpha: 0.2)
                    : AppColors.iconColor.withValues(alpha: 0.15))
                : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.withValues(alpha: 0.1)),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive
                ? (isDark ? AppColors.primaryColor : AppColors.iconColor)
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            size: 24,
          ),
        ),
      ),
    );
  }
}

// ── Chip de modo de áudio com ícone ──
class _AudioModeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _AudioModeChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primaryColor.withValues(alpha: 0.15),
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.primaryColor.withValues(alpha: 0.2)
                      : AppColors.iconColor.withValues(alpha: 0.15))
                  : (isDark ? AppColors.darkSurface : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? (isDark ? AppColors.primaryColor : AppColors.iconColor)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05)),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: isSelected
                      ? (isDark ? AppColors.primaryColor : AppColors.iconColor)
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.textPrimary)
                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Chip de equalizador ──
class _EqualizerChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _EqualizerChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primaryColor.withValues(alpha: 0.15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.primaryColor : AppColors.iconColor)
                  : (isDark ? AppColors.darkSurface : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.08)),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
