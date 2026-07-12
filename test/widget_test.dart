// Smoke test do VisionFlowApp v0.2.0-alpha
// flutter_blue_plus lança UnsupportedError em ambiente de teste (sem plataforma BLE).
// Por isso, capturamos a exceção esperada e validamos apenas os widgets de UI.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:visionflow_app/app/app.dart';

void main() {
  testWidgets('VisionFlowApp v0.2.0 smoke test — UI básica carrega', (WidgetTester tester) async {
    // Ignora erros assíncronos de BLE (flutter_blue_plus não suportado em testes)
    FlutterError.onError = (FlutterErrorDetails details) {
      // Silencia erros de BLE no ambiente de teste
      if (details.exceptionAsString().contains('flutter_blue_plus') ||
          details.exceptionAsString().contains('Unsupported operation')) {
        return;
      }
      FlutterError.presentError(details);
    };

    // Inicializa o app
    await tester.pumpWidget(const VisionFlowApp());

    // Processa frames iniciais (animações shimmer, etc.)
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Valida que o MaterialApp foi criado
    expect(find.byType(MaterialApp), findsOneWidget);

    // Valida que a BottomNavigationBar da v0.2.0 está presente
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Valida que a aba "Início" existe na navegação
    expect(find.text('Início'), findsWidgets);

    // Valida que o texto de saudação da HomePage está visível
    expect(find.text('Olá, usuário!'), findsOneWidget);
  });

  testWidgets('Navegação entre abas funciona', (WidgetTester tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('flutter_blue_plus') ||
          details.exceptionAsString().contains('Unsupported operation')) {
        return;
      }
      FlutterError.presentError(details);
    };

    await tester.pumpWidget(const VisionFlowApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Toca na aba "Atividades" (índice 2)
    await tester.tap(find.text('Atividades'));
    await tester.pump(const Duration(milliseconds: 300));

    // Valida que a página de Atividades carregou
    expect(find.text('Atividades'), findsWidgets);

    // Toca na aba "Perfil" (índice 3)
    await tester.tap(find.text('Perfil'));
    await tester.pump(const Duration(milliseconds: 300));

    // Valida que a página de Perfil carregou
    expect(find.text('Perfil'), findsWidgets);
  });
}