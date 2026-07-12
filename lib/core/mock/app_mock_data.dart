import 'package:flutter/material.dart';
import 'package:visionflow_app/core/constants/app_constants.dart';

/// Período de filtro para estatísticas
enum ActivityPeriod { hoje, semana, mes }

/// Segmento do gráfico de rosca
class FunctionUsageSegment {
  const FunctionUsageSegment({
    required this.label,
    required this.percentage,
    required this.color,
  });

  final String label;
  final double percentage;
  final Color color;
}

/// Dados de estatísticas por período
class ActivityStats {
  const ActivityStats({
    required this.usageTime,
    required this.usageTrend,
    required this.translations,
    required this.translationsTrend,
    required this.photos,
    required this.photosTrend,
    required this.chartPoints,
    required this.functionUsage,
  });

  final String usageTime;
  final String usageTrend;
  final int translations;
  final String translationsTrend;
  final int photos;
  final String photosTrend;
  final List<double> chartPoints;
  final List<FunctionUsageSegment> functionUsage;
}

/// Dados mock centralizados do app
class AppMockData {
  AppMockData._();

  static const String userName = 'usuário';
  static const String displayUserName = 'Usuário VisionFlow';
  static const String deviceName = 'VisionFlow Pro';
  static const String firmwareVersion = '1.2.4';
  static const String batteryLevel = '100%';
  static const String appDescription =
      'Óculos assistivo inteligente para pessoas com deficiência visual.';

  static const List<Map<String, dynamic>> quickActions = [
    {'label': 'Câmera', 'icon': Icons.camera_alt_outlined},
    {'label': 'Tradução', 'icon': Icons.translate_outlined},
    {'label': 'Navegação', 'icon': Icons.navigation_outlined},
    {'label': 'Áudio', 'icon': Icons.headphones_outlined},
    {'label': 'Notificações', 'icon': Icons.notifications_outlined},
    {'label': 'Configurações', 'icon': Icons.settings_outlined},
  ];

  static const Map<ActivityPeriod, ActivityStats> activityStats = {
    ActivityPeriod.hoje: ActivityStats(
      usageTime: '3h 45m',
      usageTrend: '+12% que ontem',
      translations: 28,
      translationsTrend: '+8%',
      photos: 56,
      photosTrend: '+14%',
      chartPoints: [2.0, 2.5, 2.2, 3.0, 2.8, 3.5, 3.75],
      functionUsage: [
        FunctionUsageSegment(
          label: 'Câmera',
          percentage: 40,
          color: Color(0xFF6FA8DC),
        ),
        FunctionUsageSegment(
          label: 'Tradução',
          percentage: 25,
          color: Color(0xFF4F7D8C),
        ),
        FunctionUsageSegment(
          label: 'Navegação',
          percentage: 20,
          color: Color(0xFFA8C9E6),
        ),
        FunctionUsageSegment(
          label: 'Áudio',
          percentage: 15,
          color: Color(0xFF7BCFA4),
        ),
      ],
    ),
    ActivityPeriod.semana: ActivityStats(
      usageTime: '18h 20m',
      usageTrend: '+5% que semana passada',
      translations: 142,
      translationsTrend: '+12%',
      photos: 310,
      photosTrend: '+9%',
      chartPoints: [2.0, 2.8, 3.1, 2.5, 3.4, 3.0, 3.2],
      functionUsage: [
        FunctionUsageSegment(
          label: 'Câmera',
          percentage: 35,
          color: Color(0xFF6FA8DC),
        ),
        FunctionUsageSegment(
          label: 'Tradução',
          percentage: 30,
          color: Color(0xFF4F7D8C),
        ),
        FunctionUsageSegment(
          label: 'Navegação',
          percentage: 22,
          color: Color(0xFFA8C9E6),
        ),
        FunctionUsageSegment(
          label: 'Áudio',
          percentage: 13,
          color: Color(0xFF7BCFA4),
        ),
      ],
    ),
    ActivityPeriod.mes: ActivityStats(
      usageTime: '72h 10m',
      usageTrend: '+18% que mês passado',
      translations: 580,
      translationsTrend: '+15%',
      photos: 1240,
      photosTrend: '+20%',
      chartPoints: [2.5, 3.0, 3.2, 3.5, 3.8, 4.0, 4.2],
      functionUsage: [
        FunctionUsageSegment(
          label: 'Câmera',
          percentage: 38,
          color: Color(0xFF6FA8DC),
        ),
        FunctionUsageSegment(
          label: 'Tradução',
          percentage: 28,
          color: Color(0xFF4F7D8C),
        ),
        FunctionUsageSegment(
          label: 'Navegação',
          percentage: 19,
          color: Color(0xFFA8C9E6),
        ),
        FunctionUsageSegment(
          label: 'Áudio',
          percentage: 15,
          color: Color(0xFF7BCFA4),
        ),
      ],
    ),
  };

  static String get versionLabel => 'v${AppConstants.appVersion}';
}
