import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/generated/l10n.dart';
import 'package:wolvesrun/models/Laravel.dart';
import 'package:wolvesrun/models/LaravelError.dart';
import 'package:wolvesrun/models/LaravelValidationError.dart';
import 'package:wolvesrun/widgets/NetworkSnackbar.dart';

class DB {
  static _showErrorSnackBar(
      http.Response response, BuildContext context, String header) {
    if (response.statusCode < 400) return;

    print(response.statusCode);

    Laravel? error;
    Map<String, dynamic> json = jsonDecode(response.body);

    try {
      if (response.statusCode == 400) {
        error = ValidationError.fromJson(json);
      } else if (response.statusCode == 401) {
        error = LaravelError(
            message: S.current.unauthorized,
            errors: {'token': S.current.unauthorized});
      } else {
        error = LaravelError.fromJson(json);
      }
    } catch (_) {
      error = LaravelError(
          message: 'Unknown error',
          errors: {'error': json['error'] ?? 'Unknown error'});
    }

    NetworkSnackbar.showSnackbar(
        context, SnackbarType.error, [...error.generateMessages()], header);
  }

  static Future<http.Response> request({
    required DBMethod method,
    required String url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
    bool hideError = false,
    BuildContext? context,
    required String header,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    print('Request: $hideError');
    assert(hideError || context != null,
        'Context must not be null when hideError is false');

    http.Response response;

    try {


    switch (method) {
      case DBMethod.GET:
        response =
            await http.get(Uri.parse(url), headers: headers).timeout(timeout);
        break;
      case DBMethod.POST:
        response = await http
            .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
            .timeout(timeout);
        break;
      case DBMethod.PUT:
        response = await http
            .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
            .timeout(timeout);
        break;
      case DBMethod.DELETE:
        response = await http
            .delete(Uri.parse(url), headers: headers)
            .timeout(timeout);
        break;
    }
    } on TimeoutException catch (e) {
      if(!hideError && context != null && context.mounted) {
        NetworkSnackbar.showSnackbar(
            context, SnackbarType.error, ["Timeout"], header);
      }
      return http.Response('{"error": "Timeout"}', 408);
    }
    if (!hideError && context != null && context.mounted) {
      _showErrorSnackBar(response, context, header);
    } else if (response.statusCode >= 400) {
      throw Exception('Error: ${response.statusCode}\n${response.body}');
    }
    return response;
  }
}

enum DBMethod { GET, POST, PUT, DELETE }
