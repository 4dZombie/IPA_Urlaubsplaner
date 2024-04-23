import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants/style_guide/StyleGuide.dart';
import '../../keys.dart';
import '../../services/httpService/HttpService.dart';
import 'Calendar.dart';

/// Model für Kalendereinträge
class CalendarEvent extends StatelessWidget {
  final String? id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? userDeputy;
  final String? status;

  /// Konstruktor
  CalendarEvent({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.userDeputy,
    this.status,
  });

  /// Konvertiert ein Json Objekt in ein CalendarEvent Objekt
  factory CalendarEvent.fromCalendar(Calendar calendar) {
    return CalendarEvent(
      title: calendar.title,
      startDate: DateTime.parse(calendar.startDate),
      endDate: DateTime.parse(calendar.endDate),
      //userDeputy: calendar.userName,
      //status: calendar.status,
    );
  }

  ///[EventMarker] erstellt Marker für jeden Tag des Events und fügt sie der Liste hinzu
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: StyleGuide.kColorRed,
      ),
    );
  }

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

  Future<void> removeCalendarEntry(String id) async {
    String jwtToken = (await HttpService().getAccessToken())!;
    String entryId = id;
    String apiUrl = "$apiKey/calendar/$entryId";
    final Map<String, dynamic> data = {
      'id': entryId,
    };
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
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
}
