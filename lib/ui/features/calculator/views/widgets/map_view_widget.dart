import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fuel_calculator/ui/core/theme.dart';
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
  static const _routePadding = AppSpacing.gutter;
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

        // Rota de ida (Heat Orange)
        polylines.add(
          Polyline(
            points: outboundPoints,
            strokeWidth: 5.0,
            color: AppColors.heatOrange,
          ),
        );

        // Marcador Origem (Apex Primary Light)
        markers.add(
          Marker(
            point: widget.tripResult!.originPoint.toLatLng(),
            width: AppSpacing.margin,
            height: AppSpacing.margin,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        );

        // Marcador Destino (Apex Heat Container)
        markers.add(
          Marker(
            point: widget.tripResult!.destinationPoint.toLatLng(),
            width: AppSpacing.margin,
            height: AppSpacing.margin,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                border: Border.all(color: AppColors.primaryContainer, width: 2),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primaryContainer,
                size: 24,
              ),
            ),
          ),
        );
      }

      if (returnPoints != null && returnPoints.isNotEmpty) {
        // Rota de volta (Secondary Carbon/Heat Variant)
        polylines.add(
          Polyline(
            points: returnPoints,
            strokeWidth: 4.0,
            color: AppColors.secondary,
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
