library;

/// Implementação concreta do repositório BLE
/// 
/// Esta é a camada de dados (Data Layer)
/// Usa o pacote flutter_blue_plus para comunicação BLE real

import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entities/esp32_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../models/esp32_device_model.dart';
import '../../../../core/constants/ble_constants.dart';
import '../../../../core/utils/logger.dart';

/// Implementação do repositório BLE usando flutter_blue_plus
class BleRepositoryImpl implements BleRepository {
  // Controladores de stream
  final _connectionStatusController = StreamController<BleConnectionStatus>.broadcast();
  final _discoveredDevicesController = StreamController<List<Esp32Device>>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  
  // Estado interno
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;
  bool _isScanning = false;
  Timer? _scanTimer;
  
  // Stream subscriptions
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  
  static final BleRepositoryImpl _instance = BleRepositoryImpl._internal();
  factory BleRepositoryImpl() => _instance;
  BleRepositoryImpl._internal();
  
  // ==================== STREAMS ====================
  
  @override
  Stream<BleConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;
  
  @override
  Stream<List<Esp32Device>> get discoveredDevicesStream => _discoveredDevicesController.stream;
  
  @override
  Stream<String> get errorStream => _errorController.stream;
  
  // ==================== MÉTODOS DE CONTROLE ====================
  
