class FuelCalculation {
  final double outboundDistanceKm;
  final double? returnDistanceKm;
  final bool isRoundTrip;
  final double vehicleConsumptionKmPerLitre;
  final double fuelPricePerLitre;

  const FuelCalculation({
    required this.outboundDistanceKm,
    this.returnDistanceKm,
    required this.isRoundTrip,
    required this.vehicleConsumptionKmPerLitre,
    required this.fuelPricePerLitre,
  });

  double get totalDistanceKm {
    if (isRoundTrip && returnDistanceKm != null) {
      return outboundDistanceKm + returnDistanceKm!;
    }
    return outboundDistanceKm;
  }

  double get litresNeeded {
    if (vehicleConsumptionKmPerLitre <= 0) return 0.0;
    return totalDistanceKm / vehicleConsumptionKmPerLitre;
  }

  double get estimatedCost {
    if (fuelPricePerLitre <= 0) return 0.0;
    return litresNeeded * fuelPricePerLitre;
  }
}
