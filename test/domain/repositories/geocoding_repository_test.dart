import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/domain/repositories/geocoding_repository.dart';
import 'package:fuel_calculator/data/services/geocoding_service.dart';

class _FakeGeocodingService implements GeocodingService {
  final List<LocationPoint> suggestionsToReturn;
  final LocationPoint? searchToReturn;

  _FakeGeocodingService({
    this.suggestionsToReturn = const [],
    this.searchToReturn,
  });

  @override
  Future<List<LocationPoint>> fetchAddressSuggestions(
    String query, {
    int limit = 5,
  }) async {
    return suggestionsToReturn;
  }

  @override
  Future<LocationPoint> searchAddress(String query) async {
    if (searchToReturn != null) return searchToReturn!;
    throw Exception('Not found');
  }
}

void main() {
  group('GeocodingRepository Unit Tests', () {
    test('fetchSuggestions delegates to GeocodingService', () async {
      final expectedPoints = [
        const LocationPoint(
          addressName: 'Test Address',
          latitude: 10.0,
          longitude: 20.0,
        ),
      ];
      final fakeService = _FakeGeocodingService(
        suggestionsToReturn: expectedPoints,
      );
      final repository = GeocodingRepository(geocodingService: fakeService);

      final results = await repository.fetchSuggestions('Test');
      expect(results, equals(expectedPoints));
    });

    test('searchAddress delegates to GeocodingService', () async {
      const expectedPoint = LocationPoint(
        addressName: 'Search Address',
        latitude: 1.0,
        longitude: 2.0,
      );
      final fakeService = _FakeGeocodingService(searchToReturn: expectedPoint);
      final repository = GeocodingRepository(geocodingService: fakeService);

      final result = await repository.searchAddress('Search');
      expect(result, equals(expectedPoint));
    });
  });
}
