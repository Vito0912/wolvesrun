import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wolvesrun/generated/l10n.dart';

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

}

enum BackgroundPrecision {
  HIGH,
  MEDIUM,
  LOW,
  BATTERY_SAVING
}