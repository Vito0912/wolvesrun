import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolvesrun/models/arguments/DetailedRunArguments.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;
import 'package:wolvesrun/services/network/database/RunDB.dart';
import 'package:wolvesrun/widgets/MainAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/models/DetailedRun.dart' as model;
import 'package:wolvesrun/globals.dart' as globals;

class DetailedRun extends StatelessWidget {
  DetailedRun({super.key});

  static const routeName = '/detailedRun';
  final CachedTileProvider _cachedTileProvider = globals.cachedTileProvider!;
  model.RunDetailed? detailedRun;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as DetailedRunArguments;

    return Scaffold(
        appBar: MainAppBar(
          height: Theme.of(context).appBarTheme.toolbarHeight ?? 56,
          title: args.title,
        ),
        body: FutureBuilder(
            future: globals.database.getAllPositionsByRunId(args.runId),
            builder: (context, AsyncSnapshot<List<db.Position>> localSnapshot) {
              return FutureBuilder(
                  future: RunDB.getById(id: args.runId, context: context),
                  builder: (context, AsyncSnapshot<http.Response> snapshot) {
                    Path path = Path();
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        localSnapshot.connectionState ==
                            ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.statusCode != 200 &&
                          localSnapshot.connectionState ==
                              ConnectionState.done &&
                          localSnapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Error: ${snapshot.data!.statusCode}'),
                        );
                      }
                      detailedRun = model.RunDetailed.fromJson(
                          jsonDecode(snapshot.data!.body));
                    }

                    if (localSnapshot.connectionState == ConnectionState.done) {
                      List<model.Positions> positions = [];

                      for (db.Position position in localSnapshot.data!) {
                        positions.add(model.Positions(
                          location: model.Location(
                            type: 'Point',
                            latLng:
                                LatLng(position.latitude, position.longitude),
                            altitude: position.altitude,
                          ),
                        ));
                      }

                      detailedRun = model.RunDetailed(
                        data: model.Data(
                          name: 'Local Run - Not implemented yet',
                          description: 'Local Run - Not implemented yet',
                          totalAscent: 0,
                          totalDescent: 0,
                          startTime: 0,
                          endTime: 0,
                          duration: 0,
                          maxSpeed: 0,
                          avgSpeed: 0,
                          type: 2,
                          positions: positions,
                        ),
                      );
                    }

                    if (detailedRun != null) {
                      path = Path();
                      detailedRun!.data!.positions?.forEach((element) {
                        path.add(element.location!.latLng!);
                      });
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCameraFit: CameraFit.coordinates(
                                coordinates: path.coordinates,
                                padding: EdgeInsets.all(20),
                              ),
                            ),
                            children: [
                              TileLayer(
                                  urlTemplate: globals.mapProviderURL,
                                  userAgentPackageName: 'de.vito.wolvesrun',
                                  tileProvider: _cachedTileProvider),
                              (detailedRun != null)
                                  ? PolylineLayer(polylines: [
                                      Polyline(
                                        points: path.coordinates,
                                        strokeWidth: 4,
                                        color: Colors.red.withOpacity(0.5),
                                      )
                                    ])
                                  : const SizedBox(),
                              MarkerLayer(markers: [
                                Marker(
                                  point: path.coordinates.first,
                                  width: 16,
                                  height: 16,
                                  child: const Icon(
                                    Icons.flag_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Marker(
                                  point: path.coordinates.last,
                                  width: 16,
                                  height: 16,
                                  child: const Icon(
                                    Icons.start_rounded,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ]),
                              RichAttributionWidget(
                                animationConfig: const ScaleRAWA(),
                                attributions: [
                                  TextSourceAttribution(
                                    'OpenStreetMap contributors',
                                    onTap: () => launchUrl(Uri.parse(
                                        'https://openstreetmap.org/copyright')),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
            }));
  }
}
