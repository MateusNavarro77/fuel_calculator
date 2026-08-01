import 'package:flutter/foundation.dart';
import '../../../../domain/repositories/fuel_calculator_repository.dart';

class CalculatorViewModel extends ChangeNotifier {
  final FuelCalculatorRepository _repository;

  CalculatorViewModel({FuelCalculatorRepository? repository})
    : _repository = repository ?? FuelCalculatorRepository();

  String _originText = '';
  String _destinationText = '';
  String _consumptionText = '';
  String _priceText = '';
  bool _isRoundTrip = false;

  bool _isLoading = false;
  String? _errorMessage;
  TripCalculationResult? _tripResult;

  // Getters
  String get originText => _originText;
  String get destinationText => _destinationText;
  String get consumptionText => _consumptionText;
  String get priceText => _priceText;
  bool get isRoundTrip => _isRoundTrip;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TripCalculationResult? get tripResult => _tripResult;

  // Setters / Updates
  void setOriginText(String value) {
    _originText = value;
    _clearError();
  }

  void setDestinationText(String value) {
    _destinationText = value;
    _clearError();
  }

  void setConsumptionText(String value) {
    _consumptionText = value;
    _clearError();
  }

  void setPriceText(String value) {
    _priceText = value;
    _clearError();
  }

  void setIsRoundTrip(bool value) {
    _isRoundTrip = value;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  double? _parseBrazilianDouble(String input) {
    final cleanInput = input
        .replaceAll('R\$', '')
        .replaceAll('km/L', '')
        .trim();
    if (cleanInput.isEmpty) return null;
    final normalized = cleanInput.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  bool validateInputs() {
    if (_originText.trim().isEmpty) {
      _errorMessage = 'Por favor, informe o endereço de origem (RN03).';
      notifyListeners();
      return false;
    }

    if (_destinationText.trim().isEmpty) {
      _errorMessage = 'Por favor, informe o endereço de destino (RN03).';
      notifyListeners();
      return false;
    }

    final consumption = _parseBrazilianDouble(_consumptionText);
    if (consumption == null || consumption <= 0) {
      _errorMessage = 'O rendimento do veículo deve ser maior que zero (RN01).';
      notifyListeners();
      return false;
    }

    final price = _parseBrazilianDouble(_priceText);
    if (price == null || price <= 0) {
      _errorMessage = 'O preço do combustível deve ser maior que zero (RN02).';
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    return true;
  }

  Future<void> calculate() async {
    if (!validateInputs()) return;

    final consumption = _parseBrazilianDouble(_consumptionText)!;
    final price = _parseBrazilianDouble(_priceText)!;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tripResult = await _repository.calculateTrip(
        originAddress: _originText,
        destinationAddress: _destinationText,
        vehicleConsumptionKmPerLitre: consumption,
        fuelPricePerLitre: price,
        isRoundTrip: _isRoundTrip,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _tripResult = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _originText = '';
    _destinationText = '';
    _consumptionText = '';
    _priceText = '';
    _isRoundTrip = false;
    _isLoading = false;
    _errorMessage = null;
    _tripResult = null;
    notifyListeners();
  }
}
