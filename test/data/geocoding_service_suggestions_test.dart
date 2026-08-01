import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fuel_calculator/data/services/geocoding_service.dart';

void main() {
  group('GeocodingService - fetchAddressSuggestions', () {
    test('returns empty list if query is less than 3 characters', () async {
      final client = MockClient((request) async {
        return http.Response('[]', 200);
      });
      final service = GeocodingService(httpClient: client);

      final result = await service.fetchAddressSuggestions('Av');
      expect(result, isEmpty);
    });

    test('parses and returns suggestions list on HTTP 200', () async {
      final mockJsonResponse = jsonEncode([
        {
          'display_name': 'Avenida Paulista, Bela Vista, São Paulo, SP',
          'lat': '-23.5613',
          'lon': '-46.6565',
        },
        {
          'display_name': 'Avenida Paulista, Rio Claro, SP',
          'lat': '-22.4000',
          'lon': '-47.5600',
        },
      ]);

      final client = MockClient((request) async {
        expect(request.url.queryParameters['q'], equals('Avenida Paulista'));
        expect(request.url.queryParameters['limit'], equals('5'));
        return http.Response(
          mockJsonResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = GeocodingService(httpClient: client);
      final suggestions = await service.fetchAddressSuggestions(
        'Avenida Paulista',
      );

      expect(suggestions.length, equals(2));
      expect(
        suggestions[0].addressName,
        equals('Avenida Paulista, Bela Vista, São Paulo, SP'),
      );
      expect(suggestions[0].latitude, equals(-23.5613));
      expect(suggestions[0].longitude, equals(-46.6565));

      expect(
        suggestions[1].addressName,
        equals('Avenida Paulista, Rio Claro, SP'),
      );
    });

    test('returns empty list on HTTP error or exception', () async {
      final client = MockClient((request) async {
        return http.Response('Server error', 500);
      });
      final service = GeocodingService(httpClient: client);

      final suggestions = await service.fetchAddressSuggestions(
        'Avenida Paulista',
      );
      expect(suggestions, isEmpty);
    });
  });
}
