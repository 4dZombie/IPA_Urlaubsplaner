import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

import '../../../models/calendar/Calendar.dart';
import '../../../models/user/User.dart';
import '../../../services/httpService/HttpService.dart';
import '../../../widgets/drawer/Drawer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<User> currentUser;
  List<Calendar> calendarEntries = [];
  bool switchButton = true;

  ///[initState] wird aufgerufen wenn das Widget erstellt wird
  ///Es wird der aktuelle User geladen mit der Methode [getCurrentUserId]
  /// diese wird benötingt um zu überprüfen ob der User ein Admin ist
  ///
  @override
  void initState() {
    super.initState();
    currentUser = HttpService().getCurrentUserId();
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
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text("Test"),
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
