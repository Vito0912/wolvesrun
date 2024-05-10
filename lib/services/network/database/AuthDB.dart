import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/services/network/ApiHeaders.dart';
import 'package:wolvesrun/services/network/ApiPaths.dart';
import 'package:wolvesrun/services/network/database/DB.dart';

class AuthDB extends DB {

  static Future<http.Response> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo = await deviceInfo.androidInfo;
    String deviceName = androidInfo.model;

    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'device_name': deviceName
    };

    return await DB.request(
      method: DBMethod.POST,
      url: ApiPaths.login,
      headers: ApiHeaders.headers,
      body: body,
      context: context,
      header: 'Login',
    );
  }

}