library wolvesrun.globals;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:wolvesrun/models/User.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart';

String wolvesRunServer = "https://wolvesrun.de";
bool useDarkTheme = true;

String? token;
User? user;

bool hasConnection = false;
List<ConnectivityResult> connectionTypes = [];

CachedTileProvider? cachedTileProvider;
String? temporaryPath;
String? directoryPath;
String mapProviderURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

bool recording = false;
int? runId;
int? lastRunId;

AppDatabase database = AppDatabase.instance();