import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../domain/repositories/fuel_calculator_repository.dart';

class MapViewWidget extends StatefulWidget {
  final TripCalculationResult? tripResult;
  final bool enableTileLayer;
  final double bottomOverlayFraction;

  const MapViewWidget({
    super.key,
    this.tripResult,
    this.enableTileLayer = true,
    this.bottomOverlayFraction = 0,
  });

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget>
    with TickerProviderStateMixin {
  static const _routeAnimationDuration = Duration(milliseconds: 600);
  static const _routePadding = 24.0;
  static const _maximumRouteZoom = 16.0;

  final MapController _mapController = MapController();
  AnimationController? _cameraAnimation;

  @override
  void didUpdateWidget(covariant MapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(widget.tripResult, oldWidget.tripResult) &&
        widget.tripResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _animateToRoute(widget.tripResult!);
      });
    }
  }

  List<LatLng> _routePoints(TripCalculationResult tripResult) {
    return [
      tripResult.originPoint.toLatLng(),
      tripResult.destinationPoint.toLatLng(),
      ...tripResult.outboundRoute.polylinePoints,
      ...?tripResult.returnRoute?.polylinePoints,
    ];
  }

  void _animateToRoute(TripCalculationResult tripResult) {
    final routePoints = _routePoints(tripResult);
    if (routePoints.isEmpty) return;

    final screenSize = MediaQuery.sizeOf(context);
    final safeAreaTop = MediaQuery.paddingOf(context).top;
    final targetCamera = CameraFit.bounds(
      bounds: LatLngBounds.fromPoints(routePoints),
      padding: EdgeInsets.fromLTRB(
        _routePadding,
        safeAreaTop + kToolbarHeight + _routePadding,
        _routePadding,
        (screenSize.height * widget.bottomOverlayFraction) + _routePadding,
      ),
      maxZoom: _maximumRouteZoom,
    ).fit(_mapController.camera);

    _cameraAnimation?.dispose();
    final animationController = AnimationController(
      duration: _routeAnimationDuration,
      vsync: this,
    );
    _cameraAnimation = animationController;

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    final camera = _mapController.camera;
    final latitude = Tween<double>(
      begin: camera.center.latitude,
      end: targetCamera.center.latitude,
    );
    final longitude = Tween<double>(
      begin: camera.center.longitude,
      end: targetCamera.center.longitude,
    );
    final zoom = Tween<double>(begin: camera.zoom, end: targetCamera.zoom);

    animationController.addListener(() {
      _mapController.move(
        LatLng(latitude.evaluate(animation), longitude.evaluate(animation)),
        zoom.evaluate(animation),
        id: 'route-fit-animation',
      );
    });
    animationController.forward();
  }

  @override
  void dispose() {
    _cameraAnimation?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Default center: SP, Brazil
    LatLng initialCenter = const LatLng(-23.55052, -46.633308);
    double initialZoom = 12.0;

    final List<Polyline> polylines = [];
    final List<Marker> markers = [];

    if (widget.tripResult != null) {
      final outboundPoints = widget.tripResult!.outboundRoute.polylinePoints;
      final returnPoints = widget.tripResult!.returnRoute?.polylinePoints;

      if (outboundPoints.isNotEmpty) {
        initialCenter = outboundPoints.first;

        // Rota de ida (Azul)
        polylines.add(
          Polyline(
            points: outboundPoints,
            strokeWidth: 4.5,
            color: const Color(0xFF0284C7),
          ),
        );

        // Marcador Origem
        markers.add(
          Marker(
            point: widget.tripResult!.originPoint.toLatLng(),
            width: 40,
            height: 40,
            child: const Icon(Icons.location_on, color: Colors.green, size: 40),
          ),
        );

        // Marcador Destino
        markers.add(
          Marker(
            point: widget.tripResult!.destinationPoint.toLatLng(),
            width: 40,
            height: 40,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        );
      }

      if (returnPoints != null && returnPoints.isNotEmpty) {
        // Rota de volta (Roxa - para diferenciar de acordo com a RN05)
        polylines.add(
          Polyline(
            points: returnPoints,
            strokeWidth: 3.5,
            color: const Color(0xFF9333EA),
          ),
        );
      }
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
      ),
      children: [
        if (widget.enableTileLayer)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.fuel_calculator',
          ),
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
