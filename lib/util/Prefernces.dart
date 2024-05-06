import 'package:shared_preferences/shared_preferences.dart';

class SP {

  sharedP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs;
  }

  updateInt(String key, int value, {bool? web}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(key, value);

  }

  updateBool(String key, bool value, {bool? web}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);

  }

  updateList(String key, List<String> value, {bool? web}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(key, value);

  }

  updateString(String key, String value, {bool? web}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);

  }

  removePref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  Future<List<String>?> getList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(key);
  }

  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }
}