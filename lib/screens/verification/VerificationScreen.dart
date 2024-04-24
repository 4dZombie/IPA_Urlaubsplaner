import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

import '../../models/calendar/Calendar.dart';
import '../../models/user/User.dart';
import '../../services/httpService/HttpService.dart';
import '../../widgets/color/StatusColor.dart';
import '../../widgets/drawer/Drawer.dart';

class VerificationScreen extends StatefulWidget {
  VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Future<User> currentUser;
  List<Calendar> calendarEntries = [];
  late List<User> allUsers = [];
  bool switchButton = false;
  late String CalendarId;
  int? selectedCalendarIndex;

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

  void fetchAllUsers() async {
    allUsers = await HttpService().getAllUsers();
  }

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

  Future<void> preValidation() async {
    if (CalendarId.isNotEmpty) {
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
  }

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
                          fontSize: StyleGuide.kTextSizeExxtraLarge),
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
                    fontSize: StyleGuide.kTextSizeExxtraLarge),
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
              child: ListView.builder(
                itemCount: calendarEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  Calendar calendar = calendarEntries[index];
                  User creator =
                      allUsers.firstWhere((user) => user.id == calendar.userId,
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
                      color: selectedCalendarIndex == index
                          ? StyleGuide.kColorSecondaryBlue
                          : StyleGuide.kColorGrey,
                      child: ListTile(
                        tileColor: getStatusColor().tileColor(calendar.status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: const Icon(Icons.calendar_today),
                        title: Text('${calendar.title}'),
                        subtitle:
                            Text('${creator.firstName} ${creator.lastName}'),
                        // onTap: () {
                        //   setState({
                        //     CalendarId = calendar.id;
                        //     selectedCalendarIndex = index;
                        //   });
                        // }
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
