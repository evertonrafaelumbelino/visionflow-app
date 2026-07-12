import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../core/mock/app_mock_data.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  ActivityPeriod _selectedPeriod = ActivityPeriod.hoje;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = AppMockData.activityStats[_selectedPeriod]!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          'Atividades',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today_rounded, color: isDark ? Colors.white : AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seletor de Período (Chips / Abas)
            Container(
              height: 52,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: ActivityPeriod.values.map((period) {
                  final isSelected = _selectedPeriod == period;
                  final label = period == ActivityPeriod.hoje
                      ? 'Hoje'
                      : period == ActivityPeriod.semana
                          ? 'Semana'
                          : 'Mês';
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.primaryColor : AppColors.iconColor)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 20),

            // Card Tempo de Uso (Spline chart de fl_chart)
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tempo de uso',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stats.usageTime,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stats.usageTrend,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spline Line Chart
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 80,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 6,
                          minY: 1,
                          maxY: 5,
                          lineBarsData: [
                            LineChartBarData(
                              spots: stats.chartPoints
                                  .asMap()
                                  .entries
                                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                                  .toList(),
                              isCurved: true,
                              color: AppColors.primaryColor,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 16),

            // Grade de Duas Métricas (Traduções e Fotos tiradas)
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: AppDecorations.softCard(
                      isDark: isDark,
                      color: isDark ? AppColors.darkSurface : Colors.white,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traduções',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stats.translations.toString(),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stats.translationsTrend,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: AppDecorations.softCard(
                      isDark: isDark,
                      color: isDark ? AppColors.darkSurface : Colors.white,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fotos tiradas',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stats.photos.toString(),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stats.photosTrend,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 16),

            // Card Uso por Função (Donut Chart)
            Container(
              decoration: AppDecorations.softCard(
                isDark: isDark,
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uso por função',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Donut Pie Chart
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 36,
                            startDegreeOffset: -90,
                            sections: stats.functionUsage.map((usage) {
                              return PieChartSectionData(
                                color: usage.color,
                                value: usage.percentage,
                                title: '${usage.percentage.toInt()}%',
                                radius: 20,
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Legenda das Funções
                      Expanded(
                        child: Column(
                          children: stats.functionUsage.map((usage) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: usage.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    usage.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white70 : AppColors.textPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${usage.percentage.toInt()}%',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fade(duration: 600.ms, delay: 150.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Dica de Uso Acessível
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : AppColors.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                    size: 26,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Dica\nExplore todos os recursos do seu VisionFlow para uma melhor experiência!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
