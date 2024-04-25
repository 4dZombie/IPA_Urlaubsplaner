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
    } catch (error) {
      print('Error extracting user id: $error');
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
    } catch (error) {
      print('Error getting current user: $error');
      throw error;
    }
  }

  Future<User> getCurrentUserId() async {
    String? jwtToken = await HttpService().getAccessToken();
    String? currentUserId = HttpService().extractUserId(jwtToken!);
    String apiUrl = '$apiKey/users/$currentUserId';
    try {
      final response = await http.get(
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
    } catch (error) {
      print('Error fetching user: $error');
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
    } catch (error) {
      print('Error during login: $error');
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
    bool kidsTrimmed = kids;
    bool studentTrimmed = student;
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
    } catch (error) {
      print('Error during registration: $error');
    }
  }

  /// Kalender

  /// [createCalendarEntry] sendet die Anfrage an die API um einen Kalendereintrag zu erstellen
  Future createCalendarEntry(
      String title, DateTime startDate, DateTime endDate) async {
    //Holt den JWT Token um die API Anfrage zu autorisieren
    String jwtToken = (await HttpService().getAccessToken())!;
    String apiUrl = "$apiKey/calendar/entry";

    //Daten die an die API gesendet werden und Datum in String Format umwandeln
    final Map<String, dynamic> data = {
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
    //Anfrage an die API
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        //Daten in JSON Format umwandeln
        body: jsonEncode(data),
      );
      //Wenn die Anfrage erfolgreich war true zurückgeben um dem User eine Erfolgsmeldung zu zeigen
      if (response.statusCode == 201) {
        print('Calendar entry created successfully!');
        return true;
      } else {
        print(
            'Failed to create calendar entry. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error creating calendar entry: $error');
    }
  }

  /// [userCalendar] holt die Kalender des eingeloggten Users
  Future<List<Calendar>> userCalendar() async {
    String? jwtToken = await HttpService().getAccessToken();
    String? currentUserId = HttpService().extractUserId(jwtToken!);
    String apiUrl = '$apiKey/calendar/user/$currentUserId/calendars';
    try {
      final response = await http.get(
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
    } catch (error) {
      print('Error fetching user calendars: $error');
    }
    return [];
  }

  /// [allUserCalendar] holt alle Kalender von allen Usern
  Future<List<Calendar>> allUserCalendar() async {
    String apiUrl = '$apiKey/calendar';
    try {
      final response = await http.get(
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
    } catch (error) {
      print('Error fetching user calendars: $error');
    }
    return [];
  }

  /// Validierung

  /// [acceptEntry] akzeptiert den Eintrag
  Future<bool> acceptEntry(String id) async {
    String apiUrl = '$apiKey/calendar/$id/status/accept';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
        body: jsonEncode({'status': 'AKZEPTIERT'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error accepting entry: $error');
    }
    return false;
  }

  /// [declineEntry] lehnt den Eintrag ab
  Future<bool> declineEntry(String id) async {
    String apiUrl = '$apiKey/calendar/$id/status/decline';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
        body: jsonEncode({'status': 'ABGELEHNT'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error declining entry: $error');
    }
    return false;
  }

  /// [preCheckEntry] prüft den Eintrag
  Future<bool> preCheckEntry() async {
    String apiUrl = '$apiKey/calendar/overlapping/status';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error pre validating entry: $error');
    }
    return false;
  }

  /// [getUsers] holt alle User
  Future<List<User>> getAllUsers() async {
    String apiUrl = '$baseUrl/users';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );
      if (response.statusCode == 200) {
        List<dynamic> usersData = jsonDecode(response.body);
        List<User> users =
            usersData.map((user) => User.fromJson(user)).toList();
        return users;
      } else {
        throw ('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      throw ('Error fetching all users: $error');
    }
  }

  /// [removeCalendarEntryFromList] entfernt den Kalendereintrag aus der Liste
  Future<void> removeCalendarEntryFromList(String id) async {
    String apiUrl = "$apiKey/calendar/$id";
    final Map<String, dynamic> data = {
      'id': id,
    };
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
        body: jsonEncode(data),
      );
      if (response.statusCode == 204) {
        print('Calendar entry removed successfully!');
      } else {
        print(
            'Failed to remove calendar entry. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error removing calendar entry: $error');
    }
  }

  ///Einstellungen

  // Future<> setDeputy(String id){
  //   String apiUrl = '$apiKey/calendar';
  // }
  //
  // Future<> setAdmin(String id){
  //   String apiUrl = '$apiKey/calendar';
  // }
}
