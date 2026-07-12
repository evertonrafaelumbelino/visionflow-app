import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../core/mock/app_mock_data.dart';
import '../../data/repositories/ble_repository_impl.dart';
import '../../domain/repositories/ble_repository.dart';

class ConnectedDevicePage extends StatefulWidget {
  const ConnectedDevicePage({super.key});

  @override
  State<ConnectedDevicePage> createState() => _ConnectedDevicePageState();
}

class _ConnectedDevicePageState extends State<ConnectedDevicePage> {
  final BleRepository _bleRepository = BleRepositoryImpl();
  bool _isDisconnecting = false;

  Future<void> _handleDisconnect() async {
    setState(() {
      _isDisconnecting = true;
    });

    try {
      await _bleRepository.disconnect();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Dispositivo desconectado com sucesso',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao desconectar: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDisconnecting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          'Meu dispositivo',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () {
            // Apenas para efeito visual do mockup, ou volta se necessário
          },
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
            // Card Principal do Dispositivo
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Cabeçalho com Nome, Editar, Bateria e Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppMockData.deviceName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.successColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Conectado',
                                style: TextStyle(
                                  color: AppColors.successColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.battery_charging_full_rounded,
                                size: 18,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.successColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppMockData.batteryLevel,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Imagem detalhada do óculos
                  Image.asset(
                    'assets/images/glasses_device.png',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.visibility,
                          size: 80,
                          color: isDark ? Colors.white24 : AppColors.textDisabled,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Lista de Opções Acessíveis (Touch targets de 56dp de altura)
            Column(
              children: [
                _buildOptionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Informações do dispositivo',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildOptionTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Atualizações',
                  subtitle: 'Versão ${AppMockData.firmwareVersion}',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildOptionTile(
                  icon: Icons.settings_outlined,
                  title: 'Configurações do óculos',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildOptionTile(
                  icon: Icons.location_on_outlined,
                  title: 'Encontrar meu óculos',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildOptionTile(
                  icon: Icons.logout_rounded,
                  title: 'Desconectar dispositivo',
                  isDark: isDark,
                  isDestructive: true,
                  isLoading: _isDisconnecting,
                  onTap: _handleDisconnect,
                ),
              ],
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isDark,
    bool isDestructive = false,
    bool isLoading = false,
    required VoidCallback onTap,
  }) {
    final Color textColor = isDestructive
        ? AppColors.errorColor
        : (isDark ? Colors.white : AppColors.textPrimary);
    
    final Color iconColor = isDestructive
        ? AppColors.errorColor
        : (isDark ? AppColors.primaryColor : AppColors.iconColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 64, // Altura acessível acima do padrão de 56dp
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
              Icon(icon, color: iconColor, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive
                      ? AppColors.errorColor.withValues(alpha: 0.5)
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
