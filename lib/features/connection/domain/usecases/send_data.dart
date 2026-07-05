library;

/// Use Case: Enviar dados para o ESP32
/// 
/// Responsável por transmitir dados via BLE para o ESP32

import '../repositories/ble_repository.dart';
import '../../../../core/utils/logger.dart';

/// Parâmetros para envio de dados
class SendDataParams {
  final String data;
  final bool waitForAcknowledgment;
  
  const SendDataParams({
    required this.data,
    this.waitForAcknowledgment = false,
  });
}

/// Use Case para enviar dados para o ESP32 via BLE
/// 
/// Encapsula a lógica de negócio para envio de dados
class SendData {
  final BleRepository _bleRepository;
  
  SendData(this._bleRepository);
  
  /// Executa o envio de dados para o ESP32
  Future<bool> call(SendDataParams params) async {
    try {
      // Verifica se está conectado
      final isConnected = await _bleRepository.isConnected();
      if (!isConnected) {
        throw Exception('Não há conexão BLE ativa');
      }
      
      log.ble('Enviando dados: "${params.data}"');
      
      // Envia os dados
      final result = await _bleRepository.sendData(params.data);
      
      if (!result.isSuccess) {
        throw Exception(result.error ?? 'Falha no envio de dados');
      }
      
      log.success('Dados enviados com sucesso: "${params.data}"');
      
      // Aguarda acknowledgment se necessário
      if (params.waitForAcknowledgment) {
        log.ble('Aguardando confirmação do ESP32...');
        // TODO: Implementar espera por notificação do ESP32
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      return true;
      
    } catch (e, stackTrace) {
      log.error('Erro ao enviar dados', e, stackTrace);
      rethrow;
    }
  }
  
  /// Envia uma string simplificada (comando de objeto detectado)
  /// 
  /// Método auxiliar para enviar labels de objetos detectados
  Future<bool> sendObjectDetection(String objectLabel) async {
    // Formato simples: apenas o nome do objeto
    // O ESP32 deve estar preparado para receber este formato
    return call(SendDataParams(data: objectLabel));
  }
  
  /// Envia múltiplos objetos detectados
  /// 
  /// Formato: "objeto1,objeto2,objeto3"
  Future<bool> sendMultipleObjects(List<String> objectLabels) async {
    final data = objectLabels.join(',');
    return call(SendDataParams(data: data));
  }
}