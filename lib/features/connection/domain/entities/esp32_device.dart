library;

/// Entidade que representa um dispositivo ESP32 descoberto
/// 
/// Esta classe é parte da camada de domínio (Domain Layer)
/// Ela representa o conceito de "dispositivo ESP32" na regra de negócio

class Esp32Device {
  final String id;
  final String name;
  final String? localName;
  final int rssi; // Força do sinal (Received Signal Strength Indicator)
  final bool isConnected;
  final DateTime? lastSeen;
  
  // Serviços e características (preenchidos após conexão)
  final List<String>? serviceUuids;
  final String? writeCharacteristicUuid;
  final String? notifyCharacteristicUuid;
  
  Esp32Device({
    required this.id,
    required this.name,
    this.localName,
    required this.rssi,
    this.isConnected = false,
    this.lastSeen,
    this.serviceUuids,
    this.writeCharacteristicUuid,
    this.notifyCharacteristicUuid,
  });
  
  /// Cria uma cópia do dispositivo com campos atualizados
  Esp32Device copyWith({
    String? id,
    String? name,
    String? localName,
    int? rssi,
    bool? isConnected,
    DateTime? lastSeen,
    List<String>? serviceUuids,
    String? writeCharacteristicUuid,
    String? notifyCharacteristicUuid,
  }) {
    return Esp32Device(
      id: id ?? this.id,
      name: name ?? this.name,
      localName: localName ?? this.localName,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      lastSeen: lastSeen ?? this.lastSeen,
      serviceUuids: serviceUuids ?? this.serviceUuids,
      writeCharacteristicUuid: writeCharacteristicUuid ?? this.writeCharacteristicUuid,
      notifyCharacteristicUuid: notifyCharacteristicUuid ?? this.notifyCharacteristicUuid,
    );
  }
  
  /// Retorna a força do sinal em formato amigável
  String get signalStrength {
    if (rssi >= -50) return 'Excelente';
    if (rssi >= -60) return 'Muito boa';
    if (rssi >= -70) return 'Boa';
    if (rssi >= -80) return 'Regular';
    return 'Fraca';
  }
  
  /// Retorna true se o sinal for aceitável para conexão estável
  bool get hasGoodSignal => rssi >= -70;
  
  /// Retorna o nome de exibição (localName se disponível, senão name)
  String get displayName => localName ?? name;
  
  @override
  String toString() {
    return 'Esp32Device(id: $id, name: $displayName, rssi: $rssi, connected: $isConnected)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Esp32Device && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}