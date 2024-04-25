//Import von Drittanbietern
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

//Import von meinen Dateien
import '../../constants/style_guide/StyleGuide.dart';
import '../../models/calendar/Calendar.dart';
import '../../models/calendar/Events.dart';
import '../../models/user/User.dart';
import '../../services/httpService/HttpService.dart';
import '../../widgets/drawer/Drawer.dart';

///[CalendarScreen] ist ein StatefulWidget das heisst es kann sich während der Laufzeit ändern
///In diesr Klasse wird der Kalender für den User erstellt
///Der Kalender wird designed und die Events werden angezeigt
///Der User kann neue Events hinzufügen und bestehende Events löschen
///Der User kann sehen wie viele Urlaubstage er noch hat und den Status der Einträge
///Der User kann die Ansicht des Kalenders ändern (1 Monat, 2 Wochen, 1 Woche)
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  ///Variablen für den Kalender und die Events
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<DateTime> selectedDays = [];
  late List<CalendarEvent> _events = [];
  late Future<User> currentUser;
  final kFirstDay = DateTime.utc(2024, 01, 01);
  final kLastDay = DateTime.utc(2050, 12, 31);
  var _calendarFormat = CalendarFormat.month;
  String? calendarId;

  //Bespiel feiertage
  Map<DateTime, List<String>> holidays = {
    DateTime(2024, 05, 01): ['Tag der Arbeit'],
    DateTime(2024, 05, 09): ['Auffahrt'],
    DateTime(2024, 05, 20): ['Pfingstmontag'],
  };

  ///[initState] wird aufgerufen wenn das Widget erstellt wird
  ///Es wird der aktuelle User geladen mit der Methode [getCurrentUserId]
  ///Es wird die Methode [loadUserCalendars] aufgerufen um die Kalender des Users zu laden
  @override
  void initState() {
    super.initState();
    loadUserCalendars();
    currentUser = HttpService().getCurrentUserId();
  }

  ///[loadUserCalendars] wird aufgerufen wenn die Kalender des Users geladen werden
  ///Es wird ein API Request gemacht um die Kalender des Users zu laden
  ///Die Kalender werden in eine Liste von Events konvertiert
  ///Die Events werden in die Liste [_events] gespeichert
  Future<void> loadUserCalendars() async {
    try {
      List<Calendar> calendars = await HttpService().userCalendar();
      setState(() {
        _events = calendars
            .map((calendar) => CalendarEvent.fromCalendar(calendar))
            .toList();
      });
    } catch (error) {
      print('Error loading user calendars: $error');
    }
  }

  ///[buildEventList] wird aufgerufen wenn die Events im Kalender angezeigt werden
  ///Es wird eine Liste erstellt die die Events anzeigt
  ///Es wird ein Card Widget erstellt das die Events anzeigt
  Widget buildEventList() {
    return ListView.builder(
      //Anzahl der Events ensprechen der Anzahl der Events in der Liste
      //ItemBuilder erstellt ein ListTile für jedes Event
      itemCount: _events.length,
      itemBuilder: (BuildContext context, int index) {
        final event = _events[index];
        return Padding(
          padding: StyleGuide.kPaddingHorizontal,
          child: Card(
            color: StyleGuide.kColorSecondaryBlue,
            child: ListTile(
              title: Text(
                event.title,
                style: const TextStyle(
                  color: StyleGuide.kColorWhite,
                ),
              ),

              ///[FutureBuilder] wird aufgerufen wenn die Events geladen werden
              ///Es wird überprüft ob die Events geladen sind
              ///Wenn die Events geladen sind wird das Datum und der Status des Events angezeigt
              subtitle: FutureBuilder<List<Calendar>>(
                future: HttpService().userCalendar(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      Calendar calendar = snapshot.data!.firstWhere(
                          (calendar) => calendar.title == event.title);

                      ///[toIso8601String] konvertiert die Zeit in ein ISO 8601 Format
                      ///[split] teilt den String in zwei Teile, T trennt Datum und Zeit um sicherzustellen das keine Zeit angezeigt wird
                      ///[0] gibt das Datum zurück ohne die Zeit, wenn [1] verwendet wird wird die Zeit ohne das Datum angezeigt
                      //TODO: wenn möglich stellvertretung angeben
                      return Text(
                        '${event.startDate.toIso8601String().split('T')[0]} - ${event.endDate.toIso8601String().split('T')[0]} '
                        '\n (${calendar.status})',
                        style: const TextStyle(
                          color: StyleGuide.kColorWhite,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('Keine Daten gefunden');
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              leading: const Icon(Icons.event, color: StyleGuide.kColorWhite),
              //Klickbares Icon um eintrag zu löschen
              //TODO: Aktuell nur von Liste gelöscht, nicht von DB
              trailing: IconButton(
                color: StyleGuide.kColorRed,
                onPressed: () {
                  HttpService().removeCalendarEntryFromList(event.id ?? "");
                  setState(() {
                    _events.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ),
        );
      },
    );
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

    ///Wenn Start und Ende ausgewählt sind wird der Bereich ausgewählt
    setState(() {
      _focusedDay = focusedDay;
      _rangeStart = startDay;
      _rangeEnd = endDay;
      selectedDays =
          startDay != null && endDay != null ? [startDay, endDay] : [];
    });
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
            title: const Text(
              'Neuer Kalendereintrag',
              style: TextStyle(
                fontSize: StyleGuide.kTextSizeExtraLarge,
                color: StyleGuide.kColorSecondaryBlue,
              ),
            ),
            content: TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: StyleGuide.kInputDecoration(
                hint: 'Titel',
                label: 'Titel',
                isMandatory: true,
                suffixIcon: const Icon(
                  Icons.event_note,
                  color: StyleGuide.kColorSecondaryBlue,
                ),
              ),
              style: const TextStyle(
                color: StyleGuide.kColorSecondaryBlue,
                fontSize: StyleGuide.kTextSizeMedium,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(StyleGuide.kColorRed),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Abbrechen',
                  style: TextStyle(
                    color: StyleGuide.kColorSecondaryBlue,
                    fontSize: StyleGuide.kTextSizeMedium,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (title != null && title!.isNotEmpty) {
                    Get.back(result: title);
                  } else {
                    ScaffoldMessenger.of(Get.context!)
                        .showSnackBar(StyleGuide.kSnackBarError);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(StyleGuide.kColorPrimaryGreen),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Speichern',
                  style: TextStyle(
                    color: StyleGuide.kColorSecondaryBlue,
                    fontSize: StyleGuide.kTextSizeMedium,
                  ),
                ),
              ),
            ],
          );
        });
    return title!;
  }

  ///[addNewEvent] wird aufgerufen wenn ein neuer Kalendereintrag erstellt wird
  ///Es wird der Titel des Kalendereintrags abgefragt
  ///Es wird das Start- und Enddatum des Kalendereintrags abgefragt mit einem Selekt der im Kalender selbst geklickt wird
  ///Es wird die STV falls vorhanden erstellt für spätere Validierung
  Future<void> addNewEvent() async {
    String title = await showAddDialog();

    User? user = await HttpService().getCurrentUser();
    //String? userName = '${user!.firstName} ${user.lastName}';
    String? deputy = '${user.deputy?.firstName} ${user.deputy?.lastName}';
    String? id = calendarId; // Funktioniert noch nicht
    //TODO: ID vom Kalender holen um den Kalendereintrage wieder zu löschen
    String? status;

    if (selectedDays.isNotEmpty) {
      DateTime start = selectedDays.first;
      DateTime end = selectedDays.last;

      CalendarEvent newEvent = CalendarEvent(
        id: id,
        title: title,
        startDate: start,
        endDate: end,
        userDeputy: deputy,
        status: status,
      );
      // Wenn API request return true wird der Kalendereintrag erstellt
      // sonst eine Fehlermeldung
      bool success = await HttpService().createCalendarEntry(title, start, end);
      setState(() {
        if (success) {
          _events.add(newEvent);
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

  ///[BuildPlaner] wird aufgerufen wenn der User eingeloggt ist
  ///Es wird ein FutureBuilder erstellt der den aktuellen User lädt
  ///Wenn der User geladen is wird der Planer erstellt
  ///Wenn der User noch nicht geladen ist wird ein Ladekreis angezeigt

  //context ist der aktuelle BuildContext das heisst das Widget wird in diesem BuildContext erstellt und angezeigt
  //buildcontext ist ein Objekt das Informationen über die Position und Grösse eines Widgets enthält
  //snapshot ist ein Objekt das Informationen über den Status des Future enthält
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            User currentUser = snapshot.data!;
            return buildPlaner(currentUser);
          } else {
            return const Center(
              child: Text(
                'Keine Benutzerdaten gefunden',
                style: TextStyle(
                    color: StyleGuide.kColorRed,
                    fontSize: StyleGuide.kTextSizeExxxtraLarge),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ///Hier wird der Kalender erstellt
  ///Es wird ein Default Builder erstellt der die Tage im Kalender anzeigt
  ///Die Tage die Samstag und Sonntag sind werden grau dargestellt
  ///Der Kalender hat ein Header Styling und ein Kalender Styling
  ///Es wird ein Builder erstellt der die Events/Einträge im Kalender anzeigt
  Widget buildPlaner(User user) {
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
                focusedDay: _focusedDay, //Heutiges Datum
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

                //[eventLoader] wird aufgerufen wenn ein Event geladen wird
                // Es wird überprüft ob das Event am ausgewählten Tag ist wenn ja wird es angezeigt und zurückgegeben(Rote Markierung)
                //IN der Zukunft vorallem auch genutzt um Feiertage anzuzeigen
                eventLoader: (day) {
                  final eventsFromDay = _events
                      .where((event) =>
                          isSameDay(event.startDate, day) ||
                          (event.startDate.isBefore(day) &&
                              event.endDate.isAfter(day)) ||
                          (isSameDay(event.endDate, day)))
                      .toList();
                  //Iterable, Geht durch die holiday liste nimmt sich überall wo day drin ist die infos raus und mapt diese mit titel zu einem CalendarEvent
                  if (holidays.containsKey(day)) {
                    eventsFromDay
                        .addAll(holidays[day]!.map((title) => CalendarEvent(
                              title: title,
                              startDate: day,
                              endDate: day,
                              status: 'holiday',
                            )));
                  }
                  // Aktuell keine wirkliche Relevants ausser das es von der IDE teile verlangte
                  //also habe ich diese gleich komplett angezeigt aktuell nicht ersichtlich in dieser Form weil nur ein Eventmarker angezeigt wird
                  // Zukünftig soll der Kalender "Ausklappbar" sein wo das wichtig wird
                  //Missachtet also bewusst YAGNI Pattern
                  return eventsFromDay
                      .map((event) => CalendarEvent(
                            id: event.id,
                            title: event.title,
                            startDate: event.startDate,
                            endDate: event.endDate,
                            userDeputy: event.userDeputy,
                            status: event.status,
                          ))
                      .toList();
                },
                onFormatChanged: (format) {
                  //Ändert das Format des Kalenders
                  //Standard ist 1 Monat  wenn der Button gedrückt wird um das Format auf 2 Wochen oder 1 Woche zu wechseln
                  // lade den Kalender neu
                  setState(() {
                    if (_calendarFormat != format) _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    // Damit sich nicht bei jedem Klick der Kalender auf den Standard Monat resettet
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;

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
                  //TODO: Funktioniert aktuell nicht das es angezeigt wird, falls zeit da ist machen ist ein Nice to have
                  if (_events.any((event) => event.status == 'holiday')) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    );
                  } else if (day.weekday == 6 || day.weekday == 7) {
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
                  return null;
                }),
              ),
            ),
            StyleGuide.SizeBoxHeight32,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Übrige Urlaubstage: ${user.holiday ?? 'Konnte nicht geladen werden'}',
                    style: const TextStyle(
                      fontSize: StyleGuide.kTextSizeMedium,
                      color: StyleGuide.kColorSecondaryBlue,
                    ),
                  ),
                ),
                // Zeigt User seine verfügbaren Ferientage die er übrig hat
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/settings');
                      },
                      child: const Text(
                        'Hast du noch keine Stellvertretung hinterlegt? Klicke hier!',
                        style: TextStyle(
                            fontSize: StyleGuide.kTextSizeSmall,
                            color: StyleGuide.kColorLink),
                      ),
                    ),
                  ],
                ),
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

      ///FloatingActionButton um ein neues Event hinzuzufügen
      floatingActionButton: FloatingActionButton(
        backgroundColor: StyleGuide.kColorPrimaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          addNewEvent();
        },
        child: const Icon(Icons.event, color: StyleGuide.kColorWhite),
      ),
    );
  }
}
