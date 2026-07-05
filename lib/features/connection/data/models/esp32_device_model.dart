library;

/// Modelo de dados para dispositivo ESP32
/// 
/// Esta classe é parte da camada de dados (Data Layer)
/// Responsável por converter dados brutos do BLE para a entidade de domínio

import '../../domain/entities/esp32_device.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Modelo de dados para descoberta e manipulação de dispositivos ESP32
class Esp32DeviceModel {
  final String id;
  final String name;
  final String? localName;
  final int rssi;
  final List<String>? serviceUuids;
  final DateTime discoveredAt;
  
  Esp32DeviceModel({
    required this.id,
    required this.name,
    this.localName,
    required this.rssi,
    this.serviceUuids,
    DateTime? discoveredAt,
  }) : discoveredAt = discoveredAt ?? DateTime.now();
  
  /// Cria um modelo a partir de um dispositivo BLE descoberto
  factory Esp32DeviceModel.fromScanResult(ScanResult scanResult) {
    return Esp32DeviceModel(
      id: scanResult.device.remoteId.str,
      name: scanResult.device.platformName,
      localName: scanResult.advertisementData.advName,
      rssi: scanResult.rssi,
      serviceUuids: scanResult.advertisementData.serviceUuids.map((uuid) => uuid.toString()).toList(),
    );
  }
  
  /// Cria um modelo a partir de um dispositivo BluetoothDevice
  factory Esp32DeviceModel.fromBluetoothDevice(BluetoothDevice device, int rssi) {
    return Esp32DeviceModel(
      id: device.remoteId.str,
      name: device.platformName,
      rssi: rssi,
    );
  }
  
  /// Converte o modelo para entidade de domínio
  Esp32Device toEntity() {
    return Esp32Device(
      id: id,
      name: name,
      localName: localName,
      rssi: rssi,
      isConnected: false,
      lastSeen: discoveredAt,
      serviceUuids: serviceUuids,
    );
  }
  
  /// Cria uma cópia do modelo com campos atualizados
  Esp32DeviceModel copyWith({
    String? id,
    String? name,
    String? localName,
    int? rssi,
    List<String>? serviceUuids,
    DateTime? discoveredAt,
  }) {
    return Esp32DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      localName: localName ?? this.localName,
      rssi: rssi ?? this.rssi,
      serviceUuids: serviceUuids ?? this.serviceUuids,
      discoveredAt: discoveredAt ?? this.discoveredAt,
    );
  }
  
  @override
  String toString() {
    return 'Esp32DeviceModel(id: $id, name: $name, rssi: $rssi)';
  }
}