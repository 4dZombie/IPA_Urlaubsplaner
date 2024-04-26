import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';
import 'package:ipa_urlaubsplaner/services/httpService/HttpService.dart';

import '../../models/user/User.dart';
import '../../widgets/drawer/Drawer.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<User> userList = [];
  User? selectedUser;
  late Future<User> currentUser;
  String? selectedUserId;
  final TextEditingController holidayController = TextEditingController();

  /// [dispose] wird aufgerufen wenn das Widget zerstört wird
  /// [holidayController] wird gelöscht
  /// Das ist wichtig um Memoryleaks zu vermeiden
  @override
  void dispose() {
    holidayController.dispose();
    super.dispose();
  }

  ///[initState] wird aufgerufen wenn das Widget erstellt wird
  ///Es wird der aktuelle User geladen [getCurrentUserId]
  /// und alle User [getAllUsers]
  @override
  void initState() {
    super.initState();
    currentUser = HttpService().getCurrentUserId();
    HttpService().getAllUsers().then((users) {
      setState(() {
        userList = users;
        selectedUserId = userList.isNotEmpty ? userList[0].id : null;
      });
    });
  }

  ///[FutureBuilder] wird verwendet um den aktuellen User zu laden
  ///[buildSettings] wird aufgerufen wenn der User geladen worden ist
  ///[buildSettings] baut die Seite auf
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            User currentUser = snapshot.data!;
            return buildSettings(currentUser);
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

  ///[buildSettings] baut die Seite auf
  ///[User user] wird übergeben damit die App weiss welcher User eingeloggt ist
  @override
  Widget buildSettings(User user) {
    /// Wie in der [HistoryScreen] wird hier überprüft ob der User Admin ist
    bool isUserAdmin = user.roles?.any((role) => role.name == 'ADMIN') ?? false;
    return Scaffold(
      appBar: StyleGuide.kPrimaryAppbar(title: "Einstellungen"),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: StyleGuide.kPaddingAll,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(
                    //Text links vom Dropdownfeld
                    child: Text(
                      'Wähle einen Benutzer:',
                      style: TextStyle(
                        fontSize: StyleGuide.kTextSizeMedium,
                        color: StyleGuide.kColorSecondaryBlue,
                      ),
                    ),
                  ),
                  Expanded(
                    ///Dropdownfeld klicken um Benutzer auszuwählen
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedUserId,
                      onChanged: (String? newUserId) {
                        setState(() {
                          selectedUserId = newUserId;
                          selectedUser = userList.firstWhere(
                              (user) => user.id == newUserId,
                              orElse: () => User(id: ''));
                        });
                      },

                      ///Liste der Benutzer
                      ///[userList] wird durchgegangen und die Benutzer werden in das Dropdownfeld eingefügt
                      /// und vor und nachname werden angezeigt
                      items:
                          userList.map<DropdownMenuItem<String>>((User user) {
                        return DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(
                              ('${user.firstName ?? ''} ${user.lastName ?? ''}')
                                  .trim()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            ///[holidayController] wird verwendet um die Urlaubstage zu speichern
            if (isUserAdmin) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: holidayController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9 .]')),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: StyleGuide.kInputDecoration(
                        label: 'Urlaubstage',
                        hint: 'Urlaubstage',
                        isMandatory: false,
                      ),
                      style: const TextStyle(
                        fontSize: StyleGuide.kTextSizeMedium,
                        color: StyleGuide.kColorSecondaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Padding(
              padding: StyleGuide.kPaddingAll,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      ///[selectedUser] wird überprüft ob ein Benutzer ausgewählt wurde
                      ///[setDeputy] wird aufgerufen und der Benutzer wird zur Stellvertretung gesetzt anhand der ID
                      if (selectedUser != null) {
                        String userId = selectedUser!.id;
                        HttpService().setDeputy(userId).then((success) {
                          if (success == true) {
                            ScaffoldMessenger.of(Get.context!)
                                .showSnackBar(StyleGuide.kSnackBarSuccess);
                          } else {
                            ScaffoldMessenger.of(Get.context!)
                                .showSnackBar(StyleGuide.kSnackBarError);
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          StyleGuide.kColorPrimaryGreen),
                    ),
                    child: const Text(
                      'Setzt Benutzer zur Stellvertretung',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: StyleGuide.kTextSizeMedium,
                      ),
                    ),
                  ),

                  ///[isUserAdmin] prüft ob der aktuelle Benutzer Admin ist und nur für diesen wird der Button angezeigt
                  if (isUserAdmin) ...[
                    TextButton(
                      onPressed: () {
                        if (selectedUser != null) {
                          String userId = selectedUser!.id;
                          HttpService().setAdmin(userId).then((success) {
                            if (success == true) {
                              ScaffoldMessenger.of(Get.context!)
                                  .showSnackBar(StyleGuide.kSnackBarSuccess);
                            } else {
                              ScaffoldMessenger.of(Get.context!)
                                  .showSnackBar(StyleGuide.kSnackBarError);
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            StyleGuide.kColorPrimaryGreen),
                      ),
                      child: const Text(
                        'Setzt Benutzer zur Admin Rolle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: StyleGuide.kTextSizeMedium,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedUser != null) {
                          String userId = selectedUser!.id;
                          HttpService().setClient(userId).then((success) {
                            if (success == true) {
                              ScaffoldMessenger.of(Get.context!)
                                  .showSnackBar(StyleGuide.kSnackBarSuccess);
                            } else {
                              ScaffoldMessenger.of(Get.context!)
                                  .showSnackBar(StyleGuide.kSnackBarError);
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            StyleGuide.kColorPrimaryGreen),
                      ),
                      child: const Text(
                        'Setzt Benutzer zur Client Rolle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: StyleGuide.kTextSizeMedium,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedUser != null) {
                          String userId = selectedUser!.id;
                          HttpService()
                              .setHolidays(userId, holidayController.text)
                              .then((success) {
                            if (success == true) {
                              ScaffoldMessenger.of(Get.context!)
                                  .showSnackBar(StyleGuide.kSnackBarSuccess);
                            } else {
                              ScaffoldMessenger.of(Get.context!)
                                  .showSnackBar(StyleGuide.kSnackBarError);
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            StyleGuide.kColorPrimaryGreen),
                      ),
                      child: const Text(
                        'Speichere Benutzer Urlaubstage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: StyleGuide.kTextSizeMedium,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
