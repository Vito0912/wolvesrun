import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/services/network/ApiHeaders.dart';
import 'package:wolvesrun/services/network/ApiPaths.dart';
import 'package:wolvesrun/services/network/database/DB.dart';

class HealthDB extends DB {
  static Future<http.Response> health({
    required BuildContext? context,
    bool hideError = false,
  }) async {
    return await DB.request(
      method: DBMethod.GET,
      url: ApiPaths.health,
      headers: ApiHeaders.headers,
      context: context,
      header: 'Runs',
      hideError: true,
      timeout: const Duration(seconds: 2),
    );
  }
}
