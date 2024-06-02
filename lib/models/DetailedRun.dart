import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;

class RunDetailed {
  Data? data;

  RunDetailed({this.data});

  RunDetailed.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? description;
  int? type;
  double? totalDistance;
  double? totalAscent;
  double? totalDescent;
  int? startTime;
  int? endTime;
  int? duration;
  double? maxSpeed;
  double? avgSpeed;
  double? minutesPerKm;
  List<Positions>? positions;
  db.SyncStatus? syncStatus;

  Data(
      {this.name,
      this.description,
      this.type,
      this.totalDistance,
      this.totalAscent,
      this.totalDescent,
      this.startTime,
      this.endTime,
      this.duration,
      this.maxSpeed,
      this.avgSpeed,
      this.minutesPerKm,
      this.positions,
      this.syncStatus});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
    totalDistance = double.tryParse(json['total_distance'].toString());
    totalAscent = double.tryParse(json['total_ascent'].toString());
    totalDescent = double.tryParse(json['total_descent'].toString());
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    maxSpeed = double.tryParse(json['max_speed'].toString());
    avgSpeed = double.tryParse(json['avg_speed'].toString());
    minutesPerKm = double.tryParse(json['minutes_per_km'].toString());
    if (json['positions'] != null) {
      positions = <Positions>[];
      json['positions'].forEach((v) {
        positions!.add(new Positions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['total_ascent'] = this.totalAscent;
    data['total_descent'] = this.totalDescent;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['max_speed'] = this.maxSpeed;
    data['avg_speed'] = this.avgSpeed;
    data['minutes_per_km'] = this.minutesPerKm;
    if (this.positions != null) {
      data['positions'] = this.positions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void calculateLocal() {
    if (positions == null || positions!.isEmpty) return;

    double totalDistance = 0.0;
    double totalAscent = 0.0;
    double totalDescent = 0.0;
    double maxSpeed = 0.0;
    double speedSum = 0.0;
    int speedCount = 0;
    DateTime? startTime;
    DateTime? endTime;
    int duration = 0;
    double minutesPerKm = 0.0; // Initialize minutes per kilometer

    // Define the smoothing window size
    int windowSize = 5;
    List<double> altitudes = [];

    for (int index = 0; index < positions!.length; index++) {
      Positions point = positions![index];
      DateTime? timestamp = point.timestamp;
      double? speed = point.speed;

      if (index == 0 && timestamp != null) {
        startTime = timestamp;
      }

      if (timestamp != null) {
        endTime = timestamp;
      }

      if (speed != null) {
        speedSum += speed;
        double convertedSpeed = speed * 3.6; // Convert from m/s to km/h
        if (convertedSpeed > maxSpeed) {
          maxSpeed = convertedSpeed;
        }
      }

      speedCount++;

      if (point.location != null) {
        altitudes.add(point.location!.altitude!);
      }
    }

    // Apply smoothing to the altitudes
    List<double> smoothedAltitudes = [];
    for (int i = 0; i < altitudes.length; i++) {
      if (i < windowSize - 1) {
        // Not enough data points to smooth, use the original altitude
        smoothedAltitudes.add(altitudes[i]);
      } else {
        smoothedAltitudes.add(altitudes
                .sublist(i - windowSize + 1, i + 1)
                .reduce((a, b) => a + b) /
            windowSize);
      }
    }

    for (int i = 1; i < positions!.length; i++) {
      Positions previousPoint = positions![i - 1];
      Positions point = positions![i];

      if (previousPoint.location != null && point.location != null) {
        double lat1 = previousPoint.location!.latLng!.latitude;
        double lon1 = previousPoint.location!.latLng!.longitude;

        double lat2 = point.location!.latLng!.latitude;
        double lon2 = point.location!.latLng!.longitude;

        if (lat1 != lat2 || lon1 != lon2) {
          double theta = lon1 - lon2;
          double dist = sin(degToRad(lat1)) * sin(degToRad(lat2)) +
              cos(degToRad(lat1)) * cos(degToRad(lat2)) * cos(degToRad(theta));
          dist = acos(min(1, max(-1, dist)));
          dist = radToDeg(dist);
          double miles = dist * 60 * 1.1515;
          double distance = miles * 1.609344; // Convert miles to kilometers

          totalDistance += distance;

          double alt1 = smoothedAltitudes[i - 1];
          double alt2 = smoothedAltitudes[i];

          double altitudeChange = alt2 - alt1;
          if (altitudeChange > 0) {
            totalAscent += altitudeChange;
          } else if (altitudeChange < 0) {
            totalDescent -= altitudeChange;
          }
        }
      }
    }

    if (startTime != null && endTime != null) {
      duration = endTime.difference(startTime).inSeconds;
    }
    double avgSpeedKmh = 0;
    double avgSpeedTmp;

    if (duration > 0 && speedCount > 0) {
      avgSpeedTmp = (speedSum / speedCount); // average speed in m/s
      avgSpeedKmh = avgSpeedTmp * 3.6; // Convert m/s to km/h
      if (totalDistance > 0) {
        minutesPerKm = (duration / 60) / totalDistance;
      }
      avgSpeedTmp = avgSpeedKmh;
    } else {
      avgSpeedTmp = 0;
      avgSpeedKmh = 0;
      minutesPerKm = 0;
    }

    // Update the properties of the Data object
    this.totalDistance = totalDistance;
    this.totalAscent = totalAscent;
    this.totalDescent = totalDescent;
    this.startTime = startTime == null
        ? 0
        : (startTime.millisecondsSinceEpoch / 1000).round();
    this.endTime =
        endTime == null ? 0 : (endTime.millisecondsSinceEpoch / 1000).round();
    this.duration = duration;
    this.maxSpeed = maxSpeed;
    this.avgSpeed = avgSpeedTmp;
    this.minutesPerKm = minutesPerKm;
  }

  double degToRad(double deg) {
    return deg * (pi / 180.0);
  }

  double radToDeg(double rad) {
    return rad * (180.0 / pi);
  }
}

class Positions {
  Location? location;
  double? speed;
  DateTime? timestamp;

  Positions({this.location, this.speed, this.timestamp});

  Positions.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Location {
  String? type;
  LatLng? latLng;
  double? altitude;

  Location({this.type, this.latLng, this.altitude});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    List<double> _tmp = json['coordinates'].cast<double>();
    latLng = LatLng(_tmp[1], _tmp[0]);
    altitude = json['altitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = [this.latLng!.longitude, this.latLng!.latitude];
    return data;
  }
}
