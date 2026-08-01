import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/ui/core/utils/debouncer.dart';

class AddressAutocompleteField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<List<LocationPoint>> Function(String query) fetchSuggestions;
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
    required this.fetchSuggestions,
    required this.onChanged,
    this.onTap,
    this.textInputAction,
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  late final Debouncer _debouncer;
  bool _isLoading = false;
  Completer<Iterable<LocationPoint>>? _pendingCompleter;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(duration: widget.debounceDuration);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _cancelPending();
    super.dispose();
  }

  void _cancelPending() {
    if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
      _pendingCompleter!.complete(const []);
    }
    _pendingCompleter = null;
  }

  Future<Iterable<LocationPoint>> _getSuggestions(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 3) {
      _debouncer.cancel();
      _cancelPending();
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
      return const [];
    }

    _cancelPending();
    _lastQuery = trimmed;
    final completer = Completer<Iterable<LocationPoint>>();
    _pendingCompleter = completer;

    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    _debouncer.run(() async {
      if (_lastQuery != trimmed) return;
      try {
        final results = await widget.fetchSuggestions(trimmed);
        if (!completer.isCompleted) {
          completer.complete(results);
        }
      } catch (_) {
        if (!completer.isCompleted) {
          completer.complete(const []);
        }
      } finally {
        if (mounted && _lastQuery == trimmed) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<LocationPoint>(
          textEditingController: widget.controller,
          focusNode: widget.focusNode,
          displayStringForOption: (LocationPoint option) => option.addressName,
          optionsBuilder: (TextEditingValue textEditingValue) {
            return _getSuggestions(textEditingValue.text);
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
                prefixIcon: Icon(widget.prefixIcon, color: widget.prefixIconColor),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
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
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF5D4038), width: 1),
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
  }
}
