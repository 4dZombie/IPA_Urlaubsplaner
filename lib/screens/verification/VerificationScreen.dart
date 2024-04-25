import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

import '../../models/calendar/Calendar.dart';
import '../../models/user/User.dart';
import '../../services/httpService/HttpService.dart';
import '../../widgets/color/StatusColor.dart';
import '../../widgets/drawer/Drawer.dart';

///[VerificationScreen] ist die Klasse für die Verifizierung der Einträge
///Es wird überprüft ob der User ein Admin ist, wenn ja wird die Seite angezeigt
///Wenn nicht wird eine Fehlermeldung angezeigt
class VerificationScreen extends StatefulWidget {
  VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Future<User> currentUser;
  List<Calendar> calendarEntries = [];
  late List<User> allUsers = [];
  late String CalendarId;
  int? selectedCalendarIndex;
  bool switchButton = false;

  ///[initState] wird aufgerufen wenn das Widget erstellt wird
  ///Es wird der aktuelle User geladen mit der Methode [getCurrentUserId]
  /// diese wird benötingt um zu überprüfen ob der User ein Admin ist
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

  ///[refreshCalendarEntries] lädt alle Kalendereinträge auf aufruf wieder
  ///nicht sehr effizient soll zukünfitig entfernt werden und mit einem Provider ersetzt werden
  Future<void> refreshCalendarEntries() async {
    try {
      List<Calendar> allCalendarEntries = await HttpService().allUserCalendar();
      setState(() {
        calendarEntries = allCalendarEntries;
      });
    } catch (error) {
      print('Error refreshing calendar entries: $error');
    }
  }

  ///[preValidation] überprüft ob ein Eintrag um dem Admin einen Hinweis zugeben ob dieser Eintrag Angenommen werden sollte
  Future<void> preValidation() async {
    bool result = await HttpService().preCheckEntry();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? 'Eintrag erfolgreich vorvalidiert.'
              : 'Eintrag konnte nicht vorvalidiert werden.',
        ),
      ),
    );
    if (result) {
      refreshCalendarEntries();
    }
  }

  /// [declineEntry] lehnt einen Eintrag ab
  Future<void> declineEntry(String CalendarId) async {
    if (CalendarId.isNotEmpty) {
      bool result = await HttpService().declineEntry(CalendarId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result
                ? 'Eintrag erfolgreich abgelehnt.'
                : 'Eintrag konnte nicht abgelehnt werden.',
          ),
        ),
      );
      if (result) {
        refreshCalendarEntries();
      }
    }
  }

  /// [acceptEntry] akzeptiert einen Eintrag
  Future<void> acceptEntry(String CalendarId) async {
    if (CalendarId.isNotEmpty) {
      bool result = await HttpService().acceptEntry(CalendarId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result
                ? 'Eintrag erfolgreich akzeptiert.'
                : 'Eintrag konnte nicht akzeptiert werden.',
          ),
        ),
      );
      if (result) {
        refreshCalendarEntries();
      }
    }
  }

  /// [FutureBuilder] wird verwendet um den aktuellen User zu laden
  /// Wenn der User geladen wurde wird überprüft ob der User ein Admin ist
  /// Wenn ja wird die Seite angezeigt
  /// sonst wird eine fehlermeldung angezeigt
  /// Wenn der User noch nicht geladen wurde wird ein Ladekreis angezeigt
  /// [buildVerification] wird aufgerufen wenn der User geladen wurde und zeigt die Seite an
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
      appBar: StyleGuide.kPrimaryAppbar(title: "Verifizierung"),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: StyleGuide.kPaddingAll,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // um Zwischen Verifizierung und Historie zu wechseln
                  Switch(
                    value: switchButton,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchButton = newValue;
                      });
                      if (switchButton) {
                        Get.toNamed('/history');
                      }
                    },
                    inactiveTrackColor: StyleGuide.kColorGrey,
                  ),
                  StyleGuide.SizeBoxHeight16,
                  const Center(
                    child: Text(
                      'Wechsel zur Eintragshistorie',
                      style: TextStyle(color: StyleGuide.kColorSecondaryBlue),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 20,
              // Erstellt eine Liste mit allen Kalendereinträgen
              child: ListView.builder(
                itemCount: calendarEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  Calendar calendar = calendarEntries[index];

                  if (calendar.status == 'KEINE_STELLVERTRETUNG' ||
                      calendar.status == 'IN_BEARBEITUNG' ||
                      calendar.status == 'VORLAEUFIG_AKZEPTIERT' ||
                      calendar.status == 'VORLAEUFIG_ABGELEHNT') {
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
                              IconButton(
                                iconSize: 32,
                                color: StyleGuide.kColorRed,
                                onPressed: () {
                                  declineEntry(calendar.id);
                                },
                                icon: const Icon(Icons.close),
                              ),
                              // Wenn der Status KEINE_STELLVERTRETUNG ist wird eine Warnung angezeigt damit der Benutzer nochmals darauf hingewisen ist
                              IconButton(
                                iconSize: 32,
                                color: StyleGuide.kColorPrimaryGreen,
                                onPressed: () {
                                  if (calendar.status ==
                                      'KEINE_STELLVERTRETUNG') {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // Benutzer muss Dialog schließen
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text('Bestätigung'),
                                          content: const Text(
                                              'Bist du sicher das du diesen Eintrag akzeptieren möchtest?, es gibt keine Stellvertretung'),
                                          actions: <Widget>[
                                            TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        StyleGuide
                                                            .kColorPrimaryGreen),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                'Ja',
                                                style: TextStyle(
                                                    color: StyleGuide
                                                        .kColorSecondaryBlue),
                                              ),
                                              onPressed: () {
                                                acceptEntry(calendar.id);
                                                Get.back();
                                              },
                                            ),
                                            TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        StyleGuide.kColorGrey),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                              ),
                                              child: const Text('Abbrechen',
                                                  style: TextStyle(
                                                      color: StyleGuide
                                                          .kColorSecondaryBlue)),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    acceptEntry(calendar.id);
                                  }
                                },
                                icon: const Icon(Icons.check),
                              ),
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
      // Vorvalidierung von allen Einträgen die noch nicht Akzeptiert oder Abgelehnt sind
      floatingActionButton: FloatingActionButton(
        onPressed: preValidation,
        backgroundColor: StyleGuide.kColorPrimaryGreen,
        child: const Icon(Icons.check, color: StyleGuide.kColorWhite),
      ),
    );
  }
}
