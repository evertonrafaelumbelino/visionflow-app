import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock data de notificações
  static final List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.location_on_rounded,
      'iconColor': const Color(0xFF4CAF50),
      'title': 'Localização Encontrada',
      'description': 'Localização atualizada e fixada.',
      'time': '08:12 AM',
      'category': 'dispositivo',
    },
    {
      'icon': Icons.my_location_rounded,
      'iconColor': const Color(0xFF2196F3),
      'title': 'Localização Atualizada',
      'description':
          "A localização de 'Lucas Silva' foi atualizada para a 'Academia'. Toque para ver a rota.",
      'time': '07:45 AM',
      'category': 'aplicativo',
    },
    {
      'icon': Icons.flag_rounded,
      'iconColor': const Color(0xFFFF9800),
      'title': 'Você Chegou',
      'description':
          "Você chegou ao local desejado: 'Restaurante Central'.",
      'time': '07:30 AM',
      'category': 'dispositivo',
    },
    {
      'icon': Icons.near_me_rounded,
      'iconColor': const Color(0xFFF44336),
      'title': 'Aproximação de Destino',
      'description':
          'Você está a 500 metros do local desejado. Redobre a atenção.',
      'time': '07:15 AM',
      'category': 'dispositivo',
    },
    {
      'icon': Icons.directions_walk_rounded,
      'iconColor': const Color(0xFF9C27B0),
      'title': 'Início de Jornada',
      'description':
          "Navegação para 'Parque Ibirapuera' iniciada. Siga as instruções visuais.",
      'time': '07:00 AM',
      'category': 'aplicativo',
    },
  ];

  List<Map<String, dynamic>> _getFilteredNotifications(int tabIndex) {
    if (tabIndex == 0) return _notifications;
    if (tabIndex == 1) {
      return _notifications
          .where((n) => n['category'] == 'dispositivo')
          .toList();
    }
    return _notifications
        .where((n) => n['category'] == 'aplicativo')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notificações',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Configurar',
              style: TextStyle(
                color: isDark ? AppColors.primaryColor : AppColors.iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => setState(() {}),
          indicatorColor:
              isDark ? AppColors.primaryColor : AppColors.iconColor,
          indicatorWeight: 3,
          labelColor: isDark ? Colors.white : AppColors.textPrimary,
          unselectedLabelColor:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Dispositivo'),
            Tab(text: 'Aplicativos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(3, (tabIndex) {
          final items = _getFilteredNotifications(tabIndex);
          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final notif = items[index];
              return _NotificationCard(
                icon: notif['icon'] as IconData,
                iconColor: notif['iconColor'] as Color,
                title: notif['title'] as String,
                description: notif['description'] as String,
                time: notif['time'] as String,
                isDark: isDark,
              )
                  .animate()
                  .fade(duration: 400.ms, delay: (index * 80).ms)
                  .slideY(begin: 0.1, end: 0);
            },
          );
        }),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;
  final bool isDark;

  const _NotificationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
