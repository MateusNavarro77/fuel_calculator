import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fuel_calculator/domain/models/location_point.dart';
import 'package:fuel_calculator/domain/repositories/geocoding_repository.dart';
import '../utils/debouncer.dart';

class AddressAutocompleteViewModel extends ChangeNotifier {
  final GeocodingRepository _repository;
  final Debouncer _debouncer;

  AddressAutocompleteViewModel({
    GeocodingRepository? repository,
    Future<List<LocationPoint>> Function(String query)? fetchSuggestions,
    Duration debounceDuration = const Duration(milliseconds: 400),
    Debouncer? debouncer,
  }) : _repository =
           repository ??
           (fetchSuggestions != null
               ? _CallbackGeocodingRepository(fetchSuggestions)
               : GeocodingRepository()),
       _debouncer = debouncer ?? Debouncer(duration: debounceDuration);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LocationPoint> _suggestions = const [];
  List<LocationPoint> get suggestions => List.unmodifiable(_suggestions);

  Completer<Iterable<LocationPoint>>? _pendingCompleter;
  String _lastQuery = '';
  String get currentQuery => _lastQuery;

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
      if (_suggestions.isNotEmpty) {
        _suggestions = const [];
      }
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
        final results = await _repository.fetchSuggestions(trimmed);
        if (_lastQuery == trimmed) {
          _suggestions = results;
        }
        if (!completer.isCompleted) {
          completer.complete(results);
        }
      } catch (_) {
        if (_lastQuery == trimmed) {
          _suggestions = const [];
        }
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

class _CallbackGeocodingRepository implements GeocodingRepository {
  final Future<List<LocationPoint>> Function(String query) _fetchSuggestions;

  _CallbackGeocodingRepository(this._fetchSuggestions);

  @override
  Future<List<LocationPoint>> fetchSuggestions(String query, {int limit = 5}) =>
      _fetchSuggestions(query);

  @override
  Future<LocationPoint> searchAddress(String query) async {
    final results = await _fetchSuggestions(query);
    if (results.isEmpty) {
      throw Exception('Endereço não encontrado: "$query"');
    }
    return results.first;
  }
}
