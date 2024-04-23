// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/style_guide/StyleGuide.dart';
import '../../models/calendar/Events.dart';
import '../../models/user/User.dart';
import '../../services/httpService/HttpService.dart';
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
  ///Variablen für den Kalender und die Events
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<DateTime> selectedDays = [];
  List<CalendarEvent> events = [];
  late Future<User?> currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = HttpService().getCurrentUser();
    //TODO: getCalendarEntries implementieren um aktuelle liste von Einträgen des Users zu laden
    //events = await CalendarEvent.getCalendarEntries() ?? [];
  }

  ///[onRangeSelected] wird aufgerufen wenn ein Bereich im Kalender ausgewählt wird
  ///Es wird überprüft ob der Bereich ein Wochenende ist
  ///Wenn ja wird das Wochenende übersprungen
  ///Wenn nein wird der Bereich ausgewählt
  //TODO: Aktuell wenn es mehr als 1 Woche ist wird es nicht richtig angezeigt
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    DateTime? startDay = start;
    DateTime? endDay = end;

    // Wenn Start oder Ende ein Wochenende ist wird das Wochenende übersprungen
    // Wenn Start ein Wochenende ist wird der nächste Tag ausgewählt bis es kein Wochenende ist(Montag)
    while (startDay != null &&
        (startDay.weekday == DateTime.saturday ||
            startDay.weekday == DateTime.sunday)) {
      startDay = startDay.add(const Duration(days: 1));
    }
    // Wenn das Ende ein Wochenende ist wird der Tag davor ausgewählt bis es kein Wochenende ist(Freitag)
    while (endDay != null &&
        (endDay.weekday == DateTime.saturday ||
            endDay.weekday == DateTime.sunday)) {
      endDay = endDay.subtract(const Duration(days: 1));
    }

    // Wenn Start und Ende nicht null sind wird der Bereich ausgewählt
    if (start != null && end != null) {
      setState(() {
        focusedDay = focusedDay;
        _rangeStart = start;
        _rangeEnd = end;
        selectedDays = [start, end];
      });
    } else {
      setState(() {
        focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        selectedDays = [];
      });
    }
  }

  ///[showAddDialog] wird aufgerufen wenn ein neuer Kalendereintrag erstellt wird
  ///Es wird ein Dialog erstellt der den Titel des Kalendereintrags abfragt
  ///Der Dialog hat zwei Buttons um den Eitrag zu speichern oder Abbrechen
  ///Der Titel wird zurückgegeben
  Future<String> showAddDialog() async {
    String? title;
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: StyleGuide.kColorWhite,
            title: const Text('Neuer Kalendereintrag'),
            content: TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: const InputDecoration(
                hintText: 'Titel',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Abbrechen'),
              ),
              TextButton(
                onPressed: () {
                  Get.back(result: title);
                },
                child: const Text('Speichern'),
              ),
            ],
          );
        });
    return title!;
  }

  Future<void> addNewEvent() async {
    String title = await showAddDialog();

    User? user = await HttpService().getCurrentUser();
    //String? userName = '${user!.firstName} ${user.lastName}';
    String? deputy = '${user?.deputy?.firstName} ${user?.deputy?.lastName}' ??
        'Keine Stellvertretung gewählt';
    String? status;

    if (selectedDays.isNotEmpty) {
      DateTime start = selectedDays.first;
      DateTime end = selectedDays.last;

      CalendarEvent newEvent = CalendarEvent(
        title: title,
        startDate: start,
        endDate: end,
        userDeputy: deputy,
        status: status,
      );
      bool success = await newEvent.createCalendarEntry();
      setState(() {
        if (success) {
          events.add(newEvent);
          ScaffoldMessenger.of(Get.context!)
              .showSnackBar(StyleGuide.kSnackBarCreatedSuccess);
        } else {
          ScaffoldMessenger.of(Get.context!)
              .showSnackBar(StyleGuide.kSnackBarCreatedError);
        }
      });
    } else {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(StyleGuide.kSnackBarCreatedError);
    }
  }

  ///Hier wird der Kalender erstellt
  ///Es wird ein Default Builder erstellt der die Tage im Kalender anzeigt
  ///Die Tage die Samstag und Sonntag sind werden grau dargestellt
  ///Der Kalender hat ein Header Styling und ein Kalender Styling
  ///Es wird ein Builder erstellt der die Events/Einträge im Kalender anzeigt
  @override
  Widget BuildPlaner(User user) {
    final kFirstDay = DateTime.utc(2024, 01, 01);
    final kLastDay = DateTime.utc(2050, 12, 31);
    var _calendarFormat = CalendarFormat.month;

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
                //locale: 'de_DE', //TODO: Inizialisierung von LocalDate, funtioniert aktuell nicht
                focusedDay: DateTime.now(), //Heutiges Datum
                firstDay: kFirstDay, //Erster und letzter Tag des Kalenders
                lastDay: kLastDay, //Erster und letzter Tag des Kalenders
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                onRangeSelected: onRangeSelected,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                startingDayOfWeek: StartingDayOfWeek
                    .monday, // Wochenstart ist Montag: Standard ist Sonntag
                currentDay: DateTime.now(), //Heutiges Datum
                calendarFormat:
                    _calendarFormat, //Format des Kalenders (Standard 1 Monat)

                ///Kalender Banner Styling (Farben, Formen & Schriftarten)
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible:
                      true, //Um das Format zu ändern (1 Monat, 2 Woche & 1 Woche)
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

                ///Kalender Styling (Farben, Formen & Schriftarten)
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
                    color: StyleGuide.kColorGrey,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: StyleGuide.kColorGrey,
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: StyleGuide.kColorGrey,
                  outsideDaysVisible: true, //Ausserhalb des Monats sichtbar
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
                  setState(() {
                    _focusedDay = focusedDay;

                    ///Checkt ob das ausgewählte Datum bereits ausgewählt ist
                    if (selectedDays.contains(selectedDay)) {
                      ///Wenn ja, wird es entfernt
                      selectedDays.remove(selectedDay);

                      ///Wenn bereits ein Datum ausgewählt ist, wird das neue Datum hinzugefügt
                      ///Wenn zwei Daten ausgewählt sind, wird die Auswahl zurückgesetzt
                      ///und das neue Datum hinzugefügt
                    } else if (selectedDays.isEmpty ||
                        selectedDays.any((d) =>
                            (d.difference(selectedDay).inDays).abs() == 1)) {
                      selectedDays.add(selectedDay);
                    } else {
                      selectedDays = [selectedDay];
                    }
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
                ///Es wird ein Default Builder erstellt der die Tage im Kalender anzeigt
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
                  child: Text(
                      'Übrige Urlaubstage: ${user.holiday ?? 'Konnte nicht geladen werden'}'),
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
          addNewEvent();
        },
        child: const Icon(Icons.event, color: StyleGuide.kColorWhite),
      ),
    );
  }

  ///[BuildPlaner] wird aufgerufen wenn der User eingeloggt ist
  ///Es wird ein FutureBuilder erstellt der den aktuellen User lädt
  ///Wenn der User geladen is wird der Planer erstellt
  ///Wenn der User noch nicht geladen ist wird ein Ladekreis angezeigt
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: currentUser,
      //context ist der aktuelle BuildContext das heisst das Widget wird in diesem BuildContext erstellt und angezeigt
      //buildcontext ist ein Objekt das Informationen über die Position und Grösse eines Widgets enthält
      //snapshot ist ein Objekt das Informationen über den Status des Future enthält
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        //Wenn der User geladen ist wird der Planer erstellt
        if (snapshot.hasData) {
          return BuildPlaner(snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text('Keine Daten vorhanden');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
