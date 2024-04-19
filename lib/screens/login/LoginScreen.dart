import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';
import 'package:ipa_urlaubsplaner/services/httpService/HttpService.dart';

import '../../widgets/buttons/login_registration/RegisterButton.dart';
import '../../widgets/textformfields/names_with_numbers_specialChars/EmailTextFormField.dart';
import '../../widgets/textformfields/password/PasswordTextFormField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/// State des LoginScreens
class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false; // isLoading: Wenn true, wird der Button deaktiviert
  final _formKey = GlobalKey<
      FormState>(); // _formKey: Key für das Formular zum Validieren der Textfelder
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

// FocusNodes für die Textfelder und den Button
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode buttonFocusNode = FocusNode();

  /// Dispose der Controller und FocusNodes das macht das Programm schneller und verhindert memoryleaks
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    buttonFocusNode.dispose();
    super.dispose();
  }

  /// Funktion zum Einloggen
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String email = emailController.text;
        String password = passwordController.text;
        HttpService httpService = HttpService();
        await httpService.loginUser(email, password);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// UI vom LoginScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleGuide.kSecondaryAppbar(title: 'Login'),
      backgroundColor: StyleGuide.kColorWhite,
      // SingleChildScrollView: Damit die Tastatur das UI nicht überdeckt
      body: SingleChildScrollView(
        child: Padding(
          padding: StyleGuide.kPaddingAll,
          child: Form(
            // Formular zum Validieren der Textfelder
            // Wenn die Funktion loginUser() ausgeführt wird, wird das Formular validiert
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // UI zentrieren
              children: [
                const Icon(
                  Icons.lock_open_rounded,
                  size: 100,
                  color: StyleGuide.kColorGrey,
                ),
                StyleGuide.SizeBoxHeight32,
                const Text(
                  'Willkommen zum Urlaubsplaner!',
                  style: TextStyle(
                    fontSize: StyleGuide.kTextSizeExxtraLarge,
                    color: StyleGuide.kColorSecondaryBlue,
                  ),
                ),
                StyleGuide.SizeBoxHeight48,
                // Textfelder für Benutzereingabe
                EmailTextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  suffixIcon: const Icon(Icons.email),
                  isMandatory: true,
                  hint: 'max@muster.ch',
                  label: 'Email',
                ),
                StyleGuide.SizeBoxHeight16,
                PasswordTextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  suffixIcon: const Icon(Icons.lock),
                  isMandatory: true,
                  hint: 'Mindestens 8 Zeichen',
                  label: 'Passwort',
                ),
                StyleGuide.SizeBoxHeight16,
                // Link zur Registrierung
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Noch kein Account? ',
                      style: TextStyle(
                        fontSize: StyleGuide.kTextSizeSmall,
                      ),
                    ),
                    TextButton(
                      focusNode: buttonFocusNode,
                      onPressed: () {
                        Get.toNamed('/register');
                      },
                      child: const Text(
                        'Registriere dich hier',
                        style: TextStyle(
                            fontSize: StyleGuide.kTextSizeSmall,
                            color: StyleGuide.kColorLink),
                      ),
                    ),
                  ],
                ),
                // Button zum Einloggen
                RegisterLoginButton(
                    // Wenn isLoading true ist, wird die Funktion nicht ausgeführt
                    // Wenn isLoading false ist, wird die Funktion ausgeführt
                    // Text wird angepasst
                    function: isLoading ? () {} : loginUser,
                    text: isLoading ? 'Lädt...' : 'Login',
                    suffixIcon: const Icon(
                      Icons.login,
                      color: StyleGuide.kColorWhite,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
