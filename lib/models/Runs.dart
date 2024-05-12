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
  String avSpeed;
  String distance;
  int? userId;
  bool online = false;
  bool local = false;
  db.SyncStatus? syncStatus;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      avSpeed: json['avSpeed'],
      distance: json['distance'],
      userId: json['user_id'],
      online: true,
      local: false,
    );
  }

  Data({
    required this.createdAt,
    this.updatedAt,
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.avSpeed,
    required this.distance,
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
    String? avSpeed,
    String? distance,
    int? userId,
  }) =>
      Data(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        type: type ?? this.type,
        avSpeed: avSpeed ?? this.avSpeed,
        distance: distance ?? this.distance,
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
