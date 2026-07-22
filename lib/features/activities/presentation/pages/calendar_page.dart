import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentMonthIndex = 6; // Julho

  static const List<String> _months = [
    'JANEIRO 2026',
    'FEVEREIRO 2026',
    'MARÇO 2026',
    'ABRIL 2026',
    'MAIO 2026',
    'JUNHO 2026',
    'JULHO 2026',
    'AGOSTO 2026',
    'SETEMBRO 2026',
    'OUTUBRO 2026',
    'NOVEMBRO 2026',
    'DEZEMBRO 2026',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.cyanAccent, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'HISTÓRICO MENSAL',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 22),
              onPressed: () {},
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(text: 'Calêndro'),
            Tab(text: 'Calendário'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Seletor de Mês ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, color: Colors.white70, size: 28),
                  onPressed: () {
                    if (_currentMonthIndex > 0) {
                      setState(() => _currentMonthIndex--);
                    }
                  },
                ),
                Text(
                  _months[_currentMonthIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 28),
                  onPressed: () {
                    if (_currentMonthIndex < _months.length - 1) {
                      setState(() => _currentMonthIndex++);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Grade do Calendário ──
            _buildCalendarGrid(),

            const SizedBox(height: 16),

            // ── Legenda de Uso ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(const Color(0xFFE53935), 'Uso Intenso'),
                _buildLegendItem(const Color(0xFF1E88E5), 'Uso Moderado'),
                _buildLegendItem(Colors.white, 'Sem Registro de Uso'),
              ],
            ),

            const SizedBox(height: 24),

            // ── RESUMO DE JULHO ──
            const Text(
              'RESUMO DE JULHO',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFF1C2733),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tempo Total de Uso:',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '62h 45m',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+15% que Junho',
                          style: TextStyle(
                            color: AppColors.successColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFF1C2733),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Média Diária:',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '2h 15m',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '▲ 8% em relação à semana passada',
                          style: TextStyle(
                            color: AppColors.successColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // ── MAIOR USO DO MÊS ──
            const Text(
              'MAIOR USO DO MÊS',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFF1C2733),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Sábado, dia 13',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '5h 12m',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    const daysOfWeek = ['LUN', 'DAB', 'MAR', 'JUR', 'VEN', 'SÁB', 'SÁB'];

    // Simulação de status dos dias de Julho 2026
    // 0: Sem Uso, 1: Uso Moderado, 2: Uso Intenso, 3: Dia Atual
    final Map<int, int> dayStatus = {
      2: 2, 3: 2, 4: 0, 5: 0, 6: 0,
      7: 2, 8: 1, 9: 1, 10: 1, 11: 1, 12: 1, 13: 0,
      14: 0, 15: 0, 16: 0, 17: 0, 18: 0, 19: 0, 20: 3,
      21: 0, 22: 1, 23: 1, 24: 0, 25: 0, 26: 0, 27: 0,
      28: 0, 29: 0, 30: 1, 31: 1,
    };

    return Column(
      children: [
        // Cabeçalho dos dias da semana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Grid de dias
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 4,
            childAspectRatio: 0.82,
          ),
          itemCount: 35, // 4 de junho/vazio + 31 dias + 2 de agosto
          itemBuilder: (context, index) {
            int dayNumber = index - 1; // offset de inicio
            if (dayNumber < 1 || dayNumber > 31) {
              int otherMonthDay = dayNumber < 1 ? 30 + dayNumber : dayNumber - 31;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$otherMonthDay',
                    style: const TextStyle(color: Colors.white24, fontSize: 13),
                  ),
                ),
              );
            }

            final status = dayStatus[dayNumber] ?? 0;
            Color bgColor = Colors.white.withValues(alpha: 0.06);
            Color borderColor = Colors.transparent;
            String statusLabel = 'Sem Uso';

            if (status == 2) {
              bgColor = const Color(0xFF00695C).withValues(alpha: 0.8);
              statusLabel = 'Uso\nIntenso';
            } else if (status == 1) {
              bgColor = const Color(0xFF1565C0).withValues(alpha: 0.4);
              borderColor = Colors.cyanAccent.withValues(alpha: 0.8);
              statusLabel = 'Uso\nModerado';
            } else if (status == 3) {
              bgColor = const Color(0xFF1E293B);
              borderColor = Colors.cyanAccent;
              statusLabel = 'Dia Atual';
            }

            return Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width: status == 3 ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DIA,',
                    style: TextStyle(
                      color: status == 0 ? Colors.white38 : Colors.white60,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$dayNumber',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: status == 0 ? Colors.white38 : Colors.cyanAccent,
                      fontSize: 7,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
