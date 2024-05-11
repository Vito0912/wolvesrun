library wolvesrun.globals;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:wolvesrun/models/User.dart';

String wolvesRunServer = "https://wolvesrun.de";
bool useDarkTheme = true;

String? token;
User? user;

bool hasConnection = false;
List<ConnectivityResult> connectionTypes = [];

CachedTileProvider? cachedTileProvider;
String? temporaryPath;
String mapProviderURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";