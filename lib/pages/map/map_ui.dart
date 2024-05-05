import 'dart:async';

import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolvesrun/models/BetterPosition.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );

  List<BetterPosition> path = [];
  String? _temporaryPath;

  BetterPosition? _currentPosition; // default starting position
  CachedTileProvider? _cachedTileProvider;
  Path _path = Path();
  StreamSubscription<Position>? _positionStream;

  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    getPath().then((value) => setState(() {
          _temporaryPath = value;

          _cachedTileProvider = CachedTileProvider(
              store: DbCacheStore(
                  databasePath: _temporaryPath!, databaseName: 'TileCache'));
        }));

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null) {
          path.add(BetterPosition.fromPosition(
              position: position, runId: 1, userId: 1));
          print(path);
          if (path.length == 1) {
            mapController.move(path.first.latLng, 15);
          }

          setState(() {
            _currentPosition = path.last;
            _path = Path.from(path.map((position) => position.latLng).toList());
            if (_path.nrOfCoordinates >= 3) {
              const double stepDistance = 8;
              if (_path.distance >= stepDistance * 2.0) {
                _path = _path.equalize(stepDistance, smoothPath: true);
              }
            }
          });
          print(position);
        }
      },
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _cachedTileProvider?.dispose();
    super.dispose();
  }

  Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
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
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'de.vito.wolvesrun',
                tileProvider:
                    (_temporaryPath != null && _cachedTileProvider != null)
                        ? _cachedTileProvider
                        : null,
              ),
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
                                return Transform.rotate(
                                  angle: ((snapshot.connectionState ==
                                              ConnectionState.waiting)
                                          ? _currentPosition!.heading
                                          : snapshot.data!.heading)! *
                                      3.14159265359 /
                                      180,
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.blueAccent,
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : Container(),
              PolylineLayer(polylines: [
                Polyline(
                  points: _path.coordinates,
                  strokeWidth: 4,
                  color: Colors.red,
                )
              ])
            ],
          ),
        ],
      ),
    );
  }
}
