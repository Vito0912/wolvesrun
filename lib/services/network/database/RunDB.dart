import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/services/network/ApiHeaders.dart';
import 'package:wolvesrun/services/network/ApiPaths.dart';
import 'package:wolvesrun/services/network/database/DB.dart';

class RunDB extends DB {
  static Future<http.Response> get({
    required BuildContext? context,
    bool hideError = false,
  }) async {
    return await DB.request(
      method: DBMethod.GET,
      url: ApiPaths.runs,
      headers: ApiHeaders.headersWithToken,
      context: context,
      header: 'Runs',
      hideError: true,
    );
  }

  static Future<http.Response> getById({
    required int id,
    required BuildContext? context,
  }) async {
    return await DB.request(
      method: DBMethod.GET,
      url: ApiPaths.run(id),
      headers: ApiHeaders.headersWithToken,
      context: context,
      header: 'Run',
    );
  }
}
