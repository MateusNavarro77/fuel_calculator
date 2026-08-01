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

  testWidgets(
    'Drag handle is inside pinned SliverPersistentHeader and responds to gestures',
    (WidgetTester tester) async {
      await tester.pumpWidget(const FuelCalculatorApp(enableTileLayer: false));

      final dragHandleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.hasBoundedWidth == true &&
            widget.constraints?.maxWidth == 48,
      );

      expect(dragHandleFinder, findsOneWidget);

      // Verify drag handle is inside a pinned SliverPersistentHeader inside CustomScrollView
      final customScrollViewFinder = find.byType(CustomScrollView);
      expect(customScrollViewFinder, findsOneWidget);

      final sliverHeaderFinder = find.byType(SliverPersistentHeader);
      expect(sliverHeaderFinder, findsOneWidget);

      expect(
        find.descendant(of: sliverHeaderFinder, matching: dragHandleFinder),
        findsOneWidget,
      );

      // Drag up on the drag handle to expand the sheet
      await tester.drag(dragHandleFinder, const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    },
  );
}
