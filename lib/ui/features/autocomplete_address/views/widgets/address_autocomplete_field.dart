import 'package:flutter/material.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/ui/core/theme.dart';
import 'package:fuel_calculator/ui/features/autocomplete_address/view_models/address_autocomplete_view_model.dart';

class AddressAutocompleteField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final TextEditingController controller;
  final FocusNode focusNode;
  final AddressAutocompleteViewModel? viewModel;
  final Future<List<LocationPoint>> Function(String query)? fetchSuggestions;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final Duration debounceDuration;

  const AddressAutocompleteField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.prefixIconColor,
    required this.controller,
    required this.focusNode,
    this.viewModel,
    this.fetchSuggestions,
    required this.onChanged,
    this.onTap,
    this.textInputAction,
    this.debounceDuration = const Duration(milliseconds: 400),
  }) : assert(
         viewModel != null || fetchSuggestions != null,
         'Either viewModel or fetchSuggestions must be provided.',
       );

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  late final AddressAutocompleteViewModel _viewModel;
  late final bool _ownsViewModel;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
      _ownsViewModel = false;
    } else {
      _viewModel = AddressAutocompleteViewModel(
        fetchSuggestions: widget.fetchSuggestions!,
        debounceDuration: widget.debounceDuration,
      );
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return RawAutocomplete<LocationPoint>(
              textEditingController: widget.controller,
              focusNode: widget.focusNode,
              displayStringForOption: (LocationPoint option) =>
                  option.addressName,
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _viewModel.getSuggestions(textEditingValue.text);
              },
              onSelected: (LocationPoint option) {
                widget.controller.text = option.addressName;
                widget.onChanged(option.addressName);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: widget.labelText,
                        hintText: widget.hintText,
                        prefixIcon: Icon(
                          widget.prefixIcon,
                          color: widget.prefixIconColor,
                        ),
                        suffixIcon: _viewModel.isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(
                                  AppSpacing.stackSm + AppSpacing.unit,
                                ),
                                child: SizedBox(
                                  width: AppSpacing.stackMd,
                                  height: AppSpacing.stackMd,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : (controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        controller.clear();
                                        widget.onChanged('');
                                      },
                                    )
                                  : null),
                      ),
                      onChanged: widget.onChanged,
                      onTap: widget.onTap,
                      textInputAction: widget.textInputAction,
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    color: theme.colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                widget.prefixIcon,
                                size: 18,
                                color: widget.prefixIconColor,
                              ),
                              title: Text(
                                option.addressName,
                                style: theme.textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
