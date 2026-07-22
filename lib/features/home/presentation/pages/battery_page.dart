import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  bool _desempenhoMaximo = true;
  bool _modoEco = false;
  bool _economiaExtrema = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'INFO. DA BATERIA DO ÓCULOS',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Gauge (Óculos + Anel de Bateria) ──
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Imagem do Óculos
                      Image.asset(
                        'assets/images/glasses_hero.png',
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.remove_red_eye_outlined, size: 80, color: Colors.white54),
                      ),
                      const SizedBox(width: 20),
                      // Ring indicador de carga
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: 0.85,
                                strokeWidth: 8,
                                backgroundColor: Colors.white12,
                                color: const Color(0xFF4CAF50),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'CARGA:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '85%',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: -0.1, end: 0),

            const SizedBox(height: 24),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 20),

            // ── STATUS ATUAL ──
            _buildSectionTitle(Icons.bolt_rounded, 'STATUS ATUAL'),
            const SizedBox(height: 10),
            _buildBulletText('Status: Desconectado da tomada (Em uso)'),
            _buildBulletText('Tempo restante estimado: 4 horas e 20 minutos'),

            const SizedBox(height: 24),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 20),

            // ── CONSUMO POR APLICATIVO ──
            _buildSectionTitle(Icons.bar_chart_rounded, 'CONSUMO POR APLICATIVO'),
            const SizedBox(height: 14),
            _buildUsageProgressRow('Câmera e Gravação', 0.70, '70%'),
            const SizedBox(height: 10),
            _buildUsageProgressRow('Streaming de Áudio', 0.20, '20%'),
            const SizedBox(height: 10),
            _buildUsageProgressRow('Interface e Sistema', 0.10, '10%'),

            const SizedBox(height: 24),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 20),

            // ── MODOS DE ENERGIA ──
            _buildSectionTitle(Icons.settings_suggest_rounded, 'MODOS DE ENERGIA'),
            const SizedBox(height: 14),
            _buildEnergyModeTile(
              title: 'Desempenho Máximo [ON]',
              description: 'Recursos visuais avançados e atualizações em tempo real ativadas.',
              value: _desempenhoMaximo,
              onChanged: (val) {
                setState(() {
                  _desempenhoMaximo = val;
                  if (val) {
                    _modoEco = false;
                    _economiaExtrema = false;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildEnergyModeTile(
              title: 'Modo Eco [OFF]',
              description:
                  'Reduz o brilho da tela e desativa notificações em segundo plano para estender a bateria em até 2 horas.',
              value: _modoEco,
              onChanged: (val) {
                setState(() {
                  _modoEco = val;
                  if (val) {
                    _desempenhoMaximo = false;
                    _economiaExtrema = false;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildEnergyModeTile(
              title: 'Economia Extrema [OFF]',
              description:
                  'Mantém apenas as funções básicas (relógio e notificações urgentes).',
              value: _economiaExtrema,
              onChanged: (val) {
                setState(() {
                  _economiaExtrema = val;
                  if (val) {
                    _desempenhoMaximo = false;
                    _modoEco = false;
                  }
                });
              },
            ),

            const SizedBox(height: 24),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 20),

            // ── SAÚDE DA BATERIA ──
            _buildSectionTitle(Icons.medical_services_outlined, 'SAÚDE DA BATERIA'),
            const SizedBox(height: 10),
            _buildBulletText('Estado de saúde: Excelente (98% da capacidade original)'),
            _buildBulletText('Ciclos de carga: 42 ciclos'),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('* ', style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageProgressRow(String name, double percent, String label) {
    return Row(
      children: [
        Text('* ', style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
        Expanded(
          flex: 4,
          child: Text(
            name,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.white12,
              color: Colors.cyan,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEnergyModeTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 0.85,
          child: Switch(
            value: value,
            activeTrackColor: Colors.cyan,
            activeThumbColor: Colors.white,
            inactiveTrackColor: Colors.white24,
            inactiveThumbColor: Colors.white60,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
