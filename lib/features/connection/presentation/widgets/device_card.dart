import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/esp32_device.dart';

/// Widget que exibe um dispositivo ESP32 descoberto
/// 
/// Card com informações do dispositivo e botão de conexão
/// Design de alto contraste para acessibilidade

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
    
    return Card(
      color: isSelected ? AppTheme.secondaryColor : AppTheme.surfaceColor,
      elevation: isSelected ? 8 : 4,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppTheme.secondaryColor : AppTheme.textSecondary,
          width: isSelected ? 3 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome do dispositivo
              Row(
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: AppTheme.secondaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: AppTheme.paddingMedium),
                  Expanded(
                    child: Text(
                      device.displayName,
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        color: isSelected ? AppTheme.textOnPrimary : AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.paddingMedium),
              
              // Informações do dispositivo
              _buildInfoRow(
                icon: Icons.signal_cellular_alt,
                label: 'Sinal',
                value: device.signalStrength,
                valueColor: _getSignalColor(device.rssi),
              ),
              
              const SizedBox(height: AppTheme.paddingSmall),
              
              _buildInfoRow(
                icon: Icons.wifi,
                label: 'RSSI',
                value: '${device.rssi} dBm',
                valueColor: AppTheme.textSecondary,
              ),
              
              const SizedBox(height: AppTheme.paddingSmall),
              
              // Status de conexão
              Row(
                children: [
                  Icon(
                    device.isConnected ? Icons.check_circle : Icons.circle,
                    color: device.isConnected ? AppTheme.successColor : AppTheme.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    device.isConnected ? 'Conectado' : 'Não conectado',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: device.isConnected ? AppTheme.successColor : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.paddingMedium),
              
              // Botão de conexão
              if (onConnect != null && !device.isConnected)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onConnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: AppTheme.textOnPrimary,
                      minimumSize: const Size(
                        double.infinity,
                        AppTheme.buttonMinHeight,
                      ),
                    ),
                    child: const Text(
                      'CONECTAR',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              
              if (device.isConnected)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.successColor, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.successColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CONECTADO',
                        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Constrói uma linha de informação (ícone + label + valor)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
  
  /// Retorna a cor do sinal baseado no RSSI
  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return AppTheme.successColor;
    if (rssi >= -60) return AppTheme.successColor;
    if (rssi >= -70) return AppTheme.warningColor;
    if (rssi >= -80) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}