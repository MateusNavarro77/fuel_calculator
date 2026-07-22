import 'package:latlong2/latlong.dart';
import 'location_point.dart';

class RouteSegment {
  final LocationPoint origin;
  final LocationPoint destination;
  final double distanceKm;
  final List<LatLng> polylinePoints;

  const RouteSegment({
    required this.origin,
    required this.destination,
    required this.distanceKm,
    required this.polylinePoints,
  });
}
