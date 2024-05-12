import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wolvesrun/models/User.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:wolvesrun/services/network/ApiHeaders.dart';
import 'package:wolvesrun/services/network/ApiPaths.dart';

class MainUtil {
  static Future<User?> retrieveUserInformation() async {
    if (globals.hasConnection && globals.token != null) {
      http.Response response = await http.get(
          Uri.parse(ApiPaths.userInformation),
          headers: ApiHeaders.headersWithToken);
      print(response.body);
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    }

    return null;
  }

  static Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    globals.connectionTypes = connectivityResult;

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return hasRealConnection();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return hasRealConnection();
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return hasRealConnection();
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return hasRealConnection();
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      return false;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return false;
  }

  static Future<bool> hasRealConnection() async {
    try {
      final result =
          await InternetAddress.lookup(Uri.parse(globals.wolvesRunServer).host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static Future<CachedTileProvider> getCachedTileProvider() async {
    String tmpPath = (await getTemporaryDirectory()).path;

    globals.temporaryPath = tmpPath;

    globals.cachedTileProvider = CachedTileProvider(
        store: DbCacheStore(databasePath: tmpPath, databaseName: 'TileCache'));

    return globals.cachedTileProvider!;
  }

  static Future<void> setAppDocumentDirectory() async {
    String dirPath = (await getApplicationDocumentsDirectory()).path;
    globals.directoryPath = dirPath;
  }
}
