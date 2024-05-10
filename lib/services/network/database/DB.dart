import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/models/Laravel.dart';
import 'package:wolvesrun/models/LaravelError.dart';
import 'package:wolvesrun/models/LaravelValidationError.dart';
import 'package:wolvesrun/widgets/NetworkSnackbar.dart';

class DB {
  static _showErrorSnackBar(
      http.Response response, BuildContext context, String header) {
    if (response.statusCode < 400) return;

    Laravel? error;
    Map<String, dynamic> json = jsonDecode(response.body);

    try {
      if (response.statusCode == 400) {
        error = ValidationError.fromJson(json);
      } else {
        error = LaravelError.fromJson(json);
      }
    } catch (_) {
      error = LaravelError(message: 'Unknown error', errors: {});
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
    required String header
  }) async {
    assert(context != null && !hideError,
        'Context must not be null when hideError is false');

    http.Response response;

    switch (method) {
      case DBMethod.GET:
        response = await http.get(Uri.parse(url), headers: headers);
        break;
      case DBMethod.POST:
        response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        break;
      case DBMethod.PUT:
        response = await http.put(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        break;
      case DBMethod.DELETE:
        response = await http.delete(Uri.parse(url), headers: headers);
        break;
    }
    if (!hideError && context != null && context.mounted) {
      _showErrorSnackBar(response, context, header);
    }
    return response;
  }
}

enum DBMethod { GET, POST, PUT, DELETE }
