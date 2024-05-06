import 'package:wolvesrun/globals.dart' as globals;

class ApiPaths {
  static String get baseUrl => globals.wolvesRunServer;

  static const String baseApiUrl = "/api/v1";

  static String get fullApiUrl => '$baseUrl$baseApiUrl';

  static String get auth => '$fullApiUrl/auth';

  static String itemPoints(double longitude, double latitude) =>
      '$fullApiUrl/resources/spawn?lat=$latitude&lng=$longitude';
}
