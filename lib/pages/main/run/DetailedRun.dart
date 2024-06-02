import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolvesrun/models/DetailedRun.dart' as model;
import 'package:wolvesrun/models/arguments/DetailedRunArguments.dart';
import 'package:wolvesrun/states/DetailedRunState.dart';
import 'package:wolvesrun/util/IconUtil.dart';
import 'package:wolvesrun/widgets/MainAppBar.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;

class DetailedRun extends ConsumerStatefulWidget {
  final DetailedRunArguments args;
  const DetailedRun({super.key, required this.args});

  static const routeName = '/detailedRun';

  @override
  _DetailedRunState createState() => _DetailedRunState();
}

class _DetailedRunState extends ConsumerState<DetailedRun> {
  bool _isLoadingTriggered = false;
  double _mapHeight = 0.4; // Initial height factor
  final ScrollController _scrollController = ScrollController();
  Widget filler = const SizedBox();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isLoadingTriggered) {
        ref
            .read(detailedRunProvider.notifier)
            .loadDetailedRun(widget.args, context);
        _isLoadingTriggered = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      setState(() {
        double offset = _scrollController.offset;
        if (offset <= 100) {
          // Adjust the map height based on scroll offset
          double height =
              MediaQuery.of(context).size.height * (offset / 500) / 2;
          filler = SizedBox(height: height);

          double heightFactor = 0.4 - (offset / 500);
          _mapHeight = heightFactor.clamp(0.2, 0.4);
        } else {
          _mapHeight = 0.2;
        }
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final detailedRunAsyncValue = ref.watch(detailedRunProvider);

    return detailedRunAsyncValue.when(
      data: (model.RunDetailed? detailedRun) {
        if (detailedRun == null ||
            detailedRun.data!.positions == null ||
            detailedRun.data!.positions!.isEmpty) {
          return Scaffold(
            appBar: MainAppBar(
              height: Theme.of(context).appBarTheme.toolbarHeight ?? 56,
              title: widget.args.title,
            ),
            body: const Center(
              child: Text('Error: 404'),
            ),
          );
        }

        Path path = Path();
        for (var element in detailedRun.data!.positions!) {
          path.add(element.location!.latLng!);
        }
        return Scaffold(
          appBar: MainAppBar(
            height: Theme.of(context).appBarTheme.toolbarHeight ?? 56,
            title: widget.args.title,
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * _mapHeight,
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
                      tileProvider: globals.cachedTileProvider!,
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: path.coordinates,
                          strokeWidth: 4,
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
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
                      ],
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
                  ],
                ),
              ),
              detailedRun.data!.syncStatus == db.SyncStatus.partial ||
                      detailedRun.data!.syncStatus == db.SyncStatus.notSynced
                  ? const Text(
                      'You are viewing local data. The results are not that accurate and can differ from real calculations.')
                  : const SizedBox(),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScrollNotification,
                  child: ListView(
                    controller: _scrollController,
                    physics: CustomScrollPhysics(),
                    children: [
                      filler,
                      ListTile(
                        title: Text('Distance'),
                        leading: IconUtil.getIcon(
                            ActivityType.getByValue(detailedRun.data!.type)),
                        trailing: Text(
                            '${(detailedRun.data!.totalDistance?.toStringAsFixed(2))} km'),
                      ),
                      ListTile(
                        title: Text('Duration'),
                        leading: const Icon(Icons.timer),
                        trailing: Text(
                          _printDuration(
                              Duration(seconds: detailedRun.data!.duration!)),
                        ),
                      ),
                      ListTile(
                        title: Text('Ascent'),
                        leading: const Icon(Icons.arrow_drop_up_outlined),
                        trailing: Text(
                            '${(detailedRun.data!.totalAscent?.toStringAsFixed(2))} m'),
                      ),
                      ListTile(
                        title: Text('Descent'),
                        leading: const Icon(Icons.arrow_drop_down_outlined),
                        trailing: Text(
                            '${(detailedRun.data!.totalDescent?.toStringAsFixed(2))} m'),
                      ),
                      ListTile(
                        title: Text('Pace'),
                        leading: const Icon(Icons.directions_run),
                        trailing: Text(
                          '${convertMinutesToMMSS(detailedRun.data!.minutesPerKm ?? 0)} min/km',
                        ),
                      ),
                      ListTile(
                        title: Text('Max Speed'),
                        leading: const Icon(Icons.speed),
                        trailing: Text(
                            '${(detailedRun.data!.maxSpeed?.toStringAsFixed(2))} km/h'),
                      ),
                      ListTile(
                        title: Text('Avg Speed'),
                        leading: const Icon(Icons.speed),
                        trailing: Text(
                            '${(detailedRun.data!.avgSpeed?.toStringAsFixed(2))} km/h'),
                      ),
                      ListTile(
                        title: Text('Start Time'),
                        leading: const Icon(Icons.timer),
                        trailing: Text(DateFormat('yyyy-MM-dd HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                (detailedRun.data!.startTime ?? 0) * 1000))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: MainAppBar(
          height: Theme.of(context).appBarTheme.toolbarHeight ?? 56,
          title: widget.args.title,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: MainAppBar(
          height: Theme.of(context).appBarTheme.toolbarHeight ?? 56,
          title: widget.args.title,
        ),
        body: Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}

String _printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

String _printDurationMinutes(Duration? duration) {
  if (duration == null) {
    return '0:00';
  }
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inSeconds.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Adjust the friction value to control the scroll speed
    const double friction = 0.001;
    return super.createBallisticSimulation(position, velocity * friction);
  }
}

String convertMinutesToMMSS(double minutes) {
  int mins = minutes.floor();
  int secs = ((minutes - mins) * 60).round();

  String formattedMins = mins.toString().padLeft(2, '0');
  String formattedSecs = secs.toString().padLeft(2, '0');

  return '$formattedMins:$formattedSecs';
}
