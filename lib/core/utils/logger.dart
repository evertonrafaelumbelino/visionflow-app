library;

import 'package:logger/logger.dart';

/// Logger customizado para o VisionFlow
/// Facilita o debug com cores e níveis de log

class AppLogger {
  // Logger instance (singleton)
  static final AppLogger _instance = AppLogger._internal();
  
  // Logger do pacote
  late final Logger _logger;
  
  // Controle de debug (pode ser desativado em produção)
  static bool _isDebugMode = true;
  
  // Factory constructor
  factory AppLogger() {
    return _instance;
  }
  
  // Construtor privado
  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Número de métodos a mostrar no stack trace
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.none,
      ),
    );
  }
  
  /// Ativa/desativa modo debug
  static void setDebugMode(bool isDebug) {
    _isDebugMode = isDebug;
  }
  
  /// Log de informação (azul)
  void info(String message) {
    if (_isDebugMode) {
      _logger.i('ℹ️ $message');
    }
  }
  
  /// Log de sucesso (verde)
  void success(String message) {
    if (_isDebugMode) {
      _logger.i('✅ $message');
    }
  }
  
  /// Log de aviso (amarelo)
  void warning(String message) {
    if (_isDebugMode) {
      _logger.w('⚠️ $message');
    }
  }
  
  /// Log de erro (vermelho)
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isDebugMode) {
      _logger.e('❌ $message', error: error, stackTrace: stackTrace);
    }
  }
  
  /// Log de debug (cinza)
  void debug(String message) {
    if (_isDebugMode) {
      _logger.d('🐛 $message');
    }
  }
  
  /// Log de trace (muito detalhado)
  void trace(String message) {
    if (_isDebugMode) {
      _logger.t('🔍 $message');
    }
  }
  
  /// Log de evento BLE
  void ble(String message) {
    if (_isDebugMode) {
      _logger.i('📡 BLE: $message');
    }
  }
  
  /// Log de evento de câmera
  void camera(String message) {
    if (_isDebugMode) {
      _logger.i('📷 Camera: $message');
    }
  }
  
  /// Log de evento de IA
  void ai(String message) {
    if (_isDebugMode) {
      _logger.i('🤖 AI: $message');
    }
  }
  
  /// Log de evento de vídeo
  void video(String message) {
    if (_isDebugMode) {
      _logger.i('🎬 Video: $message');
    }
  }
  
  /// Log de evento de UI
  void ui(String message) {
    if (_isDebugMode) {
      _logger.i('🖼️ UI: $message');
    }
  }
}

// Atalho para facilitar o uso em outros arquivos
final log = AppLogger();