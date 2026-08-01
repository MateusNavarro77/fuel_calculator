import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/ui/features/calculator/views/widgets/address_autocomplete_field.dart';

void main() {
  group('AddressAutocompleteField Widget Tests', () {
    late TextEditingController controller;
    late FocusNode focusNode;

    setUp(() {
      controller = TextEditingController();
      focusNode = FocusNode();
    });

    tearDown(() {
      controller.dispose();
      focusNode.dispose();
    });

    testWidgets(
      'fetches and displays suggestions after debounce duration when typing',
      (tester) async {
        String changedText = '';
        var fetchCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AddressAutocompleteField(
                labelText: 'Endereço de Origem',
                hintText: 'Digite aqui',
                prefixIcon: Icons.my_location,
                prefixIconColor: Colors.orange,
                controller: controller,
                focusNode: focusNode,
                debounceDuration: const Duration(milliseconds: 200),
                fetchSuggestions: (query) async {
                  fetchCount++;
                  return const [
                    LocationPoint(
                      addressName: 'Avenida Paulista, São Paulo',
                      latitude: -23.5613,
                      longitude: -46.6565,
                    ),
                    LocationPoint(
                      addressName: 'Avenida Paulista, Rio Claro',
                      latitude: -22.4000,
                      longitude: -47.5600,
                    ),
                  ];
                },
                onChanged: (val) {
                  changedText = val;
                },
              ),
            ),
          ),
        );

        // Enter text
        await tester.enterText(find.byType(TextField), 'Avenida Paulista');
        expect(changedText, equals('Avenida Paulista'));

        // Right after typing, fetch should not be called yet due to debounce
        expect(fetchCount, equals(0));

        // Advance clock past debounce duration
        await tester.pump(const Duration(milliseconds: 250));
        await tester.pumpAndSettle();

        expect(fetchCount, equals(1));
        expect(find.text('Avenida Paulista, São Paulo'), findsOneWidget);
        expect(find.text('Avenida Paulista, Rio Claro'), findsOneWidget);

        // Select first option
        await tester.tap(find.text('Avenida Paulista, São Paulo'));
        await tester.pumpAndSettle();

        expect(controller.text, equals('Avenida Paulista, São Paulo'));
        expect(changedText, equals('Avenida Paulista, São Paulo'));
      },
    );

    testWidgets(
      'does not fetch suggestions if text length is less than 3 characters',
      (tester) async {
        var fetchCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AddressAutocompleteField(
                labelText: 'Endereço de Origem',
                hintText: 'Digite aqui',
                prefixIcon: Icons.my_location,
                prefixIconColor: Colors.orange,
                controller: controller,
                focusNode: focusNode,
                debounceDuration: const Duration(milliseconds: 200),
                fetchSuggestions: (query) async {
                  fetchCount++;
                  return const [];
                },
                onChanged: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Av');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        expect(fetchCount, equals(0));
      },
    );
  });
}
