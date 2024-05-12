import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/generated/l10n.dart';
import 'package:wolvesrun/services/network/ApiHeaders.dart';
import 'package:wolvesrun/services/network/ApiPaths.dart';
import 'package:wolvesrun/services/network/database/DB.dart';

class PositionDB extends DB {
  static Future<http.Response> add({
    required BuildContext context,
    required Position position,
    required int runId,
  }) async {

    Map<String, dynamic> body = {
      'lat': position.latitude.toString(),
      'lng': position.longitude.toString(),
      'accuracy': position.accuracy.toString(),
      'altitude': position.altitude.toString(),
      'heading': int.tryParse(position.heading.toString()),
      'speed': position.speed.toString(),
      'timestamp': position.timestamp.toString(),
      'run_id': runId,
    };
    return await DB.request(
      method: DBMethod.POST,
      url: ApiPaths.position,
      headers: ApiHeaders.headersWithToken,
      context: context,
      body: body,
      header: S.of(context).positionUpdate,
    );
  }
}
