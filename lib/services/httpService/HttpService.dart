import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../keys.dart';

class HttpService {
  // Hier hole ich mir die API URL aus der keys.dart Datei
  final String? baseUrl = apiKey;
  final storage = const FlutterSecureStorage();

  /// getHeaders() holt die Header für die API Anfragen
  Future<Map<String, String>> getHeaders() async {
    String? jwtToken = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
  }

  /// getAccessToken() holt den access_token
  Future getAccessToken() async {}

  /// saveAccessToken() speichert den access_token
  Future saveAccessToken(String jwtToken) async {
    await storage.write(key: 'jwtToken', value: jwtToken);
  }

  /// loginUserEmail() speichert die Email des eingeloggten Users
  Future<void> loginUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInUserEmail', userEmail);
  }

  /// loginUser() sendet die Anfrage an die API um sich einzuloggen
  Future<String> loginUser(String email, String password) async {
    String emailTrimmed = email.trim();
    String passwordTrimmed = password.trim();
    String apiUrl = '$baseUrl/users/login';

    /// requestBody enthält die Daten die an die API gesendet werden
    Map<String, dynamic> requestBody = {
      'email': emailTrimmed,
      'password': passwordTrimmed,
    };

    /// Anfrage an die API
    try {
      /// Antwort von der API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      /// Wenn die Anfrage erfolgreich war, wird der access_token gespeichert und der User wird weitergeleitet
      if (response.statusCode == 200 || response.statusCode == 201) {
        String jwtToken = response.headers['authorization'] ?? '';
        await saveAccessToken(jwtToken);
        await loginUserEmail(emailTrimmed);
        Get.offAllNamed("/calendar");
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(StyleGuide.kSnackBarLoginSuccess);
        return jwtToken;
      } else {
        print('Failed to login user. Error: ${response.body}');
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(StyleGuide.kSnackBarLoginError);
        return '';
      }
    } catch (e) {
      print('Error during login: $e');
      return '';
    }
  }
}
