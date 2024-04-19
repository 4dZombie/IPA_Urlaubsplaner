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

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleGuide.kSecondaryAppbar(title: 'Login'),
      backgroundColor: StyleGuide.kColorWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: StyleGuide.kPaddingAll,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                EmailTextFormField(
                  controller: emailController,
                  suffixIcon: const Icon(Icons.email),
                  isMandatory: true,
                  hint: 'max@muster.ch',
                  label: 'Email',
                ),
                StyleGuide.SizeBoxHeight8,
                PasswordTextFormField(
                  controller: passwordController,
                  suffixIcon: const Icon(Icons.lock),
                  isMandatory: true,
                  hint: 'Mindestens 8 Zeichen',
                  label: 'Passwort',
                ),
                StyleGuide.SizeBoxHeight16,
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
                RegisterLoginButton(
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
