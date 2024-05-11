import 'package:latlong2/latlong.dart';

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
  double? totalAscent;
  double? totalDescent;
  int? startTime;
  int? endTime;
  int? duration;
  double? maxSpeed;
  double? avgSpeed;
  double? minutesPerKm;
  List<Positions>? positions;

  Data(
      {this.name,
        this.description,
        this.type,
        this.totalAscent,
        this.totalDescent,
        this.startTime,
        this.endTime,
        this.duration,
        this.maxSpeed,
        this.avgSpeed,
        this.minutesPerKm,
        this.positions});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
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
}

class Positions {
  Location? location;

  Positions({this.location});

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
