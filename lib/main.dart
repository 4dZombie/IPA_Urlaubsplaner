//Import von Paketen
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/screens/calendar/CalendarScreen.dart';
//Import von Klassen
import 'package:ipa_urlaubsplaner/screens/login/LoginScreen.dart';
import 'package:ipa_urlaubsplaner/screens/register/RegisterScreen.dart';
import 'package:ipa_urlaubsplaner/screens/settings/SettingsScreen.dart';
import 'package:ipa_urlaubsplaner/screens/verification/VerificationScreen.dart';

// FlutterBinding stellt sicher das die App korrekt initialisiert wird
// dotenv.load lädt die .env Datei
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen()),
        GetPage(name: "/register", page: () => const RegisterScreen()),
        GetPage(name: "/calendar", page: () => const CalendarScreen()),
        GetPage(name: "/settings", page: () => const SettingScreen()),
        GetPage(name: "/verification", page: () => const VerificationScreen()),
      ],
      title: "IPA Urlaubsplaner",
      debugShowCheckedModeBanner: false,
    );
  }
}
