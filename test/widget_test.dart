import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/main.dart';

void main() {
  testWidgets('SismoListo PE smoke test y navegación entre módulos', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const SismoListoApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify app title and emergency module are loaded
    expect(find.text('SismoListo PE'), findsOneWidget);
    expect(find.text('SMS 119: Estoy a Salvo'), findsOneWidget);
    expect(find.text('Evento sísmico en curso / Alerta'), findsOneWidget);

    // Navigate to Mochila tab
    await tester.tap(find.text('Mochila'));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Backpack checklist items
    expect(find.text('Mochila Sísmica INDECI'), findsOneWidget);
    expect(find.text('Agua embotellada (4L)'), findsOneWidget);

    // Navigate to Mi Plan tab
    await tester.tap(find.text('Mi Plan'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Plan Familiar Sísmico'), findsOneWidget);

    // Navigate to Auxilio tab
    await tester.tap(find.text('Auxilio'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Directorio de Auxilio Inmediato'), findsOneWidget);
  });
}
