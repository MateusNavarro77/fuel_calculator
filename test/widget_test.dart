import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/main.dart';

void main() {
  testWidgets('Fuel Calculator App renders successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FuelCalculatorApp(enableTileLayer: false));

    expect(find.text('Calculadora de Combustível'), findsNothing);
    expect(find.byTooltip('Limpar formulário'), findsOneWidget);
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.text('Dados da Viagem'), findsOneWidget);
    expect(find.text('Endereço de Origem'), findsOneWidget);
    expect(find.text('Endereço de Destino'), findsOneWidget);
  });
}
