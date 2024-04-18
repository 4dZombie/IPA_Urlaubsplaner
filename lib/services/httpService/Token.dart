import 'package:shared_preferences/shared_preferences.dart';

// getToken() gibt den access_token zurück, der in SharedPreferences gespeichert ist
// SharedPreferences ist eine Library die es ermöglicht, Daten auf dem pc zu speichern
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('access_token') ?? "";
  return token;
}
