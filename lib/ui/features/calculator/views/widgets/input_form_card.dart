import 'package:flutter/material.dart';
import 'package:fuel_calculator/ui/core/theme.dart';
import '../../view_models/calculator_view_model.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/views/widgets/address_autocomplete_field.dart';

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
      margin: const EdgeInsets.all(AppSpacing.stackMd),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackMd + AppSpacing.unit),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: AppSpacing.stackSm,
                  height: AppSpacing.stackSm,
                  color: AppColors.heatOrange,
                ),
                const SizedBox(width: AppSpacing.stackSm),
                Text(
                  'Dados da Viagem',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackMd),

            // Origem (RF01)
            AddressAutocompleteField(
              controller: _originController,
              focusNode: _originFocusNode,
              labelText: 'Endereço de Origem',
              hintText: 'Ex: Av. Paulista, 1000, São Paulo',
              prefixIcon: Icons.my_location,
              prefixIconColor: theme.colorScheme.primary,
              onChanged: widget.viewModel.setOriginText,
              onTap: widget.onTextFieldFocus,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.stackSm + AppSpacing.unit),

            // Destino (RF02)
            AddressAutocompleteField(
              controller: _destinationController,
              focusNode: _destinationFocusNode,
              labelText: 'Endereço de Destino',
              hintText: 'Ex: Parque do Ibirapuera, São Paulo',
              prefixIcon: Icons.location_on,
              prefixIconColor: theme.colorScheme.primaryContainer,
              onChanged: widget.viewModel.setDestinationText,
              onTap: widget.onTextFieldFocus,
              textInputAction: TextInputAction.next,
              
            ),
            const SizedBox(height: AppSpacing.stackMd),

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
                    decoration: InputDecoration(
                      labelText: 'Consumo (km/L)',
                      hintText: 'Ex: 12.5',
                      prefixIcon: Icon(
                        Icons.speed,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    onChanged: widget.viewModel.setConsumptionText,
                    onTap: widget.onTextFieldFocus,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: AppSpacing.stackSm + AppSpacing.unit),

                // Preço (RF04)
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    focusNode: _priceFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Preço (R\$/L)',
                      hintText: 'Ex: 6.39',
                      prefixIcon: Icon(
                        Icons.local_gas_station,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    onChanged: widget.viewModel.setPriceText,
                    onTap: widget.onTextFieldFocus,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => widget.viewModel.calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackSm + AppSpacing.unit),

            // Switch Ida e Volta (RF05)
            Material(
              color: theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.stackSm + AppSpacing.unit,
                ),
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
            const SizedBox(height: AppSpacing.stackMd),

            // Mensagem de Erro
            if (widget.viewModel.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(
                  AppSpacing.stackSm + AppSpacing.unit,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  border: Border.fromBorderSide(
                    BorderSide(color: theme.colorScheme.error),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: AppSpacing.stackSm),
                    Expanded(
                      child: Text(
                        widget.viewModel.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.stackMd),
            ],

            // Botão Calcular
            ElevatedButton(
              onPressed: widget.viewModel.isLoading
                  ? null
                  : () => widget.viewModel.calculate(),
              child: widget.viewModel.isLoading
                  ? SizedBox(
                      height: AppSpacing.stackMd + AppSpacing.unit,
                      width: AppSpacing.stackMd + AppSpacing.unit,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calculate,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(width: AppSpacing.stackSm),
                        const Text('CALCULAR CUSTO DA VIAGEM'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
