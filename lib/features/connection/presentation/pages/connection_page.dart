library;

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
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
/// Interface moderna e acessível seguindo o design system VisionFlow
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
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Conectado a ${connectedDevice.displayName}!',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          'VisionFlow',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textOnPrimary,
                    minimumSize: const Size(
                      double.infinity,
                      56,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDecorations.buttonBorderRadius),
                    ),
                  ),
                  child: _isScanning
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.textOnPrimary,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'BUSCAR ÓCULOS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ] else ...[
                // Botão de desconexão
                ElevatedButton(
                  onPressed: _disconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    foregroundColor: AppColors.textOnPrimary,
                    minimumSize: const Size(
                      double.infinity,
                      56,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDecorations.buttonBorderRadius),
                    ),
                  ),
                  child: const Text(
                    'DESCONECTAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
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
                    color: AppColors.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.errorColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.errorColor,
                        size: 24,
                      ),
                      const SizedBox(width: AppTheme.paddingMedium),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    letterSpacing: 0.5,
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
                  padding: const EdgeInsets.all(AppTheme.paddingXLarge),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_searching_rounded,
                        size: 64,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      Text(
                        'Nenhum dispositivo encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
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