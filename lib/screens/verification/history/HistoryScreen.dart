import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

import '../../../models/calendar/Calendar.dart';
import '../../../models/user/User.dart';
import '../../../services/httpService/HttpService.dart';
import '../../../widgets/color/StatusColor.dart';
import '../../../widgets/drawer/Drawer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<User> currentUser;
  List<Calendar> calendarEntries = [];
  late List<User> allUsers = [];
  late String CalendarId;
  int? selectedCalendarIndex;
  bool switchButton = true;

  ///[initState] wird aufgerufen wenn das Widget erstellt wird
  ///Es wird der aktuelle User geladen mit der Methode [getCurrentUserId]
  /// diese wird benötingt um zu überprüfen ob der User ein Admin ist
  ///
  @override
  void initState() {
    super.initState();
    currentUser = HttpService().getCurrentUserId();
    fetchAllUsers();
    loadAllUserCalendars();
  }

  ///[loadAllUserCalendars] lädt alle Kalendereinträge von allen Usern
  Future<void> loadAllUserCalendars() async {
    try {
      List<Calendar> calendars = await HttpService().allUserCalendar();
      setState(() {
        calendarEntries = calendars;
      });
    } catch (error) {
      print('Error loading user calendars: $error');
    }
  }

  ///[fetchAllUsers] lädt alle User
  void fetchAllUsers() async {
    allUsers = await HttpService().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            User currentUser = snapshot.data!;
            //print(currentUser.roles);
            bool isUserAdmin =
                currentUser.roles?.any((role) => role.name == 'ADMIN') ?? false;
            if (isUserAdmin) {
              return buildVerification(currentUser);
            } else {
              return Column(
                children: [
                  const Center(
                    child: Text(
                      'Keine Berechtigung auf diese Seite',
                      style: TextStyle(
                          color: StyleGuide.kColorRed,
                          fontSize: StyleGuide.kTextSizeExxxtraLarge),
                    ),
                  ),
                  StyleGuide.SizeBoxHeight32,
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/calendar');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          StyleGuide.kColorSecondaryBlue),
                    ),
                    child: const Text(
                      'Zurück zur Startseite',
                      style: TextStyle(
                          color: StyleGuide.kColorWhite,
                          fontSize: StyleGuide.kTextSizeLarge),
                    ),
                  ),
                ],
              );
            }
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

  Widget buildVerification(User user) {
    return Scaffold(
      appBar: StyleGuide.kPrimaryAppbar(title: "Historie"),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: StyleGuide.kPaddingAll,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Switch(
                    value: switchButton,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchButton = newValue;
                      });
                      if (!switchButton) {
                        Get.toNamed('/verification');
                      }
                    },
                    activeTrackColor: StyleGuide.kColorSecondaryBlue,
                  ),
                  StyleGuide.SizeBoxHeight16,
                  const Center(
                    child: Text(
                      'Wechsel zur Verifizierung',
                      style: TextStyle(color: StyleGuide.kColorSecondaryBlue),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 20,
              child: ListView.builder(
                itemCount: calendarEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  Calendar calendar = calendarEntries[index];
                  //Erstellt nur Karten die den Status [AKZEPTIERT][ABGELEHNT] haben
                  if (calendar.status == 'AKZEPTIERT' ||
                      calendar.status == 'ABGELEHNT') {
                    User creator = allUsers.firstWhere(
                        (user) => user.id == calendar.userId,
                        orElse: () => User(
                              id: 'Nicht gefunden',
                              firstName: 'Nicht gefunden',
                              lastName: 'Nicht gefunden',
                              priority: null,
                              deputy: null,
                            ));
                    return Padding(
                      padding: StyleGuide.kPaddingVertical,
                      child: Card(
                        //Design und Struktur der einzelnen Karten
                        child: ListTile(
                          tileColor:
                              getStatusColor().tileColor(calendar.status),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: const Icon(Icons.calendar_today),
                          title: Text(
                            '${calendar.title}',
                            style: const TextStyle(
                              fontSize: StyleGuide.kTextSizeLarge,
                              color: StyleGuide.kColorWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Ersteller: ${creator.firstName} ${creator.lastName} \n'
                            'Ferien Datum: ${calendar.startDate} - ${calendar.endDate}\n'
                            'Stellvertretung: ${creator.deputy?.firstName ?? 'nicht'} ${creator.deputy?.firstName ?? 'vorhanden'}\n'
                            'Status: ${calendar.status}\n'
                            'Erstellt am: ${calendar.createdAt}\n'
                            'Priorität: ${creator.priority?.points}',
                            style: const TextStyle(
                              fontSize: StyleGuide.kTextSizeMedium,
                              color: StyleGuide.kColorWhite,
                            ),
                          ),
                          //setzt Id um den Eintrag zu akzeptieren oder abzulehnen
                          onTap: () {
                            setState(() {
                              CalendarId = calendar.id;
                              selectedCalendarIndex = index;
                            });
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //Löschen von einträgen
                              IconButton(
                                iconSize: 32,
                                color: StyleGuide.kColorBlack,
                                onPressed: () {
                                  //TODO: Provisorisch bis Zeit da ist um es korrekt zu implementieren
                                  HttpService()
                                      .removeCalendarEntryFromList(calendar.id);
                                  setState(() {
                                    calendarEntries.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
