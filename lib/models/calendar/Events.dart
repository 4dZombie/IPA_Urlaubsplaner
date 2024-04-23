import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../keys.dart';
import '../../services/httpService/HttpService.dart';

/// Model für Kalendereinträge
class CalendarEvent {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? userDeputy;
  final String? status;

  CalendarEvent({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.userDeputy,
    this.status,
  });

  /// API request um ein Kalendereintrag zu erstellen
  Future createCalendarEntry() async {
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
}
