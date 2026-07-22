import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../domain/repositories/fuel_calculator_repository.dart';

class MapViewWidget extends StatelessWidget {
  final TripCalculationResult? tripResult;
  final bool enableTileLayer;

  const MapViewWidget({
    super.key,
    this.tripResult,
    this.enableTileLayer = true,
  });

  @override
  Widget build(BuildContext context) {
    // Default center: SP, Brazil
    LatLng initialCenter = const LatLng(-23.55052, -46.633308);
    double initialZoom = 12.0;

    final List<Polyline> polylines = [];
    final List<Marker> markers = [];

    if (tripResult != null) {
      final outboundPoints = tripResult!.outboundRoute.polylinePoints;
      final returnPoints = tripResult!.returnRoute?.polylinePoints;

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
            point: tripResult!.originPoint.toLatLng(),
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 40,
            ),
          ),
        );

        // Marcador Destino
        markers.add(
          Marker(
            point: tripResult!.destinationPoint.toLatLng(),
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
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

    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: initialZoom,
          ),
          children: [
            if (enableTileLayer)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.fuel_calculator',
              ),
            PolylineLayer(polylines: polylines),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }
}
