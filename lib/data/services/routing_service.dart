import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../domain/models/location_point.dart';
import '../../domain/models/route_segment.dart';

class RoutingService {
  final http.Client _httpClient;

  RoutingService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<RouteSegment> getRoute({
    required LocationPoint origin,
    required LocationPoint destination,
  }) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson';

    final response = await _httpClient.get(
      Uri.parse(url),
      headers: {'User-Agent': 'FuelCalculatorApp/1.0 (flutter_app)'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao calcular rota entre os pontos.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final routes = data['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) {
      throw Exception('Nenhuma rota encontrada entre os locais informados.');
    }

    final firstRoute = routes.first as Map<String, dynamic>;
    final double distanceMeters = (firstRoute['distance'] as num).toDouble();
    final double distanceKm = distanceMeters / 1000.0;

    final geometry = firstRoute['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;

    final polylinePoints = coordinates.map((coord) {
      final point = coord as List<dynamic>;
      final lon = (point[0] as num).toDouble();
      final lat = (point[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();

    return RouteSegment(
      origin: origin,
      destination: destination,
      distanceKm: distanceKm,
      polylinePoints: polylinePoints,
    );
  }
}
