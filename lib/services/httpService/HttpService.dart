import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../keys.dart';
import '../../models/calendar/Calendar.dart';
import '../../models/user/User.dart';

/// Die Klasse [HttpService] ist die Basis für alle HttpService Klassen
/// Hier werden die Header für die API Anfragen geholt und der access_token gespeichert
/// und es wird auch die Anfrage an die API für das Einloggen und Registrieren gemacht

/// Wenn ein Api call nicht erfolgreich ist und der User informiert werden soll, wird ein SnackBar angezeigt
/// ansonsten wird dieser Fehler in der Konsole ausgegeben

class HttpService {
  ///Basis der HttpService Klasse

  // Hier hole ich mir die API URL aus der keys.dart Datei
  final String? baseUrl = apiKey;
  final storage = const FlutterSecureStorage();

  /// [getAccessToken] holt den access_token
  Future<String?> getAccessToken() async {
    return await storage.read(key: 'jwtToken');
  }

  /// [saveAccessToken] speichert den access_token
  Future saveAccessToken(String jwtToken) async {
    await storage.write(key: 'jwtToken', value: jwtToken);
  }

  /// [deleteAccessToken] löscht den access_token
  Future deleteAccessToken() async {
    await storage.delete(key: 'jwtToken');
  }

  /// [getHeaders] holt die Header für die API Anfragen
  Future<Map<String, String>> getHeaders() async {
    String? jwtToken = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
  }

  /// Benutzerdaten

  /// [extractUserId] extrahiert die User ID aus dem JWT Token
  String? extractUserId(String? jwtToken) {
    try {
      if (jwtToken == null || jwtToken.isEmpty) {
        print('Error extracting user id: jwtToken is null or empty');
        return null;
      }
      jwtToken =
          jwtToken.startsWith('Bearer ') ? jwtToken.substring(7) : jwtToken;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      String? userId = decodedToken['sub'];
      return userId;
    } catch (e) {
      print('Error extracting user id: $e');
      return null;
    }
  }

  Future<User> getCurrentUser() async {
    String? jwtToken = await getAccessToken();
    String? currentUserId = extractUserId(jwtToken!);
    String apiUrl = '$baseUrl/users/$currentUserId';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(response.body);
        User user = User.fromJson(userData);
        return user;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error getting current user: $e');
      throw e;
    }
  }

  Future<User> getCurrentUserId() async {
    String? jwtToken = await HttpService().getAccessToken();
    String? currentUserId = HttpService().extractUserId(jwtToken!);
    String apiUrl = '$apiKey/users/$currentUserId';
    http.Client client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await HttpService().getHeaders(),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(response.body);
        User user = User.fromJson(userData);
        return user;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user: $e');
    } finally {
      client.close();
    }
    return User(id: '');
  }

  ///Login

  /// [loginUserEmail] speichert die Email des eingeloggten Users
  Future<void> loginUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInUserEmail', userEmail);
  }

  /// [loginUser] sendet die Anfrage an die API um sich einzuloggen
  Future<String> loginUser(String email, String password) async {
    // Trim macht es möglich, dass Leerzeichen am Anfang und Ende des Strings entfernt werden
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

  ///Registrierung

  /// [registerUser] sendet die Anfrage an die API um sich zu registrieren
  Future<void> registerUser(
    String company,
    String firstName,
    String lastName,
    String email,
    String password,
    String street,
    String birthdate,
    String yearsOfService,
    String districtNumber,
    String districtName,
    String rank,
    bool kids,
    bool student,
    String employment,
  ) async {
    // Trim macht es möglich, dass Leerzeichen am Anfang und Ende des Strings entfernt werden
    String companyTrimmed = company.trim();
    String firstNameTrimmed = firstName.trim();
    String lastNameTrimmed = lastName.trim();
    String emailTrimmed = email.trim();
    String passwordTrimmed = password.trim();
    String streetTrimmed = street.trim();
    String birthdateTrimmed = birthdate.trim();
    String yearsOfServiceTrimmed = yearsOfService.trim();
    String districtNumberTrimmed = districtNumber.trim();
    String districtNameTrimmed = districtName.trim();
    String rankTrimmed = rank.trim();
    bool kidsTrimmed = kids ?? false;
    bool studentTrimmed = student ?? false;
    String employmentTrimmed = employment.trim();

    String apiUrl = '$baseUrl/users/register';

    /// requestBody enthält die Daten die an die API gesendet werden
    Map<String, dynamic> requestBody = {
      'company': companyTrimmed,
      'firstName': firstNameTrimmed,
      'lastName': lastNameTrimmed,
      'email': emailTrimmed,
      'password': passwordTrimmed,
      'street': streetTrimmed,
      'birthdate': birthdateTrimmed,
      'yearsOfEmployment': yearsOfServiceTrimmed,
      'district': {
        'plz': int.tryParse(districtNumberTrimmed) ?? 0,
        'name': districtNameTrimmed,
      },
      'rank': {
        'name': rankTrimmed,
      },
      'kids': kidsTrimmed,
      'student': studentTrimmed,
      'employment': int.tryParse(employmentTrimmed) ?? 0,
    };
    try {
      /// Anfrage an die API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      /// Wenn die Anfrage erfolgreich war, wird der User weitergeleitet
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(StyleGuide.kSnackBarRegisterSuccess);
        // Zurück zum Login geschickt werden
        Get.back();
      } else {
        print('Failed to register user. Error: ${response.body}');
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(StyleGuide.kSnackBarRegisterError);
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  /// Kalender

  Future<List<Calendar>> userCalendar() async {
    String? jwtToken = await HttpService().getAccessToken();
    String? currentUserId = HttpService().extractUserId(jwtToken!);
    String apiUrl = '$apiKey/calendar/user/$currentUserId/calendars';
    http.Client client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );
//TODO: prints löschen nach fix
      if (response.statusCode == 200) {
        List<dynamic> calendarsData = jsonDecode(response.body);
        //print('response body $calendarsData');
        List<Calendar> calendars = calendarsData
            .map((calendar) => Calendar.fromJson(calendar))
            .toList();
        //print('calendar data $calendars');
        return calendars;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user calendars: $e');
    } finally {
      client.close();
    }
    return [];
  }

  Future<List<Calendar>> allUserCalendar() async {
    String? jwtToken = await HttpService().getAccessToken();
    String apiUrl = '$apiKey/calendar';
    http.Client client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> calendarsData = jsonDecode(response.body);
        List<Calendar> calendars = calendarsData
            .map((calendar) => Calendar.fromJson(calendar))
            .toList();
        return calendars;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user calendars: $e');
    } finally {
      client.close();
    }
    return [];
  }
}
