library;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/ble_repository.dart';

/// Widget que exibe o status atual da conexão BLE
/// 
/// Mostra indicador visual e texto do estado da conexão
/// Design de alto contraste para acessibilidade

class ConnectionStatus extends StatelessWidget {
  final BleConnectionStatus status;
  final String? deviceName;
  final VoidCallback? onRetry;
  
  const ConnectionStatus({
    super.key,
    required this.status,
    this.deviceName,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    log.ui('Building ConnectionStatus: $status');
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(),
          width: 3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone de status
          Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 64,
          ),
          
          const SizedBox(height: AppTheme.paddingMedium),
          
          // Título do status
          Text(
            _getStatusTitle(),
            style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.paddingSmall),
          
          // Descrição do status
          if (deviceName != null)
            Text(
              _getStatusDescription(),
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          
          // Botão de retry (se houver erro)
          if (status == BleConnectionStatus.erro && onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: AppTheme.paddingMedium),
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningColor,
                  foregroundColor: AppTheme.textOnPrimary,
                  minimumSize: const Size(
                    double.infinity,
                    AppTheme.buttonMinHeight,
                  ),
                ),
                child: const Text(
                  'TENTAR NOVAMENTE',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Retorna a cor baseada no status
  Color _getStatusColor() {
    switch (status) {
      case BleConnectionStatus.desconectado:
        return AppTheme.textSecondary;
      case BleConnectionStatus.escaneando:
        return AppTheme.warningColor;
      case BleConnectionStatus.conectando:
        return AppTheme.warningColor;
      case BleConnectionStatus.conectado:
        return AppTheme.successColor;
      case BleConnectionStatus.erro:
        return AppTheme.errorColor;
      case BleConnectionStatus.desconectando:
        return AppTheme.warningColor;
    }
  }
  
  /// Retorna o ícone baseado no status
  IconData _getStatusIcon() {
    switch (status) {
      case BleConnectionStatus.desconectado:
        return Icons.bluetooth_disabled;
      case BleConnectionStatus.escaneando:
        return Icons.search;
      case BleConnectionStatus.conectando:
        return Icons.bluetooth_searching;
      case BleConnectionStatus.conectado:
        return Icons.bluetooth_connected;
      case BleConnectionStatus.erro:
        return Icons.error_outline;
      case BleConnectionStatus.desconectando:
        return Icons.bluetooth_disabled;
    }
  }
  
  /// Retorna o título baseado no status
  String _getStatusTitle() {
    switch (status) {
      case BleConnectionStatus.desconectado:
        return 'DESCONECTADO';
      case BleConnectionStatus.escaneando:
        return 'ESCANEANDO DISPOSITIVOS';
      case BleConnectionStatus.conectando:
        return 'CONECTANDO...';
      case BleConnectionStatus.conectado:
        return 'CONECTADO';
      case BleConnectionStatus.erro:
        return 'ERRO DE CONEXÃO';
      case BleConnectionStatus.desconectando:
        return 'DESCONECTANDO...';
    }
  }
  
  /// Retorna a descrição baseada no status
  String _getStatusDescription() {
    switch (status) {
      case BleConnectionStatus.desconectado:
        return 'Toque em "Buscar Óculos" para conectar';
      case BleConnectionStatus.escaneando:
        return 'Procurando VisionFlow-ESP32...';
      case BleConnectionStatus.conectando:
        return 'Conectando a $deviceName...';
      case BleConnectionStatus.conectado:
        return 'Conectado a $deviceName';
      case BleConnectionStatus.erro:
        return 'Não foi possível conectar. Tente novamente.';
      case BleConnectionStatus.desconectando:
        return 'Desconectando de $deviceName...';
    }
  }
}