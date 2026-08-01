import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/domain/repositories/geocoding_repository.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/utils/debouncer.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/view_models/address_autocomplete_view_model.dart';

class _FakeGeocodingRepository implements GeocodingRepository {
  final List<LocationPoint> suggestions;

  _FakeGeocodingRepository(this.suggestions);

  @override
  Future<List<LocationPoint>> fetchSuggestions(
    String query, {
    int limit = 5,
  }) async {
    return suggestions;
  }

  @override
  Future<LocationPoint> searchAddress(String query) async {
    return suggestions.first;
  }
}

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
        final fakeRepo = _FakeGeocodingRepository([
          const LocationPoint(addressName: 'Test', latitude: 0, longitude: 0),
        ]);
        final viewModel = AddressAutocompleteViewModel(
          repository: fakeRepo,
          debouncer: debouncer,
        );

        final result = await viewModel.getSuggestions('Av');
        expect(result, isEmpty);
        expect(viewModel.suggestions, isEmpty);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      },
    );

    test(
      'getSuggestions fetches suggestions, updates state and notifies listeners',
      () async {
        final expectedLocation = const LocationPoint(
          addressName: 'Avenida Paulista',
          latitude: -23.5,
          longitude: -46.6,
        );
        final fakeRepo = _FakeGeocodingRepository([expectedLocation]);
        final viewModel = AddressAutocompleteViewModel(
          repository: fakeRepo,
          debouncer: debouncer,
        );

        final future = viewModel.getSuggestions('Avenida Paulista');
        expect(viewModel.isLoading, isTrue);

        final results = await future;
        expect(results.length, equals(1));
        expect(viewModel.suggestions.length, equals(1));
        expect(
          viewModel.suggestions.first.addressName,
          equals('Avenida Paulista'),
        );
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      },
    );

    test('cancelPending cancels pending requests without error', () async {
      final fakeRepo = _FakeGeocodingRepository([]);
      final viewModel = AddressAutocompleteViewModel(
        repository: fakeRepo,
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
