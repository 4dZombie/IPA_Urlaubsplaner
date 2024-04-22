// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/style_guide/StyleGuide.dart';
import '../../static/StaticUser.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

/// Verursacht nur errors
/// Für darstellung der Listen von Kalendereinträgen
// Widget buildEventList() {
//   return ListView.builder(
//     itemCount: 2,
//     itemBuilder: (context, index) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//         child: Card(
//           child: ListTile(
//             title: Text('Event $index'),
//           ),
//         ),
//       );
//     },
//   );
// }

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    final kFirstDay = DateTime.utc(2024, 01, 01);
    final kLastDay = DateTime.utc(2050, 12, 31);
    var _calendarFormat = CalendarFormat.month;
    //DateTime? _rangeStart;
    //DateTime? _rangeEnd;
    //List<DateTime> _selectedDays = [];
    //List<CalendarEvent> events = [];

    return Scaffold(
      appBar: StyleGuide.kPrimaryAppbar(title: "Kalender"),
      body: Padding(
        padding: StyleGuide.kPaddingAll,
        child: Column(
          children: [
            TableCalendar(
              //locale: 'de_DE', //TODO: Inizialisierung von LocalDate im Main -> kp wie
              focusedDay: DateTime.now(), //Heutiges Datum
              firstDay: kFirstDay, //Erster und letzter Tag des Kalenders
              lastDay: kLastDay, //Erster und letzter Tag des Kalenders
              startingDayOfWeek: StartingDayOfWeek
                  .monday, // Wochenstart ist Montag: Standard ist Sonntag
              currentDay: DateTime.now(), //Heutiges Datum
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                //Ändert das Format des Kalenders
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) {
                //Das ausgewählte Datum wird markiert
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                //Das ausgewählte Datum wird gespeichert
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                //Ändert den Fokus des Kalenders
                _focusedDay = focusedDay;
              },
            ),
            StyleGuide.SizeBoxHeight32,
            Row(
              children: [
                // Zeigt User seine verfügbaren Ferientage die er übrig hat
                Text('Übrige Urlaubstage: ${user1.holiday}'),
              ],
            ),
            StyleGuide.SizeBoxHeight32,
            Row(
              children: [
                // buildEventList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
