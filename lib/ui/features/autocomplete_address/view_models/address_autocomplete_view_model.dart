import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import '../utils/debouncer.dart';

class AddressAutocompleteViewModel extends ChangeNotifier {
  final Future<List<LocationPoint>> Function(String query) fetchSuggestions;
  final Debouncer _debouncer;

  AddressAutocompleteViewModel({
    required this.fetchSuggestions,
    Duration debounceDuration = const Duration(milliseconds: 400),
    Debouncer? debouncer,
  }) : _debouncer = debouncer ?? Debouncer(duration: debounceDuration);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Completer<Iterable<LocationPoint>>? _pendingCompleter;
  String _lastQuery = '';

  void cancelPending() {
    if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
      _pendingCompleter!.complete(const []);
    }
    _pendingCompleter = null;
  }

  Future<Iterable<LocationPoint>> getSuggestions(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 3) {
      _debouncer.cancel();
      cancelPending();
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
      return const [];
    }

    cancelPending();
    _lastQuery = trimmed;
    final completer = Completer<Iterable<LocationPoint>>();
    _pendingCompleter = completer;

    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    _debouncer.run(() async {
      if (_lastQuery != trimmed) return;
      try {
        final results = await fetchSuggestions(trimmed);
        if (!completer.isCompleted) {
          completer.complete(results);
        }
      } catch (_) {
        if (!completer.isCompleted) {
          completer.complete(const []);
        }
      } finally {
        if (_lastQuery == trimmed) {
          _isLoading = false;
          notifyListeners();
        }
      }
    });

    return completer.future;
  }

  @override
  void dispose() {
    _debouncer.dispose();
    cancelPending();
    super.dispose();
  }
}
