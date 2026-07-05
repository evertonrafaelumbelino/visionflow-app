library;

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/ble_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/esp32_device.dart';
import '../../domain/usecases/scan_devices.dart';
import '../../domain/usecases/connect_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../../data/repositories/ble_repository_impl.dart';
import '../widgets/device_card.dart';
import '../widgets/connection_status.dart';

/// Tela de conexão BLE com o ESP32
/// 
/// Esta é a tela principal do Milestone 1
/// Interface de alto contraste para acessibilidade
/// Permite escanear e conectar ao VisionFlow-ESP32

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});
  
  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  // Repositório BLE
  late final BleRepository _bleRepository;
  
  // Use cases
  late final ScanDevices _scanDevices;
  late final ConnectDevice _connectDevice;
  
  // Estado da UI
  BleConnectionStatus _connectionStatus = BleConnectionStatus.desconectado;
  List<Esp32Device> _discoveredDevices = [];
  Esp32Device? _connectedDevice;
  String? _errorMessage;
  bool _isScanning = false;
  
  // Stream subscriptions
  StreamSubscription<BleConnectionStatus>? _connectionStatusSubscription;
  StreamSubscription<List<Esp32Device>>? _devicesSubscription;
  StreamSubscription<String>? _errorSubscription;
  
  @override
  void initState() {
    super.initState();
    _initializeBle();
  }
  
  @override
  void dispose() {
    _connectionStatusSubscription?.cancel();
    _devicesSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }
  
  /// Inicializa o repositório BLE e use cases
  Future<void> _initializeBle() async {
    try {
      // TODO: Usar injeção de dependência (get_it) no futuro
      // Por enquanto, criamos a implementação diretamente
      _bleRepository = BleRepositoryImpl();
      _scanDevices = ScanDevices(_bleRepository);
      _connectDevice = ConnectDevice(_bleRepository);
      
      // Escuta mudanças no status da conexão
      _connectionStatusSubscription = _bleRepository.connectionStatusStream.listen((status) {
        setState(() {
          _connectionStatus = status;
        });
        log.ble('Status da conexão alterado: $status');
      });
      
      // Escuta dispositivos descobertos
      _devicesSubscription = _bleRepository.discoveredDevicesStream.listen((devices) {
        setState(() {
          _discoveredDevices = devices;
        });
        log.ble('Dispositivos descobertos: ${devices.length}');
      });
      
      // Escuta erros
      _errorSubscription = _bleRepository.errorStream.listen((error) {
        setState(() {
          _errorMessage = error;
        });
        log.error('Erro BLE: $error');
      });
      
      // Inicializa BLE
      final initResult = await _bleRepository.initialize();
      if (initResult.isSuccess) {
        log.success('BLE inicializado com sucesso');
      } else {
        log.error('Falha ao inicializar BLE: ${initResult.error}');
        setState(() {
          _errorMessage = initResult.error;
        });
      }
      
    } catch (e, stackTrace) {
      log.error('Erro na inicialização', e, stackTrace);
      setState(() {
        _errorMessage = 'Erro na inicialização: $e';
      });
    }
  }
  
  /// Inicia o scan de dispositivos
  Future<void> _startScan() async {
    try {
      setState(() {
        _isScanning = true;
        _errorMessage = null;
        _discoveredDevices = [];
      });
      
      log.ui('Iniciando scan de dispositivos...');
      
      final result = await _scanDevices(const ScanDevicesParams(
        timeoutSeconds: BleConstants.scanTimeoutSeconds,
        filterByName: true,
      ));
      
      setState(() {
        _isScanning = false;
      });
      
      if (result.hasVisionFlowDevice && result.visionFlowDevice != null) {
        log.success('VisionFlow-ESP32 encontrado!');
        // Auto-conecta se encontrou o dispositivo
        _connectToDevice(result.visionFlowDevice!);
      } else {
        log.warning('VisionFlow-ESP32 não encontrado');
        setState(() {
          _errorMessage = 'VisionFlow-ESP32 não encontrado. Verifique se o dispositivo está ligado.';
        });
      }
      
    } catch (e, stackTrace) {
      log.error('Erro no scan', e, stackTrace);
      setState(() {
        _isScanning = false;
        _errorMessage = 'Erro no scan: $e';
      });
    }
  }
  
  /// Conecta a um dispositivo específico
  Future<void> _connectToDevice(Esp32Device device) async {
    try {
      setState(() {
        _errorMessage = null;
      });
      
      log.ui('Conectando a ${device.displayName}...');
      
      final connectedDevice = await _connectDevice(ConnectDeviceParams(
        device: device,
        timeoutSeconds: BleConstants.connectionTimeoutSeconds,
      ));
      
      setState(() {
        _connectedDevice = connectedDevice;
      });
      
      log.success('Conectado com sucesso!');
      
      // Mostra mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Conectado a ${connectedDevice.displayName}!',
              style: const TextStyle(fontSize: 18),
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      
    } catch (e, stackTrace) {
      log.error('Erro na conexão', e, stackTrace);
      setState(() {
        _errorMessage = 'Erro na conexão: $e';
      });
    }
  }
  
  /// Desconecta do dispositivo atual
  Future<void> _disconnect() async {
    try {
      log.ui('Desconectando...');
      
      await _bleRepository.disconnect();
      
      setState(() {
        _connectedDevice = null;
        _errorMessage = null;
      });
      
      log.success('Desconectado com sucesso');
      
    } catch (e, stackTrace) {
      log.error('Erro ao desconectar', e, stackTrace);
      setState(() {
        _errorMessage = 'Erro ao desconectar: $e';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    log.ui('Building ConnectionPage');
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'VisionFlow',
          style: TextStyle(
            fontSize: AppTheme.fontSizeXLarge,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 4,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status da conexão
              ConnectionStatus(
                status: _connectionStatus,
                deviceName: _connectedDevice?.displayName,
                onRetry: _startScan,
              ),
              
              const SizedBox(height: AppTheme.paddingLarge),
              
              // Botão principal de scan/conexão
              if (_connectedDevice == null) ...[
                ElevatedButton(
                  onPressed: _isScanning ? null : _startScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    foregroundColor: AppTheme.textOnPrimary,
                    minimumSize: const Size(
                      double.infinity,
                      AppTheme.buttonMinHeight,
                    ),
                  ),
                  child: _isScanning
                      ? const SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator(
                            color: AppTheme.textOnPrimary,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'BUSCAR ÓCULOS',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ] else ...[
                // Botão de desconexão
                ElevatedButton(
                  onPressed: _disconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: AppTheme.textOnPrimary,
                    minimumSize: const Size(
                      double.infinity,
                      AppTheme.buttonMinHeight,
                    ),
                  ),
                  child: const Text(
                    'DESCONECTAR',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: AppTheme.paddingLarge),
              
              // Mensagem de erro
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.errorColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.errorColor,
                        size: 32,
                      ),
                      const SizedBox(width: AppTheme.paddingMedium),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: AppTheme.paddingLarge),
              
              // Lista de dispositivos descobertos
              if (_discoveredDevices.isNotEmpty) ...[
                Text(
                  'DISPOSITIVOS ENCONTRADOS (${_discoveredDevices.length})',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                ..._discoveredDevices.map((device) => DeviceCard(
                      device: device,
                      isSelected: _connectedDevice?.id == device.id,
                      onConnect: () => _connectToDevice(device),
                    )),
              ] else if (!_isScanning && _connectionStatus != BleConnectionStatus.escaneando) ...[
                // Estado vazio
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.textSecondary, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_searching,
                        size: 64,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      Text(
                        'Nenhum dispositivo encontrado',
                        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}