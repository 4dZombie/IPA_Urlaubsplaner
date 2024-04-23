import 'package:flutter/material.dart';

import '../../../constants/style_guide/StyleGuide.dart';
import '../../../models/calendar/Events.dart';

///TODO: Wird nicht mehr benötigt ist bereits im Model drin und kann nicht importiert werden

class EventMarker extends StatelessWidget {
  final CalendarEvent event; // Event, das markiert wird

  const EventMarker({super.key, required this.event});
  @override
  Widget build(BuildContext context) {
    List<Widget> markers = []; // Liste der Marker
    DateTime currentDay = event.startDate; // Startdatum des Events
    /// Erstellt Marker für jeden Tag des Events und fügt sie der Liste hinzu
    while (currentDay.isBefore(event.endDate) ||
        currentDay.isAtSameMomentAs(event.endDate)) {
      markers.add(Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: StyleGuide.kColorRed,
          shape: BoxShape.circle,
        ),
      ));
      currentDay = currentDay.add(const Duration(days: 1));
    }
    // Gibt die Marker als Reihe zurück
    return Row(
      children: markers,
    );
  }
}
