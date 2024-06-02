import 'package:wolvesrun/services/database/AppDatabase.dart' as db;

class Runs {
  List<Data> data;
  Links? links;
  Meta? meta;

  Runs({
    required this.data,
    this.links,
    this.meta,
  });

  factory Runs.fromJson(Map<String, dynamic> json) => Runs(
        data: (json['data'] as List).map((x) => Data.fromJson(x)).toList(),
        links: Links.fromJson(json['links']),
        meta: Meta.fromJson(json['meta']),
      );

  Runs copyWith({
    List<Data>? data,
    Links? links,
    Meta? meta,
  }) =>
      Runs(
        data: data ?? this.data,
        links: links ?? this.links,
        meta: meta ?? this.meta,
      );
}

class Data {
  DateTime createdAt;
  DateTime? updatedAt;
  int id;
  String name;
  dynamic description;
  int type;
  double? totalDistance;
  double? totalAscent;
  double? totalDescent;
  DateTime? startTime;
  DateTime? endTime;
  int? duration;
  double? maxSpeed;
  double? avgSpeed;
  double? minutesPerKm;
  int? userId;
  bool online;
  bool local;
  db.SyncStatus? syncStatus;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'],
      type: json['type'] as int,
      totalDistance: json['total_distance'] != null
          ? (json['total_distance'] as num).toDouble()
          : null,
      totalAscent: json['total_ascent'] != null
          ? (json['total_ascent'] as num).toDouble()
          : null,
      totalDescent: json['total_descent'] != null
          ? (json['total_descent'] as num).toDouble()
          : null,
      startTime: json['start_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['start_time'] as int) * 1000)
          : null,
      endTime: json['end_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['end_time'] as int) * 1000)
          : null,
      duration: json['duration'] as int?,
      maxSpeed: json['max_speed'] != null
          ? (json['max_speed'] as num).toDouble()
          : null,
      avgSpeed: json['avg_speed'] != null
          ? (json['avg_speed'] as num).toDouble()
          : null,
      minutesPerKm: json['minutes_per_km'] != null
          ? (json['minutes_per_km'] as num).toDouble()
          : null,
      userId: json['user_id'] as int?,
    );
  }

  Data({
    required this.createdAt,
    this.updatedAt,
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.totalDistance,
    this.totalAscent,
    this.totalDescent,
    this.startTime,
    this.endTime,
    this.duration,
    this.maxSpeed,
    this.avgSpeed,
    this.minutesPerKm,
    this.userId,
    this.online = false,
    this.local = false,
    this.syncStatus,
  });

  Data copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? name,
    dynamic description,
    int? type,
    double? totalDistance,
    double? totalAscent,
    double? totalDescent,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    double? maxSpeed,
    double? avgSpeed,
    double? minutesPerKm,
    int? userId,
  }) =>
      Data(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        type: type ?? this.type,
        totalDistance: totalDistance ?? this.totalDistance,
        totalAscent: totalAscent ?? this.totalAscent,
        totalDescent: totalDescent ?? this.totalDescent,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        duration: duration ?? this.duration,
        maxSpeed: maxSpeed ?? this.maxSpeed,
        avgSpeed: avgSpeed ?? this.avgSpeed,
        minutesPerKm: minutesPerKm ?? this.minutesPerKm,
        userId: userId ?? this.userId,
      );
}

class Links {
  String first;
  String last;
  dynamic prev;
  dynamic next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json['first'],
        last: json['last'],
        prev: json['prev'],
        next: json['next'],
      );

  Links copyWith({
    String? first,
    String? last,
    dynamic prev,
    dynamic next,
  }) =>
      Links(
        first: first ?? this.first,
        last: last ?? this.last,
        prev: prev ?? this.prev,
        next: next ?? this.next,
      );
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['current_page'],
        from: json['from'],
        lastPage: json['last_page'],
        links: List<Link>.from(json['links'].map((x) => Link.fromJson(x))),
        path: json['path'],
        perPage: json['per_page'],
        to: json['to'],
        total: json['total'],
      );

  Meta copyWith({
    int? currentPage,
    int? from,
    int? lastPage,
    List<Link>? links,
    String? path,
    int? perPage,
    int? to,
    int? total,
  }) =>
      Meta(
        currentPage: currentPage ?? this.currentPage,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        links: links ?? this.links,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        to: to ?? this.to,
        total: total ?? this.total,
      );
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json['url'],
        label: json['label'],
        active: json['active'],
      );

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      Link(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );
}
