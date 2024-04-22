// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/style_guide/StyleGuide.dart';
import '../../static/StaticUser.dart';
import '../../widgets/drawer/Drawer.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

// Für darstellung der Listen von Kalendereinträgen
Widget buildEventList() {
  return ListView.builder(
    itemCount: 1,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            title: Text('Ferien'),
            subtitle: Text(
                'Max Muster\n von 01.01.2024 bis 10.01.2024\n Status: In Bearbeitung\n Stellvertretung: ${user2.firstName} ${user2.lastName}'),
            leading: Icon(Icons.event),
            trailing: Icon(Icons.delete, color: StyleGuide.kColorRed),
          ),
        ),
      );
    },
  );
}

class _CalendarScreenState extends State<CalendarScreen> {
  ///Detailbeschreibung was der Kalender macht
  ///
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
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TableCalendar(
                //locale: 'de_DE', //TODO: Inizialisierung von LocalDate
                focusedDay: DateTime.now(), //Heutiges Datum
                firstDay: kFirstDay, //Erster und letzter Tag des Kalenders
                lastDay: kLastDay, //Erster und letzter Tag des Kalenders
                startingDayOfWeek: StartingDayOfWeek
                    .monday, // Wochenstart ist Montag: Standard ist Sonntag
                currentDay: DateTime.now(), //Heutiges Datum
                calendarFormat:
                    _calendarFormat, //Format des Kalenders (Standard 1 Monat)

                ///Kalender Banner Styling (Farben, Formen, Schriftarten)
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible:
                      true, //Um das Format zu ändern 1 Monat,2Woche,1Woche
                  formatButtonTextStyle: const TextStyle(
                    color: StyleGuide.kColorSecondaryBlue,
                  ),
                  titleTextStyle: const TextStyle(
                    color: StyleGuide.kColorSecondaryBlue,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: StyleGuide.kColorPrimaryGreen,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: StyleGuide.kColorPrimaryGreen,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: StyleGuide.kColorPrimaryGreen,
                  ),
                ),

                ///Kalender Styling (Farben, Formen, Schriftarten)
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: StyleGuide.kColorPrimaryGreen,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: StyleGuide.kColorSecondaryBlue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: StyleGuide.kColorSecondaryBlue,
                  ),
                  todayTextStyle: TextStyle(
                    color: StyleGuide.kColorWhite,
                  ),
                  rangeStartDecoration: BoxDecoration(
                    color: StyleGuide.kColorWhite,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: StyleGuide.kColorWhite,
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: StyleGuide.kColorGrey,
                  outsideDaysVisible: true, //Außerhalb des Monats sichtbar
                  cellMargin: EdgeInsets.all(4.0),
                  markersMaxCount: 1, //Maximale Anzahl an Markern
                  markerSize: 12,
                  markerDecoration: BoxDecoration(
                    color: StyleGuide.kColorRed,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(
                    color: StyleGuide.kColorSecondaryBlue,
                  ),
                  weekendTextStyle: TextStyle(
                    color: StyleGuide.kColorGrey,
                  ),
                ),

                onFormatChanged: (format) {
                  //Ändert das Format des Kalenders
                  setState(() {
                    if (_calendarFormat != format) _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  //Das ausgewählte Datum wird gespeichert
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                  });
                },
                selectedDayPredicate: (day) {
                  //Das ausgewählte Datum wird markiert
                  return isSameDay(_selectedDay, day);
                },
                onPageChanged: (focusedDay) {
                  //Ändert den Fokus des Kalenders
                  _focusedDay = focusedDay;
                },

                ///Kalender Builder
                ///Hier wird der Kalender erstellt
                ///Es wird ein Default Builder erstellt, der die Tage im Kalender anzeigt
                ///Die Tage die Samstag und Sonntag sind werden grau dargestellt
                calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                  if (day.weekday == 6 || day.weekday == 7) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(
                          color: StyleGuide.kColorGrey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                }),
              ),
            ),
            StyleGuide.SizeBoxHeight32,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Übrige Urlaubstage: ${user1.holiday}'),
                ),
                // Zeigt User seine verfügbaren Ferientage die er übrig hat
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 100,
                child: buildEventList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: StyleGuide.kColorPrimaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //TODO: Add event function
          //addnewEvent();
        },
        child: const Icon(Icons.event, color: StyleGuide.kColorWhite),
      ),
    );
  }
}
