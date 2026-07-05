library;

/// Constantes relacionadas ao Bluetooth Low Energy (BLE)
/// 
/// Estas constantes devem ser configuradas de acordo com o firmware do ESP32
/// Você precisará atualizar os UUIDs para corresponder aos definidos no código do ESP32

class BleConstants {
  // UUID do Serviço Principal do ESP32
  // Este UUID deve ser o mesmo definido no código C++ do ESP32
  static const String esp32ServiceUuid = '0000FFE0-0000-1000-8000-00805F9B34FB';
  
  // UUID da Característica de Escrita (App -> ESP32)
  // Usado para enviar dados do app para o ESP32
  static const String esp32WriteCharacteristicUuid = '0000FFE1-0000-1000-8000-00805F9B34FB';
  
  // UUID da Característica de Notificação (ESP32 -> App)
  // Usado para receber dados do ESP32 (se necessário)
  static const String esp32NotifyCharacteristicUuid = '0000FFE2-0000-1000-8000-00805F9B34FB';

  // Nome do dispositivo ESP32 que será procurado durante o scan
  // O ESP32 deve ter este nome definido no seu firmware
  static const String esp32DeviceName = 'VisionFlow-ESP32';
  
  // Timeout para scan de dispositivos BLE (em segundos)
  static const int scanTimeoutSeconds = 10;
  
  // Timeout para conexão BLE (em segundos)
  static const int connectionTimeoutSeconds = 15;
  
  // Intervalo de tentativa de reconexão (em segundos)
  static const int reconnectIntervalSeconds = 5;
  
  // Número máximo de tentativas de reconexão
  static const int maxReconnectAttempts = 3;

  // MTU (Maximum Transmission Unit) - tamanho máximo de pacote BLE
  // Valor padrão é 23 bytes, mas pode ser aumentado para até 512
  static const int bleMtuSize = 512;

  // Delay mínimo entre envios de dados BLE (em milissegundos)
  // Evita sobrecarregar o buffer BLE
  static const int minSendDelayMs = 100;
}