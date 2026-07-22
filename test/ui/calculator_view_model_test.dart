import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/ui/features/calculator/view_models/calculator_view_model.dart';

void main() {
  group('CalculatorViewModel Unit Tests', () {
    late CalculatorViewModel viewModel;

    setUp(() {
      viewModel = CalculatorViewModel();
    });

    test('Validação de Origem e Destino obrigatórios (RN03)', () {
      expect(viewModel.validateInputs(), isFalse);
      expect(viewModel.errorMessage, contains('origem'));

      viewModel.setOriginText('Avenida Paulista');
      expect(viewModel.validateInputs(), isFalse);
      expect(viewModel.errorMessage, contains('destino'));
    });

    test('Validação de consumo do veículo (RN01)', () {
      viewModel.setOriginText('Origem Teste');
      viewModel.setDestinationText('Destino Teste');

      viewModel.setConsumptionText('0');
      expect(viewModel.validateInputs(), isFalse);
      expect(viewModel.errorMessage, contains('rendimento'));

      viewModel.setConsumptionText('-5');
      expect(viewModel.validateInputs(), isFalse);

      viewModel.setConsumptionText('12,5');
      expect(viewModel.validateInputs(), isFalse); // preço ainda vazio
      expect(viewModel.errorMessage, contains('preço'));
    });

    test('Validação de preço do combustível (RN02)', () {
      viewModel.setOriginText('Origem Teste');
      viewModel.setDestinationText('Destino Teste');
      viewModel.setConsumptionText('12,5');
      viewModel.setPriceText('0');

      expect(viewModel.validateInputs(), isFalse);
      expect(viewModel.errorMessage, contains('preço'));

      viewModel.setPriceText('6,39');
      expect(viewModel.validateInputs(), isTrue);
      expect(viewModel.errorMessage, isNull);
    });
  });
}
