import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/navigation/presentation/pages/main_navigation.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

/// Widget principal do aplicativo VisionFlow
/// 
/// Configura o tema, rotas e inicialização do app

class VisionFlowApp extends StatelessWidget {
  const VisionFlowApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: MaterialApp(
        title: 'VisionFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigation(),
        // Mantém o builder para possíveis futuras configurações de acessibilidade,
        // agora respeitando o TextScaler do sistema (removendo bloqueio de zoom)
        builder: (context, child) {
          // Ajusta brilho dos ícones do sistema conforme o tema atual
          final brightness = Theme.of(context).brightness;
          final isDark = brightness == Brightness.dark;
          // Por dependência ciclíca do contexto, recomenda-se que este código seja
          // executado aqui via addPostFrameCallback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              ),
            );
          });
          // Permite que o texto seja escalável conforme configurações do sistema
          return child!;
        },
      ),
    );
  }
}