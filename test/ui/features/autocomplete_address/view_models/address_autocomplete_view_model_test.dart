import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/utils/debouncer.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/view_models/address_autocomplete_view_model.dart';

void main() {
  group('AddressAutocompleteViewModel Unit Tests', () {
    late Debouncer debouncer;

    setUp(() {
      debouncer = Debouncer(duration: const Duration(milliseconds: 50));
    });

    tearDown(() {
      debouncer.dispose();
    });

    test(
      'getSuggestions returns empty list for queries shorter than 3 characters',
      () async {
        var fetchCount = 0;
        final viewModel = AddressAutocompleteViewModel(
          fetchSuggestions: (query) async {
            fetchCount++;
            return const [
              LocationPoint(addressName: 'Test', latitude: 0, longitude: 0),
            ];
          },
          debouncer: debouncer,
        );

        final result = await viewModel.getSuggestions('Av');
        expect(result, isEmpty);
        expect(fetchCount, equals(0));
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      },
    );

    test(
      'getSuggestions fetches suggestions after debouncing and updates isLoading',
      () async {
        var fetchCount = 0;
        final viewModel = AddressAutocompleteViewModel(
          fetchSuggestions: (query) async {
            fetchCount++;
            return [
              LocationPoint(
                addressName: 'Avenida Paulista',
                latitude: -23.5,
                longitude: -46.6,
              ),
            ];
          },
          debouncer: debouncer,
        );

        final future = viewModel.getSuggestions('Avenida Paulista');
        expect(viewModel.isLoading, isTrue);

        final results = await future;
        expect(results.length, equals(1));
        expect(results.first.addressName, equals('Avenida Paulista'));
        expect(fetchCount, equals(1));
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      },
    );

    test('cancelPending cancels pending requests without error', () async {
      final viewModel = AddressAutocompleteViewModel(
        fetchSuggestions: (query) async => const [],
        debouncer: debouncer,
      );

      final future = viewModel.getSuggestions('Search Query');
      viewModel.cancelPending();

      final results = await future;
      expect(results, isEmpty);

      viewModel.dispose();
    });
  });
}
