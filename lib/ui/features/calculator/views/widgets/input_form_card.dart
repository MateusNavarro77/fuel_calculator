import 'package:flutter/material.dart';
import '../../view_models/calculator_view_model.dart';

class InputFormCard extends StatefulWidget {
  final CalculatorViewModel viewModel;
  final VoidCallback? onTextFieldFocus;

  const InputFormCard({
    super.key,
    required this.viewModel,
    this.onTextFieldFocus,
  });

  @override
  State<InputFormCard> createState() => _InputFormCardState();
}

class _InputFormCardState extends State<InputFormCard> {
  late final TextEditingController _originController;
  late final TextEditingController _destinationController;
  late final TextEditingController _consumptionController;
  late final TextEditingController _priceController;
  final FocusNode _originFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode();
  final FocusNode _consumptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  void _syncInputsWithViewModel() {
    _updateController(_originController, widget.viewModel.originText);
    _updateController(_destinationController, widget.viewModel.destinationText);
    _updateController(_consumptionController, widget.viewModel.consumptionText);
    _updateController(_priceController, widget.viewModel.priceText);
  }

  void _updateController(TextEditingController controller, String value) {
    if (controller.text != value) {
      controller.text = value;
    }
  }

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController(
      text: widget.viewModel.originText,
    );
    _destinationController = TextEditingController(
      text: widget.viewModel.destinationText,
    );
    _consumptionController = TextEditingController(
      text: widget.viewModel.consumptionText,
    );
    _priceController = TextEditingController(text: widget.viewModel.priceText);
    for (final focusNode in _textFieldFocusNodes) {
      focusNode.addListener(_handleTextFieldFocus);
    }
    widget.viewModel.addListener(_syncInputsWithViewModel);
  }

  List<FocusNode> get _textFieldFocusNodes => [
    _originFocusNode,
    _destinationFocusNode,
    _consumptionFocusNode,
    _priceFocusNode,
  ];

  void _handleTextFieldFocus() {
    if (_textFieldFocusNodes.any((focusNode) => focusNode.hasFocus)) {
      widget.onTextFieldFocus?.call();
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_syncInputsWithViewModel);
    _originController.dispose();
    _destinationController.dispose();
    _consumptionController.dispose();
    _priceController.dispose();
    for (final focusNode in _textFieldFocusNodes) {
      focusNode
        ..removeListener(_handleTextFieldFocus)
        ..dispose();
    }
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
                Container(
                  width: 8,
                  height: 8,
                  color: const Color(0xFFFF4500),
                ),
                const SizedBox(width: 8),
                Text(
                  'Dados da Viagem',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Origem (RF01)
            TextField(
              controller: _originController,
              focusNode: _originFocusNode,
              decoration: const InputDecoration(
                labelText: 'Endereço de Origem',
                hintText: 'Ex: Av. Paulista, 1000, São Paulo',
                prefixIcon: Icon(Icons.my_location, color: Color(0xFFFFB5A0)),
              ),
              onChanged: widget.viewModel.setOriginText,
              onTap: widget.onTextFieldFocus,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            // Destino (RF02)
            TextField(
              controller: _destinationController,
              focusNode: _destinationFocusNode,
              decoration: const InputDecoration(
                labelText: 'Endereço de Destino',
                hintText: 'Ex: Parque do Ibirapuera, São Paulo',
                prefixIcon: Icon(Icons.location_on, color: Color(0xFFFF5625)),
              ),
              onChanged: widget.viewModel.setDestinationText,
              onTap: widget.onTextFieldFocus,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Consumo (RF03)
                Expanded(
                  child: TextField(
                    controller: _consumptionController,
                    focusNode: _consumptionFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Consumo (km/L)',
                      hintText: 'Ex: 12.5',
                      prefixIcon: Icon(Icons.speed, color: Color(0xFFC6C6C7)),
                    ),
                    onChanged: widget.viewModel.setConsumptionText,
                    onTap: widget.onTextFieldFocus,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),

                // Preço (RF04)
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    focusNode: _priceFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Preço (R\$/L)',
                      hintText: 'Ex: 6.39',
                      prefixIcon: Icon(Icons.local_gas_station, color: Color(0xFFC6C6C7)),
                    ),
                    onChanged: widget.viewModel.setPriceText,
                    onTap: widget.onTextFieldFocus,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => widget.viewModel.calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Switch Ida e Volta (RF05)
            Material(
              color: theme.colorScheme.surfaceContainerLow,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: Color(0xFF5D4038)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Calcular Ida e Volta',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Calcula rota de retorno separadamente (RN05)',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: widget.viewModel.isRoundTrip,
                  onChanged: widget.viewModel.setIsRoundTrip,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mensagem de Erro
            if (widget.viewModel.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF93000A),
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFFFFB4AB)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFFFDAD6)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.viewModel.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFFFDAD6),
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
                        color: Colors.black,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate, color: Colors.black),
                        SizedBox(width: 8),
                        Text('CALCULAR CUSTO DA VIAGEM'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
