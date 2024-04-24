import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/style_guide/StyleGuide.dart';
import '../../models/user/User.dart';
import '../../screens/login/LoginScreen.dart';
import '../../services/httpService/HttpService.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

/// Drawer ist ein Widget, das ein Menü anzeigt, wenn der Benutzer das Hamburger-Icon in der App-Leiste anklickt.
class _DrawerWidgetState extends State<DrawerWidget> {
  late Future<User> currentUserFuture;

  @override
  void initState() {
    super.initState();
    currentUserFuture = HttpService().getCurrentUserId();
  }

  ///[drawerBuilder] ist ein Widget, das ein Menü anzeigt, wenn der Benutzer das Hamburger-Icon in der App Leiste anklickt.
  ///Es zeigt den Namen und die E-Mail-Adresse des Benutzers an und kann  zu anderen Seiten navigieren.
  @override
  Widget drawerBuilder(User user, BuildContext context) {
    return Drawer(
      child: ListView(
        //ListView ist ein Widget, das eine Liste von Kindern in einer scrollbaren Liste anzeigt damit auch kleine Displays alle Inhalte bekommen.
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: StyleGuide.kColorSecondaryBlue,
            ),
            accountName: Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(color: StyleGuide.kColorWhite),
            ),
            accountEmail: Text(
              '${user.email}',
              style: const TextStyle(color: StyleGuide.kColorWhite),
            ),
          ),
          Padding(
            padding: StyleGuide.kPaddingHorizontal,
            child: ListTile(
              //ListTile ist ein Widget, das eine Zeile in einer Liste anzeigt.
              title: const Text('Kalender'),
              hoverColor: StyleGuide.kColorPrimaryGreen,
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                Get.toNamed(
                    '/calendar'); //Get.toNamed navigiert zu einer benannten Route in diesem fall Kalender
              },
            ),
          ),
          Padding(
            padding: StyleGuide.kPaddingHorizontal,
            child: ListTile(
              title: const Text('Verifizierung'),
              hoverColor: StyleGuide.kColorPrimaryGreen,
              trailing: const Icon(Icons.verified),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                Get.toNamed('/verification');
              },
            ),
          ),
          Padding(
            padding: StyleGuide.kPaddingHorizontal,
            child: ListTile(
              title: const Text('Einstellungen'),
              hoverColor: StyleGuide.kColorPrimaryGreen,
              trailing: const Icon(Icons.settings),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                Get.toNamed('/settings');
              },
            ),
          ),
          Padding(
            padding: StyleGuide.kPaddingHorizontal,
            child: ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(color: StyleGuide.kColorRed),
              ),
              hoverColor: StyleGuide.kColorPrimaryGreen,
              trailing: const Icon(Icons.logout, color: StyleGuide.kColorRed),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                Get.offAll(() => LoginScreen());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: currentUserFuture,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return drawerBuilder(snapshot.data!, context);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
