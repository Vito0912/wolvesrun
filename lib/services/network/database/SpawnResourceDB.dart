import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/services/network/ApiHeaders.dart';
import 'package:wolvesrun/services/network/ApiPaths.dart';
import 'package:wolvesrun/services/network/database/DB.dart';

class SpawnResourceDB extends DB {
  static Future<http.Response> images({
    required BuildContext? context,
    bool hideError = false,
  }) async {
    return await DB.request(
      method: DBMethod.GET,
      url: ApiPaths.resourceImages,
      headers: ApiHeaders.headersWithToken ?? ApiHeaders.headers,
      context: context,
      header: 'Resource Images',
      hideError: true,
    );
  }

  static Future<http.Response> getResources({
    required int x,
    required int y,
    required int activityType,
    required BuildContext? context,
    bool hideError = false,
  }) async {
    return await DB.request(
      method: DBMethod.GET,
      url: ApiPaths.itemPoints(x, y, activityType),
      headers: ApiHeaders.headersWithToken ?? ApiHeaders.headers,
      context: context,
      header: 'Resources',
      hideError: true,
    );
  }
}
