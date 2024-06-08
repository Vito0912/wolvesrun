import 'package:wolvesrun/globals.dart' as globals;

class ApiPaths {
  static String get baseUrl => globals.wolvesRunServer;

  static const String baseApiUrl = "/api/v1";

  static String get fullApiUrl => '$baseUrl$baseApiUrl';

  static String get auth => '$fullApiUrl/auth';

  static String itemPoints(int x, int y, int activityType) =>
      '$fullApiUrl/resources/spawn?x=$x&y=$y&activity_type=$activityType&multiplier=10';

  static String get position => '$fullApiUrl/position';

  static String get userInformation => '$fullApiUrl/user';

  static String get login => '$fullApiUrl/login';

  static String get runs => '$fullApiUrl/runs';

  static String get resourceImages => '$fullApiUrl/resources/images';

  static String run(int id) => '$fullApiUrl/run/$id';

  static String get health => '$fullApiUrl/health';
}
