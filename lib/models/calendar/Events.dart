import 'package:flutter/cupertino.dart';

import '../../constants/style_guide/StyleGuide.dart';
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
}
