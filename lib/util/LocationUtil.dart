import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wolvesrun/generated/l10n.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'dart:math' as math;

class LocationUtil {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static enableBackgroundLocation(int precision) {
    BackgroundLocation.setAndroidNotification(
      title: S.current.wolvesrunRecording,
      message: S.current.wolvesrunIsRecordingYourLocation,
      icon: "@mipmap/ic_launcher",
    );

    int intervall = 5000;
    switch (precision) {
      case 3:
        intervall = 1000;
        break;
      case 2:
        intervall = 2500;
        break;
      case 1:
        intervall = 5000;
        break;
      case 0:
        intervall = 20000;
        break;
    }

    BackgroundLocation.setAndroidConfiguration(intervall);
    BackgroundLocation.startLocationService();
  }

  static disableBackgroundLocation() {
    BackgroundLocation.stopLocationService();
  }

  static Tuple<int, int> getGrid(LatLng position) {
    final int? gridSize = globals.gridSize;
    if (gridSize == null) {
      throw Exception("Grid size is not set");
    }

    // Constants for Earth
    const double earthRadius = 6378137.0; // in meters

    // Convert latitude and longitude to meters
    double latInMeters = (position.latitude * math.pi / 180.0) * earthRadius;
    double lonInMeters = (position.longitude * math.pi / 180.0) *
        earthRadius *
        math.cos(position.latitude * math.pi / 180.0);

    // Calculate indices
    int verticalIndex = (latInMeters / gridSize).floor();
    int horizontalIndex = (lonInMeters / gridSize).floor();

    return Tuple<int, int>(verticalIndex, horizontalIndex);
  }
}

enum BackgroundPrecision { HIGH, MEDIUM, LOW, BATTERY_SAVING }

class Tuple<X, Y> {
  final X x;
  final Y y;

  Tuple(this.x, this.y);

  // Eqals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tuple<X, Y> && other.x == x && other.y == y;
  }

  @override
   int get hashCode => x.hashCode ^ y.hashCode;

  // toString
  @override
  String toString() => 'Tuple(x: $x, y: $y)';
}
