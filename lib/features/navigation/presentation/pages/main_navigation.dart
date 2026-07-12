import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../connection/presentation/pages/connection_page.dart';
import '../../../connection/presentation/pages/connected_device_page.dart';
import '../../../activities/presentation/pages/activities_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../connection/data/repositories/ble_repository_impl.dart';
import '../../../connection/domain/repositories/ble_repository.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final BleRepository _bleRepository = BleRepositoryImpl();
  BleConnectionStatus _connectionStatus = BleConnectionStatus.desconectado;

  @override
  void initState() {
    super.initState();
    // Escuta as alterações na conexão para atualizar o estado e saber qual tela de dispositivos exibir
    _bleRepository.connectionStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _connectionStatus = status;
        });
      }
    });
  }

  // Lista de páginas
  List<Widget> _buildPages() {
    return [
      const HomePage(),
      _connectionStatus == BleConnectionStatus.conectado
          ? const ConnectedDevicePage()
          : const ConnectionPage(),
      const ActivitiesPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Acessibilidade: Botões grandes e rotas legíveis
          selectedFontSize: 14,
          unselectedFontSize: 12,
          iconSize: 28, // Ícones maiores para acessibilidade
          selectedItemColor: isDark ? AppColors.primaryColor : AppColors.iconColor,
          unselectedItemColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lens_blur_rounded), // Ícone que lembra óculos/visão
              activeIcon: Icon(Icons.visibility_rounded),
              label: 'Dispositivos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Atividades',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ).animate(target: _currentIndex.toDouble()).shimmer(duration: 300.ms, color: AppColors.primaryColor.withValues(alpha: 0.2)),
      ),
    );
  }
}
