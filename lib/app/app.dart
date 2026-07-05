import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/connection/presentation/pages/connection_page.dart';
import 'theme/app_theme.dart';

/// Widget principal do aplicativo VisionFlow
/// 
/// Configura o tema, rotas e inicialização do app

class VisionFlowApp extends StatelessWidget {
  const VisionFlowApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Configura a orientação preferida (retrato para acessibilidade)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Configura a barra de status (transparente, ícones claros)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    return MaterialApp(
      title: 'VisionFlow',
      debugShowCheckedModeBanner: false,
      
      // Tema de alto contraste para acessibilidade
      theme: AppTheme.darkTheme,
      
      // Tela inicial
      home: const ConnectionPage(),
      
      // Configurações de acessibilidade
      builder: (context, child) {
        // Garante que o texto seja escalável
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}