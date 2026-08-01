import '../models/fuel_calculation.dart';
import '../models/location_point.dart';
import '../models/route_segment.dart';
import '../../data/services/geocoding_service.dart';
import '../../data/services/routing_service.dart';

class TripCalculationResult {
  final LocationPoint originPoint;
  final LocationPoint destinationPoint;
  final RouteSegment outboundRoute;
  final RouteSegment? returnRoute;
  final FuelCalculation calculation;

  TripCalculationResult({
    required this.originPoint,
    required this.destinationPoint,
    required this.outboundRoute,
    this.returnRoute,
    required this.calculation,
  });
}

class FuelCalculatorRepository {
  final GeocodingService _geocodingService;
  final RoutingService _routingService;

  FuelCalculatorRepository({
    GeocodingService? geocodingService,
    RoutingService? routingService,
  }) : _geocodingService = geocodingService ?? GeocodingService(),
       _routingService = routingService ?? RoutingService();

  Future<TripCalculationResult> calculateTrip({
    required String originAddress,
    required String destinationAddress,
    required double vehicleConsumptionKmPerLitre,
    required double fuelPricePerLitre,
    required bool isRoundTrip,
  }) async {
    // 1. Geocode origin and destination
    final originPoint = await _geocodingService.searchAddress(originAddress);
    final destinationPoint = await _geocodingService.searchAddress(
      destinationAddress,
    );

    // 2. Fetch outbound route
    final outboundRoute = await _routingService.getRoute(
      origin: originPoint,
      destination: destinationPoint,
    );

    // 3. Fetch return route if round trip enabled (RN05)
    RouteSegment? returnRoute;
    if (isRoundTrip) {
      returnRoute = await _routingService.getRoute(
        origin: destinationPoint,
        destination: originPoint,
      );
    }

    // 4. Perform fuel calculation
    final calculation = FuelCalculation(
      outboundDistanceKm: outboundRoute.distanceKm,
      returnDistanceKm: returnRoute?.distanceKm,
      isRoundTrip: isRoundTrip,
      vehicleConsumptionKmPerLitre: vehicleConsumptionKmPerLitre,
      fuelPricePerLitre: fuelPricePerLitre,
    );

    return TripCalculationResult(
      originPoint: originPoint,
      destinationPoint: destinationPoint,
      outboundRoute: outboundRoute,
      returnRoute: returnRoute,
      calculation: calculation,
    );
  }
}
