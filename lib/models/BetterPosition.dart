import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class BetterPosition {
  final int runId;
  final int userId;
  final LatLng latLng;
  final DateTime timestamp;
  final double accuracy;
  final double altitude;
  final double heading;
  final double speed;
  final double speedAccuracy;
  final double altitudeAccuracy;

  // Existing detailed constructor remains unchanged, assuming all fields are initialized directly
  const BetterPosition({
    required this.runId,
    required this.userId,
    required this.latLng,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.altitudeAccuracy,
    required this.heading,
    required this.speed,
    required this.speedAccuracy
  });

  // Corrected constructor that takes a Position object and two integers
  BetterPosition.fromPosition({
    required Position position,
    required this.runId,
    required this.userId,
  }) : latLng = LatLng(position.latitude, position.longitude),
        timestamp = position.timestamp,
        accuracy = position.accuracy,
        altitude = position.altitude,
        altitudeAccuracy = position.altitudeAccuracy,
        heading = position.heading,
        speed = position.speed,
        speedAccuracy = position.speedAccuracy;
}
