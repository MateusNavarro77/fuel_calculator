import '../../data/services/geocoding_service.dart';
import '../models/location_point.dart';

class GeocodingRepository {
  final GeocodingService _geocodingService;

  GeocodingRepository({GeocodingService? geocodingService})
    : _geocodingService = geocodingService ?? GeocodingService();

  Future<List<LocationPoint>> fetchSuggestions(String query, {int limit = 5}) {
    return _geocodingService.fetchAddressSuggestions(query, limit: limit);
  }

  Future<LocationPoint> searchAddress(String query) {
    return _geocodingService.searchAddress(query);
  }
}
