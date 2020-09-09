import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setFCMToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('FCMToken', value);
}

Future<String> getFCMToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('FCMToken');
}

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', value);
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
// Future<bool> setUser(A value) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString('token', value);
// }

// Future<String> getToken() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }
