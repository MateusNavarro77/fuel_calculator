import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/ui/features/calculator/view_models/calculator_view_model.dart';
import 'package:fuel_calculator/ui/features/calculator/views/widgets/input_form_card.dart';

void main() {
  testWidgets('keeps entered values when the view model notifies listeners', (
    WidgetTester tester,
  ) async {
    final viewModel = CalculatorViewModel();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: InputFormCard(viewModel: viewModel)),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Av. Paulista, 1000');
    await tester.enterText(find.byType(TextField).at(1), 'Parque Ibirapuera');
    await tester.enterText(find.byType(TextField).at(2), '12.5');
    await tester.enterText(find.byType(TextField).at(3), '6.39');

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.text('Av. Paulista, 1000'), findsOneWidget);
    expect(find.text('Parque Ibirapuera'), findsOneWidget);
    expect(find.text('12.5'), findsOneWidget);
    expect(find.text('6.39'), findsOneWidget);

    viewModel.reset();
    await tester.pump();

    for (var index = 0; index < 4; index++) {
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(index))
            .controller!
            .text,
        isEmpty,
      );
    }
  });
}
