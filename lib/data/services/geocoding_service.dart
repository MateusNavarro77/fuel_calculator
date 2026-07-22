import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/location_point.dart';

class GeocodingService {
  final http.Client _httpClient;

  GeocodingService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<LocationPoint> searchAddress(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      throw Exception('O endereço não pode estar vazio.');
    }

    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(trimmedQuery)}&format=json&limit=1',
    );

    final response = await _httpClient.get(
      uri,
      headers: {
        'User-Agent': 'FuelCalculatorApp/1.0 (flutter_app)',
        'Accept-Language': 'pt-BR,pt;q=0.9,en;q=0.8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar o endereço. Tente novamente mais tarde.');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    if (jsonList.isEmpty) {
      throw Exception('Endereço não encontrado: "$trimmedQuery"');
    }

    final firstResult = jsonList.first as Map<String, dynamic>;
    final latStr = firstResult['lat'] as String;
    final lonStr = firstResult['lon'] as String;
    final displayName = firstResult['display_name'] as String;

    return LocationPoint(
      addressName: displayName,
      latitude: double.parse(latStr),
      longitude: double.parse(lonStr),
    );
  }
}
