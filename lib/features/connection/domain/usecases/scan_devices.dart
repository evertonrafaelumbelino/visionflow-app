library;

/// Use Case: Escanear dispositivos BLE
/// 
/// Responsável por buscar dispositivos ESP32 próximos
/// Este é um exemplo de caso de uso da camada de domínio

import '../repositories/ble_repository.dart';
import '../entities/esp32_device.dart';
import '../../../../core/constants/ble_constants.dart';
import '../../../../core/utils/logger.dart';

/// Parâmetros para o scan de dispositivos
class ScanDevicesParams {
  final int timeoutSeconds;
  final bool filterByName;
  
  const ScanDevicesParams({
    this.timeoutSeconds = BleConstants.scanTimeoutSeconds,
    this.filterByName = true,
  });
}

/// Resultado do scan de dispositivos
class ScanDevicesResult {
  final List<Esp32Device> devices;
  final bool hasVisionFlowDevice;
  final Esp32Device? visionFlowDevice;
  
  const ScanDevicesResult({
    required this.devices,
    required this.hasVisionFlowDevice,
    this.visionFlowDevice,
  });
}

/// Use Case para escanear dispositivos BLE
/// 
/// Encapsula a lógica de negócio para scan de dispositivos
class ScanDevices {
  final BleRepository _bleRepository;
  
  ScanDevices(this._bleRepository);
  
  /// Executa o scan de dispositivos
  /// 
  /// Retorna um resultado com a lista de dispositivos encontrados
  /// e indica se o VisionFlow-ESP32 foi encontrado
  Future<ScanDevicesResult> call(ScanDevicesParams params) async {
    try {
      log.ble('Iniciando scan de dispositivos...');
      
      // Inicializa BLE se necessário
      final initResult = await _bleRepository.initialize();
      if (!initResult.isSuccess) {
        throw Exception(initResult.error ?? 'Falha ao inicializar BLE');
      }
      
      // Verifica se Bluetooth está disponível
      final availableResult = await _bleRepository.isBluetoothAvailable();
      if (!availableResult.isSuccess || availableResult.data != true) {
        throw Exception('Bluetooth não disponível');
      }
      
      // Verifica se Bluetooth está ligado
      final onResult = await _bleRepository.isBluetoothOn();
      if (!onResult.isSuccess || onResult.data != true) {
        throw Exception('Bluetooth está desligado. Por favor, ligue o Bluetooth.');
      }
      
      // Inicia o scan
      final scanResult = await _bleRepository.startScan(
        timeoutSeconds: params.timeoutSeconds,
        filterByName: params.filterByName,
      );
      
      if (!scanResult.isSuccess) {
        throw Exception(scanResult.error ?? 'Falha no scan');
      }
      
      final devices = scanResult.data ?? [];
      
      // Filtra dispositivos VisionFlow
      final visionFlowDevices = devices
          .where((device) => device.displayName.contains(BleConstants.esp32DeviceName))
          .toList();
      
      final hasVisionFlowDevice = visionFlowDevices.isNotEmpty;
      final visionFlowDevice = hasVisionFlowDevice 
          ? visionFlowDevices.firstWhere((d) => d.hasGoodSignal, orElse: () => visionFlowDevices.first)
          : null;
      
      log.ble('Scan concluído: ${devices.length} dispositivos encontrados');
      if (hasVisionFlowDevice) {
        log.success('VisionFlow-ESP32 encontrado! Sinal: ${visionFlowDevice!.signalStrength}');
      } else {
        log.warning('VisionFlow-ESP32 não encontrado');
      }
      
      return ScanDevicesResult(
        devices: devices,
        hasVisionFlowDevice: hasVisionFlowDevice,
        visionFlowDevice: visionFlowDevice,
      );
      
    } catch (e, stackTrace) {
      log.error('Erro no scan de dispositivos', e, stackTrace);
      rethrow;
    }
  }
}