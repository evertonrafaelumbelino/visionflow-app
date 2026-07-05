library;

/// Interface do repositório de Bluetooth Low Energy (BLE)
/// 
/// Esta é a camada de domínio (Domain Layer) - define CONTRATOS
/// A implementação concreta estará na camada de dados (Data Layer)

import '../entities/esp32_device.dart';

/// Status de conexão BLE
enum BleConnectionStatus {
  desconectado,
  escaneando,
  conectando,
  conectado,
  erro,
  desconectando,
}

/// Resultado de operações BLE
class BleResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  const BleResult.success(this.data) 
      : error = null, 
        isSuccess = true;
  
  const BleResult.failure(this.error) 
      : data = null, 
        isSuccess = false;
  
  @override
  String toString() {
    if (isSuccess) {
      return 'BleResult.success(data: $data)';
    } else {
      return 'BleResult.failure(error: $error)';
    }
  }
}

/// Interface abstrata do repositório BLE
/// 
/// Define todos os métodos que o repositório DEVE implementar
/// Segue o princípio de inversão de dependência (DIP)
abstract class BleRepository {
  // ==================== STREAM DE STATUS ====================
  
  /// Stream que emite o status atual da conexão BLE
  Stream<BleConnectionStatus> get connectionStatusStream;
  
  /// Stream que emite dispositivos descobertos durante o scan
  Stream<List<Esp32Device>> get discoveredDevicesStream;
  
  /// Stream que emite erros ocorridos durante operações BLE
  Stream<String> get errorStream;
  
  // ==================== MÉTODOS DE CONTROLE ====================
  
  /// Inicializa o adaptador BLE
  /// Deve ser chamado antes de qualquer operação BLE
  Future<BleResult<bool>> initialize();
  
  /// Verifica se o Bluetooth está disponível e ligado
  Future<BleResult<bool>> isBluetoothAvailable();
  
  /// Verifica se o Bluetooth está ligado
  Future<BleResult<bool>> isBluetoothOn();
  
  // ==================== SCAN E DESCOBERTA ====================
  
  /// Inicia o scan de dispositivos BLE
  /// 
  /// [timeoutSeconds] - tempo máximo de scan em segundos
  /// Retorna lista de dispositivos encontrados
  Future<BleResult<List<Esp32Device>>> startScan({
    int timeoutSeconds = 10,
    bool filterByName = true,
  });
  
  /// Para o scan de dispositivos
  Future<BleResult<void>> stopScan();
  
  // ==================== CONEXÃO ====================
  
  /// Conecta a um dispositivo ESP32 específico
  /// 
  /// [device] - dispositivo ESP32 para conectar
  /// [timeoutSeconds] - tempo máximo para conexão
  Future<BleResult<Esp32Device>> connect(Esp32Device device, {int timeoutSeconds = 15});
  
  /// Desconecta do dispositivo atual
  Future<BleResult<void>> disconnect();
  
  /// Reconecta ao último dispositivo conectado
  Future<BleResult<Esp32Device>> reconnect();
  
  // ==================== COMUNICAÇÃO ====================
  
  /// Envia dados para o ESP32 via BLE
  /// 
  /// [data] - dados a serem enviados (string ou bytes)
  /// Retorna true se enviado com sucesso
  Future<BleResult<bool>> sendData(String data);
  
  /// Envia dados binários para o ESP32 via BLE
  /// 
  /// [bytes] - dados binários a serem enviados
  Future<BleResult<bool>> sendBytes(List<int> bytes);
  
  /// Solicita aumento de MTU (Maximum Transmission Unit)
  /// Aumenta o tamanho máximo de pacote para transferências mais rápidas
  Future<BleResult<int>> requestMtu(int mtuSize);
  
  // ==================== STATUS E INFORMAÇÕES ====================
  
  /// Retorna o dispositivo atualmente conectado (ou null)
  Future<Esp32Device?> getConnectedDevice();
  
  /// Retorna o status atual da conexão
  Future<BleConnectionStatus> getConnectionStatus();
  
  /// Verifica se está conectado a algum dispositivo
  Future<bool> isConnected();
  
  // ==================== LIMPEZA ====================
  
  /// Libera todos os recursos BLE
  /// Deve ser chamado quando o app for fechado
  Future<void> dispose();
}