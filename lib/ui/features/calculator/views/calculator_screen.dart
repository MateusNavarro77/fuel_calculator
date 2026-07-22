import 'package:flutter/material.dart';
import '../view_models/calculator_view_model.dart';
import 'widgets/input_form_card.dart';
import 'widgets/map_view_widget.dart';
import 'widgets/result_card.dart';

class CalculatorScreen extends StatefulWidget {
  final bool enableTileLayer;

  const CalculatorScreen({super.key, this.enableTileLayer = true});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorViewModel _viewModel = CalculatorViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_gas_station),
                SizedBox(width: 8),
                Text('Calculadora de Combustível'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Limpar formulário',
                onPressed: _viewModel.reset,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Formulário de Entrada (RF01 - RF05)
                InputFormCard(viewModel: _viewModel),

                // Exibição do Mapa com a Rota (RF06)
                MapViewWidget(
                  tripResult: _viewModel.tripResult,
                  enableTileLayer: widget.enableTileLayer,
                ),

                // Card de Resultados (RF07, RF08)
                if (_viewModel.tripResult != null)
                  ResultCard(result: _viewModel.tripResult!),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
