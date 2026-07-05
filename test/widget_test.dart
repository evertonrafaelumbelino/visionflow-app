// Teste básico do widget VisionFlowApp
import 'package:flutter_test/flutter_test.dart';

import 'package:visionflow_app/app/app.dart';

void main() {
  testWidgets('VisionFlowApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VisionFlowApp());

    // Verifica que o app carregou com o título correto
    expect(find.text('VisionFlow'), findsOneWidget);
  });
}