//Import von Paketen
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/screens/calendar/CalendarScreen.dart';
import 'package:ipa_urlaubsplaner/screens/login/LoginScreen.dart';
import 'package:ipa_urlaubsplaner/screens/register/RegisterScreen.dart';
import 'package:ipa_urlaubsplaner/screens/settings/SettingsScreen.dart';
import 'package:ipa_urlaubsplaner/screens/verification/VerificationScreen.dart';
import 'package:ipa_urlaubsplaner/screens/verification/history/HistoryScreen.dart';

// FlutterBinding stellt sicher das die App korrekt initialisiert wird
// dotenv.load lädt die .env Datei
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// [GetMaterialApp] ist die Basis für die App
  /// Hier werden die Routen definiert
  /// Die App wird gestartet
  /// Der Titel der App wird gesetzt
  /// Der Debug Banner wird ausgeschaltet
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      // GetPage sorgt für die Navigation in der App
      // damit die App weiss welche Seite angezeigt werden soll
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen()),
        GetPage(name: "/register", page: () => const RegisterScreen()),
        GetPage(name: "/calendar", page: () => const CalendarScreen()),
        GetPage(name: "/settings", page: () => SettingScreen()),
        GetPage(name: "/verification", page: () => VerificationScreen()),
        GetPage(name: "/history", page: () => const HistoryScreen()),
      ],
      title: "IPA Urlaubsplaner",
      debugShowCheckedModeBanner: false,
    );
  }
}
