import 'package:latlong2/latlong.dart';

class LocationPoint {
  final String addressName;
  final double latitude;
  final double longitude;

  const LocationPoint({
    required this.addressName,
    required this.latitude,
    required this.longitude,
  });

  LatLng toLatLng() => LatLng(latitude, longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPoint &&
          runtimeType == other.runtimeType &&
          addressName == other.addressName &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode =>
      addressName.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
