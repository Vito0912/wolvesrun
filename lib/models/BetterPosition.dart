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


  static double calculateTotalDistance(List<BetterPosition> positions) {
    const Distance distance = Distance();
    double totalDistance = 0.0;

    for (int i = 0; i < positions.length - 1; i++) {
      totalDistance += distance(
        positions[i].latLng,
        positions[i + 1].latLng,
      );
    }

    return totalDistance;
  }

  static String calculateTotalTimeAndFormat(List<BetterPosition> positions) {
    if (positions.isEmpty || positions.length < 2) {
      return "No enough data to calculate duration";
    }

    DateTime startTime = positions.first.timestamp;
    DateTime endTime = positions.last.timestamp;
    Duration totalDuration = endTime.difference(startTime);

    return formatDuration(totalDuration);
  }

  static String formatDuration(Duration duration) {
    return '${duration.inHours} hours, ${duration.inMinutes.remainder(60)} minutes, ${duration.inSeconds.remainder(60)} seconds';
  }
}
