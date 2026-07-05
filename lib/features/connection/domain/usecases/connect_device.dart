library;

/// Use Case: Conectar a um dispositivo ESP32
/// 
/// Responsável por estabelecer conexão BLE com o ESP32

import '../repositories/ble_repository.dart';
import '../entities/esp32_device.dart';
import '../../../../core/constants/ble_constants.dart';
import '../../../../core/utils/logger.dart';

/// Parâmetros para conexão com dispositivo
class ConnectDeviceParams {
  final Esp32Device device;
  final int timeoutSeconds;
  
  const ConnectDeviceParams({
    required this.device,
    this.timeoutSeconds = BleConstants.connectionTimeoutSeconds,
  });
}

/// Use Case para conectar a um dispositivo ESP32
/// 
/// Encapsula a lógica de negócio para conexão BLE
class ConnectDevice {
  final BleRepository _bleRepository;
  
  ConnectDevice(this._bleRepository);
  
  /// Executa a conexão com o dispositivo ESP32
  Future<Esp32Device> call(ConnectDeviceParams params) async {
    try {
      log.ble('Iniciando conexão com ${params.device.displayName}...');
      
      // Verifica se já está conectado
      final isConnected = await _bleRepository.isConnected();
      if (isConnected) {
        log.warning('Já existe uma conexão ativa. Desconectando primeiro...');
        await _bleRepository.disconnect();
      }
      
      // Solicita aumento de MTU para transferências mais rápidas
      log.ble('Solicitando MTU de ${BleConstants.bleMtuSize} bytes...');
      final mtuResult = await _bleRepository.requestMtu(BleConstants.bleMtuSize);
      if (mtuResult.isSuccess && mtuResult.data != null) {
        log.success('MTU negociado: ${mtuResult.data} bytes');
      } else {
        log.warning('Não foi possível negociar MTU, usando valor padrão');
      }
      
      // Conecta ao dispositivo
      final result = await _bleRepository.connect(
        params.device,
        timeoutSeconds: params.timeoutSeconds,
      );
      
      if (!result.isSuccess) {
        throw Exception(result.error ?? 'Falha na conexão');
      }
      
      final connectedDevice = result.data!;
      
      log.success('Conectado com sucesso a ${connectedDevice.displayName}');
      log.ble('Sinal: ${connectedDevice.signalStrength} (RSSI: ${connectedDevice.rssi})');
      
      return connectedDevice;
      
    } catch (e, stackTrace) {
      log.error('Erro na conexão com ${params.device.displayName}', e, stackTrace);
      rethrow;
    }
  }
}