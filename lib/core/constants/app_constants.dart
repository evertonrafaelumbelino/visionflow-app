library;

/// Constantes gerais do aplicativo VisionFlow

class AppConstants {
  // Nome do aplicativo
  static const String appName = 'VisionFlow';
  static const String appVersion = '1.0.0';
  
  // Configurações de timeout
  static const int connectionTimeoutMs = 15000; // 15 segundos
  static const int scanTimeoutMs = 10000; // 10 segundos
  static const int operationRetryDelayMs = 2000; // 2 segundos
  
  // Configurações de vídeo
  static const int videoStreamPort = 80;
  static const String videoStreamPath = '/stream';
  static const int videoFrameWidth = 640;
  static const int videoFrameHeight = 640;
  
  // Configurações de IA
  static const String yoloModelPath = 'assets/models/yolov8n.tflite';
  static const int modelInputSize = 640;
  static const double confidenceThreshold = 0.5; // 50% de confiança mínima
  
  // Configurações de cooldown (filtro de repetição)
  static const int cooldownDurationMs = 5000; // 5 segundos
  static const int maxCooldownEntries = 50; // Máximo de objetos no histórico
  
  // Labels suportadas pelo modelo YOLOv8 (COCO dataset)
  static const List<String> supportedLabels = [
    'pessoa',
    'bicicleta',
    'carro',
    'moto',
    'avião',
    'ônibus',
    'trem',
    'caminhão',
    'barco',
    'semáforo',
    'hidrante',
    'placa de pare',
    'parquímetro',
    'banco',
    'pássaro',
    'gato',
    'cachorro',
    'cavalo',
    'ovelha',
    'vaca',
    'elefante',
    'urso',
    'zebra',
    'girafa',
    'mochila',
    'guarda-chuva',
    'bolsa',
    'gravata',
    'mala',
    'frisbee',
    'esquis',
    'snowboard',
    'bola de esportes',
    'pipa',
    'taco de beisebol',
    'luva de beisebol',
    'skate',
    'prancha de surfe',
    'raquete de tênis',
    'garrafa',
    'copo de vinho',
    'taça',
    'garfo',
    'faca',
    'colher',
    'tigela',
    'banana',
    'maçã',
    'sanduíche',
    'laranja',
    'brócolis',
    'cenoura',
    'cachorro-quente',
    'pizza',
    'donut',
    'bolo',
    'cadeira',
    'sofá',
    'planta em vaso',
    'cama',
    'mesa de jantar',
    'vaso sanitário',
    'televisão',
    'laptop',
    'mouse',
    'controle remoto',
    'teclado',
    'celular',
    'micro-ondas',
    'forno',
    'torradeira',
    'pia',
    'geladeira',
    'livro',
    'relógio',
    'vaso',
    'tesoura',
    'ursinho de pelúcia',
    'secador de cabelo',
    'escova de dentes',
  ];
  
  // Labels prioritários (obstáculos mais críticos para navegação)
  static const List<String> priorityLabels = [
    'pessoa',
    'carro',
    'caminhão',
    'ônibus',
    'moto',
    'bicicleta',
    'degrau',
    'obstáculo',
  ];
  
  // Mensagens de voz (para futura implementação com TTS)
  static const String messagePerson = 'Pessoa à frente';
  static const String messageCar = 'Carro se aproximando';
  static const String messageTruck = 'Caminhão à frente';
  static const String messageBus = 'Ônibus se aproximando';
  static const String messageBike = 'Bicicleta à frente';
  static const String messageObstacle = 'Obstáculo à frente';
  static const String messageUnknown = 'Objeto detectado';
}