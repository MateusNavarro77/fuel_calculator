import 'package:flutter/material.dart';
import '../../view_models/calculator_view_model.dart';

class InputFormCard extends StatefulWidget {
  final CalculatorViewModel viewModel;

  const InputFormCard({super.key, required this.viewModel});

  @override
  State<InputFormCard> createState() => _InputFormCardState();
}

class _InputFormCardState extends State<InputFormCard> {
  late final TextEditingController _originController;
  late final TextEditingController _destinationController;
  late final TextEditingController _consumptionController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _originController =
        TextEditingController(text: widget.viewModel.originText);
    _destinationController =
        TextEditingController(text: widget.viewModel.destinationText);
    _consumptionController =
        TextEditingController(text: widget.viewModel.consumptionText);
    _priceController = TextEditingController(text: widget.viewModel.priceText);
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _consumptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Dados da Viagem',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Origem (RF01)
            TextField(
              controller: _originController,
              decoration: const InputDecoration(
                labelText: 'Endereço de Origem',
                hintText: 'Ex: Av. Paulista, 1000, São Paulo',
                prefixIcon: Icon(Icons.my_location, color: Colors.green),
              ),
              onChanged: widget.viewModel.setOriginText,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            // Destino (RF02)
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Endereço de Destino',
                hintText: 'Ex: Parque do Ibirapuera, São Paulo',
                prefixIcon: Icon(Icons.location_on, color: Colors.red),
              ),
              onChanged: widget.viewModel.setDestinationText,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Consumo (RF03)
                Expanded(
                  child: TextField(
                    controller: _consumptionController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Consumo (km/L)',
                      hintText: 'Ex: 12.5',
                      prefixIcon: Icon(Icons.speed),
                    ),
                    onChanged: widget.viewModel.setConsumptionText,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),

                // Preço (RF04)
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Preço (R\$/L)',
                      hintText: 'Ex: 6.39',
                      prefixIcon: Icon(Icons.local_gas_station),
                    ),
                    onChanged: widget.viewModel.setPriceText,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => widget.viewModel.calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Switch Ida e Volta (RF05)
            Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            //   shape: RoundedRectangleBorder(
            //  //   borderRadius: BorderRadius.circular(12),
            //     side: const BorderSide(color: Color(0xFFE2E8F0)),
            //   ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Calcular Ida e Volta',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Calcula rota de retorno separadamente (RN05)',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: widget.viewModel.isRoundTrip,
                  onChanged: widget.viewModel.setIsRoundTrip,
                  activeTrackColor: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mensagem de Erro
            if (widget.viewModel.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.viewModel.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Botão Calcular
            ElevatedButton(
              onPressed: widget.viewModel.isLoading
                  ? null
                  : () => widget.viewModel.calculate(),
              child: widget.viewModel.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate),
                        SizedBox(width: 8),
                        Text('Calcular Custo da Viagem'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
