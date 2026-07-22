import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../core/mock/app_mock_data.dart';
import '../../../connection/data/repositories/ble_repository_impl.dart';
import '../../../connection/domain/repositories/ble_repository.dart';
import 'notifications_page.dart';
import 'settings_page.dart';
import 'language_page.dart';
import 'audio_controls_page.dart';
import 'battery_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BleRepository _bleRepository = BleRepositoryImpl();
  BleConnectionStatus _connectionStatus = BleConnectionStatus.desconectado;

  @override
  void initState() {
    super.initState();
    BleRepositoryImpl().getConnectedDevice().then((device) {
      if (mounted) {
        setState(() {
          _connectionStatus = device != null
              ? BleConnectionStatus.conectado
              : BleConnectionStatus.desconectado;
        });
      }
    });

    _bleRepository.connectionStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _connectionStatus = status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isConnected = _connectionStatus == BleConnectionStatus.conectado;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho Premium com degradê
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [const Color(0xFF2E3A46), const Color(0xFF4F7D8C)],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botões superiores de controle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const NotificationsPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Textos de saudação
                      const Text(
                        'Olá, usuário!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tudo certo com seus óculos.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Imagem Hero dos óculos posicionada
                Positioned(
                  right: 20,
                  bottom: -15,
                  child: Image.asset(
                    'assets/images/glasses_hero.png',
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 150,
                        color: Colors.transparent,
                        child: const Icon(Icons.visibility, size: 64, color: Colors.white54),
                      );
                    },
                  ),
                ).animate().fade(duration: 500.ms).slideX(begin: 0.2, end: 0),
              ],
            ),
            
            const SizedBox(height: 40),

            // Card flutuante de status de conexão
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: AppDecorations.softCard(
                  isDark: isDark,
                  color: isDark ? AppColors.darkSurface : Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Óculos conectados',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isConnected ? AppMockData.deviceName : 'Nenhum óculos ativo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge Conectado / Desconectado
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? AppColors.successColor.withValues(alpha: 0.15)
                            : AppColors.errorColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isConnected ? AppColors.successColor : AppColors.errorColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        isConnected ? 'Conectado' : 'Desconectado',
                        style: TextStyle(
                          color: isConnected ? AppColors.successColor : AppColors.errorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      isConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
                      color: isConnected ? AppColors.iconColor : AppColors.textDisabled,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Título "Funções rápidas"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Funções rápidas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Grid de Funções Rápidas (Botões grandes e acessíveis)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95, // Formato mais próximo de um quadrado vertical
                ),
                itemCount: AppMockData.quickActions.length,
                itemBuilder: (context, index) {
                  final action = AppMockData.quickActions[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        final label = action['label'] as String;
                        Widget? targetPage;
                        if (label == 'Idiomas') {
                          targetPage = const LanguagePage();
                        } else if (label == 'Áudio') {
                          targetPage = const AudioControlsPage();
                        } else if (label == 'Bateria') {
                          targetPage = const BatteryPage();
                        } else if (label == 'Configurações') {
                          targetPage = const SettingsPage();
                        }

                        if (targetPage != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => targetPage!),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Recurso "$label" em breve.'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      splashColor: AppColors.primaryColor.withValues(alpha: 0.2),
                      highlightColor: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        decoration: AppDecorations.quickAction(isDark: isDark).copyWith(
                          color: isDark ? AppColors.darkSurface : AppColors.surfaceColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSecondary
                                    : AppColors.primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                action['icon'] as IconData,
                                color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                                size: 32, // Ícones grandes para acessibilidade
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              action['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().fade(duration: 600.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
