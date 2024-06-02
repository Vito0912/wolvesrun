import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolvesrun/models/BetterPosition.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/models/arguments/StartRunDialogResult.dart';
import 'package:wolvesrun/pages/map/TopNotch.dart';
import 'package:wolvesrun/pages/map/run/StartRunDialog.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;
import 'package:wolvesrun/services/network/database/SpawnResourceDB.dart';
import 'package:wolvesrun/util/LocationUtil.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/services/network/database/PositionDB.dart'
    as position_db;
import 'package:wolvesrun/util/Preferences.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> {
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );

  bool _moveWithCompass = false;

  List<Tuple<int, int>> fetchedGrids = [];

  List<BetterPosition> path = [];

  BetterPosition? _currentPosition; // default starting position
  final CachedTileProvider _cachedTileProvider = globals.cachedTileProvider!;
  Path _path = Path();
  StreamSubscription<Position>? _positionStream;
  bool _firstPosition = true;

  MapController mapController = MapController();
  final List<Marker> _markerList = [];

  @override
  void initState() {
    super.initState();

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      if (position != null) {
        await _handlePositionUpdate(position);
      }
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(maxZoom: 18, minZoom: 2, initialZoom: 2),
            children: [
              TileLayer(
                urlTemplate: globals.mapProviderURL,
                userAgentPackageName: 'de.vito.wolvesrun',
                tileProvider: _cachedTileProvider,
              ),
              _currentPosition != null
                  ? MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentPosition!.latLng,
                          width: 16,
                          height: 16,
                          child: StreamBuilder(
                              stream: FlutterCompass.events,
                              builder: (context, snapshot) {

                                double angle = ((snapshot.connectionState ==
                                    ConnectionState.waiting)
                                    ? _currentPosition!.heading
                                    : snapshot.data!.heading)! *
                                    3.14159265359 /
                                    180;

                                if(_moveWithCompass) mapController.rotate(angle);

                                return Transform.rotate(
                                  angle: angle,
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.blueAccent,
                                  ),
                                );
                              }),
                        ),
                        ..._markerList
                      ],
                    )
                  : Container(),
              PolylineLayer(polylines: [
                Polyline(
                  points: _path.coordinates,
                  strokeWidth: 4,
                  color: Colors.red,
                )
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichAttributionWidget(
                    animationConfig: const ScaleRAWA(),
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 52,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: !globals.recording
                            ? IconButton(
                                iconSize: 48,
                                icon:
                                    const Icon(Icons.add_circle_outline_outlined),
                                onPressed: () async {
                                  StartRunDialogResult result =
                                      await StartRunDialog.show(context);
                                  if (result.start) {
                                    globals.recording = true;
                                    globals.runId = (globals.lastRunId ?? 0) + 1;
                                    globals.lastRunId = globals.runId;
                                    SP().updateInt('lastRunId', globals.runId!);
                                    _insertRun(result.activity);
                                    _changePositionStream(result.precision);
                                    LocationUtil.enableBackgroundLocation(
                                        result.precision);
                                  }
                                },
                              )
                            : IconButton(
                                iconSize: 48,
                                icon: const Icon(
                                    Icons.pause_circle_outline_outlined),
                                onPressed: () async {
                                  LocationUtil.disableBackgroundLocation();
                                  globals.recording = false;
                                  path = [];
                                  _path = Path();
                                  globals.runId = null;
                                  setState(() {});
                                },
                              ),
                      ),
                      SizedBox(
                        height: 52,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.rotate_right_outlined),
                        onPressed: () {
                          _moveWithCompass = !_moveWithCompass;
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.outlined_flag),
                        onPressed: () {
                          mapController.move(_currentPosition!.latLng, 16);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.zoom_out),
                        onPressed: () {
                          mapController.move(mapController.center, mapController.zoom - 1);
                        },
                      ),
                    ],
                  )
                ],
              ),
              TopNotch(
                  distance: _path.distance.toStringAsFixed(2),
                  realDistance: BetterPosition.calculateTotalDistance(path)
                      .toStringAsFixed(2),
                  duration: BetterPosition.calculateTotalTimeAndFormat(path),
                  waypoints: '${_path.coordinates.length}/${path.length}',
                  position:
                      '${_currentPosition?.latLng.latitude.toStringAsFixed(6)}, ${_currentPosition?.latLng.longitude.toStringAsFixed(6)}')
            ],
          ),
        ],
      ),
    );
  }

  _changePositionStream(int precision) {
    _positionStream?.cancel();

    LocationAccuracy? accuracy;

    switch (precision) {
      case 0:
        accuracy = LocationAccuracy.low;
        break;
      case 1:
        accuracy = LocationAccuracy.medium;
        break;
      case 2:
        accuracy = LocationAccuracy.bestForNavigation;
        break;
      case 3:
        accuracy = LocationAccuracy.bestForNavigation;
        break;
    }

    locationSettings = LocationSettings(
      accuracy: accuracy!,
      distanceFilter: 0,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      if (position != null) {
        await _handlePositionUpdate(position);
      }
    });
  }

  _handlePositionUpdate(Position position) async {
    if (_firstPosition) {
      mapController.move(LatLng(position.latitude, position.longitude), 15);
      _firstPosition = false;
      http.Response spawn = await SpawnResourceDB.images(context: context);
      if (spawn.statusCode == 200) {
        dynamic test = await jsonDecode(spawn.body);
        test.forEach((element) async {
          String correctedBase64String =
              element['image'].replaceAll('\\/', '/');
          Uint8List imageBytes = base64Decode(correctedBase64String);
          globals.resourceImages[element['id']] = Image.memory(imageBytes);
        });
      } else {
        print(spawn.body);
      }
    }

    _currentPosition =
        BetterPosition.fromPosition(position: position, runId: 1, userId: 1);

    Tuple<int, int> grid = LocationUtil.getGrid(_currentPosition!.latLng);

    if (globals.hasConnection && !fetchedGrids.contains(grid)) {
      fetchedGrids.add(grid);
      http.Response response = await SpawnResourceDB.getResources(
          x: grid.x, y: grid.y, context: context, activityType: 2);
      if (response.statusCode == 200) {
        dynamic resources = await jsonDecode(response.body);
        fetchedGrids.remove(grid);
        if(fetchedGrids.contains(grid)) return;
        resources['data']['grids'].forEach((grid) {
          fetchedGrids.add(Tuple(grid[0], grid[1]));
        });
        resources['response']['data'].forEach((element) {
          print(element);
          _markerList.add(Marker(
            point: LatLng(element['location']['coordinates'][1], element['location']['coordinates'][0]),
            width: 32,
            height: 32,
            rotate: true,
            child: InkWell(
                onTap: () {
                  print(element['resource']['id']);
                },
                child: globals.resourceImages[element['resource']['id']] ??
                    const Icon(Icons.error)),
          ));
        });
      } else {
        fetchedGrids.remove(grid);
      }
    }

    if (globals.recording && globals.runId != null) {
      await _handleRecordingPosition(position);
    }

    setState(() {});
  }

  _handleRecordingPosition(Position position) async {
    path.add(BetterPosition.fromPosition(
        position: position, runId: globals.runId!, userId: 2));
    if (path.length == 1) {}

    _path = Path.from(path.map((position) => position.latLng).toList());
    if (_path.nrOfCoordinates >= 3) {
      const double stepDistance = 8;
      if (_path.distance >= stepDistance * 2.0) {
        _path = _path.equalize(stepDistance, smoothPath: true);
      }
    }

    bool uploaded = false;

    if (globals.hasConnection) {
      http.Response res = await position_db.PositionDB.add(
          context: context, position: position, runId: globals.runId!);

      if (res.statusCode == 200 || res.statusCode == 201) {
        path.last.uploaded = true;
        uploaded = true;
      }
    }

    drift.Value<int?> userId = drift.Value(globals.user?.userId);

    db.AppDatabase dbi = globals.database;
    await dbi.into(dbi.positions).insert(db.PositionsCompanion.insert(
          runId: globals.runId!,
          userId: userId,
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: drift.Value(position.altitude),
          speed: drift.Value(position.speed),
          accuracy: drift.Value(position.accuracy),
          heading: drift.Value(int.tryParse(position.heading.toString())),
          timestamp: position.timestamp,
          uploaded: drift.Value(uploaded),
        ));
  }

  _insertRun(int type) {
    db.AppDatabase dbi = globals.database;
    dbi.into(dbi.runs).insert(db.RunsCompanion.insert(
        userId: drift.Value(globals.user?.userId),
        name: 'Run ${globals.runId}',
        description: 'Run ${globals.runId}',
        type: type,
        updatedAt: drift.Value(DateTime.now()),
        createdAt: drift.Value(DateTime.now()),
        id: drift.Value(globals.runId!)));
  }

  _handleOnlinePosition(Position position) {}
}
