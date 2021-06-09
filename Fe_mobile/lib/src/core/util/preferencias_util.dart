import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferenciasUtil {
  static final PreferenciasUtil _instancia = new PreferenciasUtil._internal();

  factory PreferenciasUtil() => _instancia;

  PreferenciasUtil._internal();

  SharedPreferences prefs;

  initPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
  }

  setPrefsMap(String key, Map<String, dynamic> values) async =>
      await prefs.setString(key, json.encode(values));

  setPrefStr(String key, String value) async {
    try {
      await prefs.setString(key, value);
    } catch (e) {
      print("D1 - $e");
    }
  }

  Future<String> getPrefStr(String key) async {
    try {
      var a = prefs.getString(key);
      return a;
    } catch (e) {
      print("C3 - $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> getPrefMap(String key) async {
    String mapStr = await getPrefStr(key);
    if (mapStr == null) return {};
    return json.decode(mapStr);
  }

  removePrefStr(String key) async => prefs.remove(key);
}
