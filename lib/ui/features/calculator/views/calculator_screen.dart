import 'package:flutter/material.dart';
import 'package:fuel_calculator/ui/core/theme.dart';
import '../../../../domain/repositories/fuel_calculator_repository.dart';
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
  static const _maximumSheetSize = 0.85;

  final CalculatorViewModel _viewModel = CalculatorViewModel();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  TripCalculationResult? _lastTripResult;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_handleCalculationUpdate);
  }

  void _handleCalculationUpdate() {
    final tripResult = _viewModel.tripResult;

    if (tripResult == null) {
      _lastTripResult = null;
      return;
    }

    if (identical(tripResult, _lastTripResult)) return;
    _lastTripResult = tripResult;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _sheetController.isAttached) {
        _sheetController.animateTo(
          0.6,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _expandSheetForTextInput() {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        _maximumSheetSize,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleCalculationUpdate);
    _viewModel.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            //foregroundColor: Theme.of(context).colorScheme.primary,
            //surfaceTintColor: Colors.transparent,
            //scrolledUnderElevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Limpar formulário',
                onPressed: _viewModel.reset,
              ),
            ],
          ),
          body: Stack(
            children: [
              // Exibição do Mapa com a Rota (RF06)
              Positioned.fill(
                child: MapViewWidget(
                  tripResult: _viewModel.tripResult,
                  enableTileLayer: widget.enableTileLayer,
                  bottomOverlayFraction: 0.6,
                ),
              ),
              DraggableScrollableSheet(
                controller: _sheetController,
                snap: true,
                maxChildSize: _maximumSheetSize,
                minChildSize: 0.3,
                initialChildSize: 0.4,
                snapSizes: [0.3, 0.4, 0.6],
                builder: (context, scrollController) {
                  return Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    shape: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _DragHandleHeaderDelegate(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.viewInsetsOf(context).bottom +
                                  AppSpacing.stackMd,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                // Formulário de Entrada (RF01 - RF05)
                                InputFormCard(
                                  viewModel: _viewModel,
                                  onTextFieldFocus: _expandSheetForTextInput,
                                ),

                                // Card de Resultados (RF07, RF08)
                                if (_viewModel.tripResult != null)
                                  ResultCard(result: _viewModel.tripResult!),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DragHandleHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;

  const _DragHandleHeaderDelegate({required this.backgroundColor});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Container(
        width: AppSpacing.stackLg,
        height: AppSpacing.unit,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 28.0;

  @override
  double get minExtent => 28.0;

  @override
  bool shouldRebuild(covariant _DragHandleHeaderDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor;
  }
}
