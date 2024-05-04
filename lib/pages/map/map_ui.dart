import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}


class _MapUiState extends State<MapUi> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  );

  List<LatLng> path = [];

  LatLng? _currentPosition; // default starting position
  Path _path = Path();
  StreamSubscription<Position>? _positionStream;

  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position? position) {
        if (position != null) {
          path.add(LatLng(position.latitude, position.longitude));

          if(path.length == 1) {
            mapController.move(path.first, 15);
          }

          setState(() {
            _currentPosition = path.last;
            _path = Path.from(path);
            if(_path.nrOfCoordinates >= 3) {
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
            options: const MapOptions(
              maxZoom: 18,
              minZoom: 2,
              initialZoom: 2
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'de.vito.wolvesrun',
              ),
              RichAttributionWidget(
                animationConfig: const ScaleRAWA(),
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
              _currentPosition != null ? MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 16,
                    height: 16,
                    child: const FlutterLogo(),
                  ),
                ],
              ) : Container(),
              PolylineLayer(
                  polylines: [
                    Polyline(
                      points: path,
                      strokeWidth: 4,
                      color: Colors.red,
                    )]
              )
            ],
          ),
        ],
      ),
    );
  }
}
