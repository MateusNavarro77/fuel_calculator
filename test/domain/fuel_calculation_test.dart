import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/domain/models/fuel_calculation.dart';

void main() {
  group('FuelCalculation Unit Tests', () {
    test('Calcula distância, litros e custo corretamente para viagem só de ida', () {
      const calculation = FuelCalculation(
        outboundDistanceKm: 100.0,
        isRoundTrip: false,
        vehicleConsumptionKmPerLitre: 10.0,
        fuelPricePerLitre: 6.00,
      );

      expect(calculation.totalDistanceKm, equals(100.0));
      expect(calculation.litresNeeded, equals(10.0));
      expect(calculation.estimatedCost, equals(60.0));
    });

    test('Calcula viagem de ida e volta somando rotas distintas (RN05)', () {
      const calculation = FuelCalculation(
        outboundDistanceKm: 100.0,
        returnDistanceKm: 105.0,
        isRoundTrip: true,
        vehicleConsumptionKmPerLitre: 10.0,
        fuelPricePerLitre: 6.00,
      );

      expect(calculation.totalDistanceKm, equals(205.0));
      expect(calculation.litresNeeded, equals(20.5));
      expect(calculation.estimatedCost, equals(123.0));
    });

    test('Retorna 0 para litros e custo se consumo for zero ou negativo (RN01)', () {
      const calculation = FuelCalculation(
        outboundDistanceKm: 100.0,
        isRoundTrip: false,
        vehicleConsumptionKmPerLitre: 0.0,
        fuelPricePerLitre: 6.00,
      );

      expect(calculation.litresNeeded, equals(0.0));
      expect(calculation.estimatedCost, equals(0.0));
    });

    test('Retorna custo 0 se preço do combustível for zero ou negativo (RN02)', () {
      const calculation = FuelCalculation(
        outboundDistanceKm: 100.0,
        isRoundTrip: false,
        vehicleConsumptionKmPerLitre: 10.0,
        fuelPricePerLitre: 0.0,
      );

      expect(calculation.litresNeeded, equals(10.0));
      expect(calculation.estimatedCost, equals(0.0));
    });
  });
}
