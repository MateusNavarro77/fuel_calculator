import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/domain/repositories/geocoding_repository.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/views/widgets/address_autocomplete_field.dart';

class _MockGeocodingRepository implements GeocodingRepository {
  final Future<List<LocationPoint>> Function(String query) fetchHandler;

  _MockGeocodingRepository(this.fetchHandler);

  @override
  Future<List<LocationPoint>> fetchSuggestions(String query, {int limit = 5}) =>
      fetchHandler(query);

  @override
  Future<LocationPoint> searchAddress(String query) async {
    final list = await fetchHandler(query);
    return list.first;
  }
}

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
      'fetches suggestions, fires onQueryResult, onChanged and onSelected callbacks',
      (tester) async {
        String changedText = '';
        LocationPoint? selectedPoint;
        List<LocationPoint>? queryResultPoints;
        var fetchCount = 0;

        final repository = _MockGeocodingRepository((query) async {
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
        });

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
                geocodingRepository: repository,
                debounceDuration: const Duration(milliseconds: 200),
                onChanged: (val) => changedText = val,
                onSelected: (point) => selectedPoint = point,
                onQueryResult: (results) => queryResultPoints = results,
              ),
            ),
          ),
        );

        // Enter text
        await tester.enterText(find.byType(TextField), 'Avenida Paulista');
        expect(changedText, equals('Avenida Paulista'));
        expect(fetchCount, equals(0));

        // Advance clock past debounce duration
        await tester.pump(const Duration(milliseconds: 250));
        await tester.pumpAndSettle();

        expect(fetchCount, equals(1));
        expect(queryResultPoints, isNotNull);
        expect(queryResultPoints!.length, equals(2));
        expect(find.text('Avenida Paulista, São Paulo'), findsOneWidget);
        expect(find.text('Avenida Paulista, Rio Claro'), findsOneWidget);

        // Select first option
        await tester.tap(find.text('Avenida Paulista, São Paulo'));
        await tester.pumpAndSettle();

        expect(controller.text, equals('Avenida Paulista, São Paulo'));
        expect(changedText, equals('Avenida Paulista, São Paulo'));
        expect(selectedPoint, isNotNull);
        expect(
          selectedPoint!.addressName,
          equals('Avenida Paulista, São Paulo'),
        );
      },
    );

    testWidgets(
      'does not fetch suggestions if text length is less than 3 characters',
      (tester) async {
        var fetchCount = 0;
        final repository = _MockGeocodingRepository((query) async {
          fetchCount++;
          return const [];
        });

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
                geocodingRepository: repository,
                debounceDuration: const Duration(milliseconds: 200),
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
