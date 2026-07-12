import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/esp32_device.dart';

/// Widget que exibe um dispositivo ESP32 descoberto
/// Design moderno com card branco e sombras suaves
class DeviceCard extends StatelessWidget {
  final Esp32Device device;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;
  
  const DeviceCard({
    super.key,
    required this.device,
    this.isSelected = false,
    this.onTap,
    this.onConnect,
  });
  
  @override
  Widget build(BuildContext context) {
    log.ui('Building DeviceCard for ${device.displayName}');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cardBgColor = isSelected 
        ? (isDark ? AppColors.darkSecondary : AppTheme.secondaryColor)
        : (isDark ? AppColors.darkSurface : Colors.white);
        
    final textColor = isSelected 
        ? AppTheme.textOnPrimary 
        : (isDark ? Colors.white : AppTheme.textPrimary);
        
    final subTextColor = isSelected 
        ? AppTheme.textOnPrimary.withValues(alpha: 0.8)
        : (isDark ? AppColors.darkTextSecondary : AppTheme.textSecondary);
        
    final infoBgColor = isSelected 
        ? AppTheme.textOnPrimary.withValues(alpha: 0.1)
        : (isDark ? AppColors.darkBackground : AppTheme.surfaceColor);

    return Card(
      color: cardBgColor,
      elevation: isSelected ? 8 : 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        side: BorderSide(
          color: isSelected 
              ? (isDark ? AppColors.primaryColor : AppTheme.primaryColor)
              : (isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.surfaceColor),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho do card
              Row(
                children: [
                  // Ícone Bluetooth
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : (isDark ? AppColors.darkBackground : AppTheme.secondaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bluetooth_rounded,
                      color: isSelected 
                          ? AppTheme.textOnPrimary 
                          : AppColors.iconColor,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: AppTheme.paddingMedium),
                  
                  // Nome e status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.displayName,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt_rounded,
                              size: 16,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              device.signalStrength,
                              style: TextStyle(
                                fontSize: AppTheme.fontSizeSmall,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Indicador de conexão
                  if (device.isConnected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: AppTheme.textOnPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Conectado',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textOnPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: AppTheme.paddingMedium),
              
              // Informações detalhadas
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                decoration: BoxDecoration(
                  color: infoBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      icon: Icons.wifi_rounded,
                      label: 'RSSI',
                      value: '${device.rssi} dBm',
                      isSelected: isSelected,
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: isSelected 
                          ? AppTheme.textOnPrimary.withValues(alpha: 0.2)
                          : (isDark ? Colors.white.withValues(alpha: 0.1) : AppTheme.textSecondary.withValues(alpha: 0.2)),
                    ),
                    _buildInfoItem(
                      icon: Icons.signal_cellular_4_bar_rounded,
                      label: 'Sinal',
                      value: device.signalStrength,
                      isSelected: isSelected,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              
              // Botão de conexão
              if (onConnect != null && !device.isConnected) ...[
                const SizedBox(height: AppTheme.paddingMedium),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onConnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected 
                          ? AppTheme.textOnPrimary 
                          : AppTheme.primaryColor,
                      foregroundColor: isSelected 
                          ? AppTheme.textPrimary 
                          : AppTheme.textOnPrimary,
                      minimumSize: const Size(
                        double.infinity,
                        AppTheme.buttonMinHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDecorations.buttonBorderRadius),
                      ),
                    ),
                    child: const Text(
                      'CONECTAR',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  /// Constrói um item de informação (ícone + label + valor)
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isSelected,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: isSelected 
              ? AppTheme.textOnPrimary.withValues(alpha: 0.8)
              : (isDark ? AppColors.primaryColor : AppTheme.iconColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected 
                ? AppTheme.textOnPrimary.withValues(alpha: 0.7)
                : (isDark ? AppColors.darkTextSecondary : AppTheme.textSecondary),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected 
                ? AppTheme.textOnPrimary
                : (isDark ? Colors.white : AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}