  @override
  Future<BleResult<bool>> initialize() async {
    try {
      log.ble('Inicializando adaptador BLE...');
      
      // Verifica se o dispositivo suporta BLE
      final isSupported = await FlutterBluePlus.isSupported;
      if (!isSupported) {
        return const BleResult.failure('Dispositivo não suporta Bluetooth Low Energy');
      }
      
      // Liga o Bluetooth se estiver desligado
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        log.ble('Bluetooth desligado. Solicitando ativação...');
        await FlutterBluePlus.turnOn();
        // Aguarda um pouco para o Bluetooth ligar
        await Future.delayed(const Duration(seconds: 2));
      }
      
      log.success('BLE inicializado com sucesso');
      return const BleResult.success(true);
      
    } catch (e, stackTrace) {
      log.error('Erro ao inicializar BLE', e, stackTrace);
      return BleResult.failure('Erro ao inicializar BLE: $e');
    }
  }
  
  @override
  Future<BleResult<bool>> isBluetoothAvailable() async {
    try {
      final isSupported = await FlutterBluePlus.isSupported;
      return BleResult.success(isSupported);
    } catch (e) {
      return BleResult.failure('Erro ao verificar disponibilidade: $e');
    }
  }
  
  @override
  Future<BleResult<bool>> isBluetoothOn() async {
    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      return BleResult.success(adapterState == BluetoothAdapterState.on);
    } catch (e) {
      return BleResult.failure('Erro ao verificar status do Bluetooth: $e');
    }
  }
  
  // ==================== SCAN E DESCOBERTA ====================
  
  @override
  Future<BleResult<List<Esp32Device>>> startScan({
    int timeoutSeconds = 10,
    bool filterByName = true,
  }) async {
    try {
      if (_isScanning) {
        return const BleResult.failure('Scan já está em andamento');
      }
      
      log.ble('Iniciando scan de dispositivos BLE...');
      _isScanning = true;
      _connectionStatusController.add(BleConnectionStatus.escaneando);
      
      final discoveredDevices = <Esp32Device>[];
      final deviceSet = <String, Esp32DeviceModel>{};
      
      // Escuta resultados do scan
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          final model = Esp32DeviceModel.fromScanResult(result);
          
          // Filtra por nome se solicitado
          if (filterByName && !model.name.contains(BleConstants.esp32DeviceName)) {
            continue;
          }
          
          // Atualiza ou adiciona dispositivo (mantém o com sinal mais forte)
          if (!deviceSet.containsKey(model.id) || 
              model.rssi > deviceSet[model.id]!.rssi) {
            deviceSet[model.id] = model;
            final entity = model.toEntity();
            discoveredDevices.removeWhere((d) => d.id == entity.id);
            discoveredDevices.add(entity);
          }
        }
        
        // Emite lista atualizada
        _discoveredDevicesController.add(List.from(discoveredDevices));
      }, onError: (error) {
        log.error('Erro no scan', error);
        _errorController.add('Erro no scan: $error');
      });
      
      // Inicia o scan
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: timeoutSeconds),
        androidUsesFineLocation: true,
      );
      
      log.ble('Scan iniciado. Aguardando ${timeoutSeconds}s...');
      
      // Aguarda o timeout
      await Future.delayed(Duration(seconds: timeoutSeconds));
      
      // Para o scan
      await stopScan();
      
      log.success('Scan concluído: ${discoveredDevices.length} dispositivos encontrados');
      return BleResult.success(discoveredDevices);
      
    } catch (e, stackTrace) {
      log.error('Erro no scan de dispositivos', e, stackTrace);
      await stopScan();
      return BleResult.failure('Erro no scan: $e');
    }
  }
  
  @override
  Future<BleResult<void>> stopScan() async {
    try {
      if (_isScanning) {
        await FlutterBluePlus.stopScan();
        await _scanSubscription?.cancel();
        _scanSubscription = null;
        _isScanning = false;
        _connectionStatusController.add(BleConnectionStatus.desconectado);
        log.ble('Scan parado');
      }
      return const BleResult.success(null);
    } catch (e) {
      return BleResult.failure('Erro ao parar scan: $e');
    }
  }
  
  // ==================== CONEXÃO ====================
  
  @override
  Future<BleResult<Esp32Device>> connect(Esp32Device device, {int timeoutSeconds = 15}) async {
    try {
      log.ble('Conectando a ${device.displayName}...');
      _connectionStatusController.add(BleConnectionStatus.conectando);
      
      // Cria objeto BluetoothDevice a partir do ID
      final bluetoothDevice = BluetoothDevice.fromId(device.id);
      
      // Escuta mudanças no estado da conexão
      _connectionSubscription = bluetoothDevice.connectionState.listen((state) {
        log.ble('Estado da conexão: $state');
        if (state == BluetoothConnectionState.connected) {
          _connectionStatusController.add(BleConnectionStatus.conectado);
        } else if (state == BluetoothConnectionState.disconnected) {
          _connectionStatusController.add(BleConnectionStatus.desconectado);
          _connectedDevice = null;
        }
      });
      
      // Conecta ao dispositivo
      await bluetoothDevice.connect(timeout: Duration(seconds: timeoutSeconds));
      
      // Aguarda conexão estabelecida
      await Future.delayed(const Duration(seconds: 2));
      
      // Descobre serviços
      log.ble('Descobrindo serviços...');
      final services = await bluetoothDevice.discoverServices();
      
      // Procura o serviço do ESP32
      BluetoothService? targetService;
      for (var service in services) {
        if (service.uuid.toString() == BleConstants.esp32ServiceUuid) {
          targetService = service;
          break;
        }
      }
      
      if (targetService == null) {
        await bluetoothDevice.disconnect();
        return BleResult.failure('Serviço ESP32 não encontrado');
      }
      
      log.success('Serviço encontrado: ${targetService.uuid}');
      
      // Procura características
      for (var characteristic in targetService.characteristics) {
        final uuid = characteristic.uuid.toString();
        
        if (uuid == BleConstants.esp32WriteCharacteristicUuid) {
          _writeCharacteristic = characteristic;
          log.ble('Característica de escrita encontrada');
        }
        
        if (uuid == BleConstants.esp32NotifyCharacteristicUuid) {
          _notifyCharacteristic = characteristic;
          log.ble('Característica de notificação encontrada');
        }
      }
      
      if (_writeCharacteristic == null) {
        await bluetoothDevice.disconnect();
        return BleResult.failure('Característica de escrita não encontrada');
      }
      
      // Atualiza dispositivo conectado
      _connectedDevice = bluetoothDevice;
      
      // Cria entidade atualizada
      final connectedDevice = device.copyWith(
        isConnected: true,
        lastSeen: DateTime.now(),
        writeCharacteristicUuid: _writeCharacteristic!.uuid.toString(),
        notifyCharacteristicUuid: _notifyCharacteristic?.uuid.toString(),
      );
      
      log.success('Conectado com sucesso a ${connectedDevice.displayName}');
      return BleResult.success(connectedDevice);
      
    } catch (e, stackTrace) {
      log.error('Erro na conexão', e, stackTrace);
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      _connectionStatusController.add(BleConnectionStatus.erro);
      return BleResult.failure('Erro na conexão: $e');
    }
  }
  
  @override
  Future<BleResult<void>> disconnect() async {
    try {
      log.ble('Desconectando...');
      _connectionStatusController.add(BleConnectionStatus.desconectando);
      
      await _connectedDevice?.disconnect();
      await _scanSubscription?.cancel();
      
      _connectedDevice = null;
      _writeCharacteristic = null;
      _notifyCharacteristic = null;
      _scanSubscription = null;
      _connectionSubscription = null;
      
      _connectionStatusController.add(BleConnectionStatus.desconectado);
      log.success('Desconectado com sucesso');
      
      return const BleResult.success(null);
    } catch (e) {
      return BleResult.failure('Erro ao desconectar: $e');
    }
  }
  
  @override
  Future<BleResult<Esp32Device>> reconnect() async {
    // TODO: Implementar reconexão automática
    return const BleResult.failure('Reconexão não implementada ainda');
  }
  
  // ==================== COMUNICAÇÃO ====================
  
  @override
  Future<BleResult<bool>> sendData(String data) async {
    try {
      if (_writeCharacteristic == null) {
        return const BleResult.failure('Característica de escrita não disponível');
      }
      
      log.ble('Enviando dados: "$data"');
      
      // Converte string para bytes
      final bytes = utf8.encode(data);
      
      // Escreve na característica
      await _writeCharacteristic!.write(bytes);
      
      log.success('Dados enviados: ${bytes.length} bytes');
      return const BleResult.success(true);
      
    } catch (e, stackTrace) {
      log.error('Erro ao enviar dados', e, stackTrace);
      return BleResult.failure('Erro ao enviar dados: $e');
    }
  }
  
  @override
  Future<BleResult<bool>> sendBytes(List<int> bytes) async {
    try {
      if (_writeCharacteristic == null) {
        return const BleResult.failure('Característica de escrita não disponível');
      }
      
      log.ble('Enviando ${bytes.length} bytes');
      
      await _writeCharacteristic!.write(bytes);
      
      log.success('Bytes enviados: ${bytes.length} bytes');
      return const BleResult.success(true);
      
    } catch (e, stackTrace) {
      log.error('Erro ao enviar bytes', e, stackTrace);
      return BleResult.failure('Erro ao enviar bytes: $e');
    }
  }
  
  @override
  Future<BleResult<int>> requestMtu(int mtuSize) async {
    try {
      if (_connectedDevice == null) {
        return const BleResult.failure('Dispositivo não conectado');
      }
      
      log.ble('Solicitando MTU de $mtuSize bytes...');
      
      // Solicita aumento de MTU
      final mtu = await _connectedDevice!.requestMtu(mtuSize);
      
      log.success('MTU definido para $mtu bytes');
      return BleResult.success(mtu);
      
    } catch (e, stackTrace) {
      log.error('Erro ao solicitar MTU', e, stackTrace);
      return BleResult.failure('Erro ao solicitar MTU: $e');
    }
  }
  
  // ==================== STATUS E INFORMAÇÕES ====================
  
  @override
  Future<Esp32Device?> getConnectedDevice() async {
    if (_connectedDevice == null) return null;
    
    return Esp32Device(
      id: _connectedDevice!.remoteId.str,
      name: _connectedDevice!.platformName,
      rssi: 0, // TODO: Obter RSSI atual
      isConnected: true,
      lastSeen: DateTime.now(),
      writeCharacteristicUuid: _writeCharacteristic?.uuid.toString(),
      notifyCharacteristicUuid: _notifyCharacteristic?.uuid.toString(),
    );
  }
  
  @override
  Future<BleConnectionStatus> getConnectionStatus() async {
    if (_connectedDevice == null) return BleConnectionStatus.desconectado;
    
    final state = await _connectedDevice!.connectionState.first;
    switch (state) {
      case BluetoothConnectionState.connected:
        return BleConnectionStatus.conectado;
      case BluetoothConnectionState.disconnected:
        return BleConnectionStatus.desconectado;
      default:
        return BleConnectionStatus.desconectado;
    }
  }
  
  @override
  Future<bool> isConnected() async {
    if (_connectedDevice == null) return false;
    
    final state = await _connectedDevice!.connectionState.first;
    return state == BluetoothConnectionState.connected;
  }
  
  // ==================== LIMPEZA ====================
  
  @override
  Future<void> dispose() async {
    log.ble('Liberando recursos BLE...');
    
    await _scanSubscription?.cancel();
    await _connectionSubscription?.cancel();
    await _connectedDevice?.disconnect();
    
    await _connectionStatusController.close();
    await _discoveredDevicesController.close();
    await _errorController.close();
    
    _scanTimer?.cancel();
    
    log.success('Recursos BLE liberados');
  }
}