import 'package:flutter/cupertino.dart';

import '../../widgets/color/StatusColor.dart';
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
      status: calendar.status,
    );
  }

  ///[EventMarker] erstellt Marker für jeden Tag des Events und fügt sie der Liste hinzu
  ///Farbe wird vom Kalender überschrieben ist aber hier als Defaultwert
  @override
  Widget build(BuildContext context) {
    Color color = getStatusColor().tileColor(status);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
