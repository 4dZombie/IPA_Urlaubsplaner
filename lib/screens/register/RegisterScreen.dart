import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/style_guide/StyleGuide.dart';
import '../../services/httpService/HttpService.dart';
import '../../widgets/buttons/login_registration/RegisterButton.dart';
import '../../widgets/textformfields/Employment/EmploymentTextFormField.dart';
import '../../widgets/textformfields/booleans/CheckboxTextFormField.dart';
import '../../widgets/textformfields/dates/DatePickerTextFormField.dart';
import '../../widgets/textformfields/district/DistrictNumberTextFormField.dart';
import '../../widgets/textformfields/dropdowns/DropDownTextFormField.dart';
import '../../widgets/textformfields/names/NameTextFromField.dart';
import '../../widgets/textformfields/names_with_numbers_specialChars/AddressTextFormField.dart';
import '../../widgets/textformfields/names_with_numbers_specialChars/EmailTextFormField.dart';
import '../../widgets/textformfields/password/PasswordConfirmTextFormField.dart';
import '../../widgets/textformfields/password/PasswordTextFormField.dart';

/// RegisterScreen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  /// createState Methode um den State des RegisterScreens zu erstellen
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

/// State des RegisterScreens
class _RegisterScreenState extends State<RegisterScreen> {
  // isLoading: Wenn true, wird der Button deaktiviert
  bool isLoading = false;
  // _formKey: Key für das Formular zum Validieren der Textfelder
  final _formKey = GlobalKey<FormState>();
  // Controller für die Textfelder
  final TextEditingController companyController = TextEditingController();
  final TextEditingController firsNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController districtNumberController =
      TextEditingController();
  final TextEditingController districtNameController = TextEditingController();
  final TextEditingController employmentController = TextEditingController();
  final TextEditingController rankController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController yearsOfServiceController =
      TextEditingController();
  final TextEditingController kidsController = TextEditingController();
  final TextEditingController studentController = TextEditingController();

  // FocusNodes für die textfields und den button
  final FocusNode companyFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode passwordConfirmFocusNode = FocusNode();
  final FocusNode birthdateFocusNode = FocusNode();
  final FocusNode streetFocusNode = FocusNode();
  final FocusNode districtNameFocusNode = FocusNode();
  final FocusNode districtNumberFocusNode = FocusNode();
  final FocusNode yearsOfServiceFocusNode = FocusNode();
  final FocusNode employmentFocusNode = FocusNode();
  final FocusNode rankFocusNode = FocusNode();
  final FocusNode kidsFocusNode = FocusNode();
  final FocusNode studentFocusNode = FocusNode();
  final FocusNode buttonFocusNode = FocusNode();

  /// Dispose der Controller und FocusNodes das macht das Programm schneller und verhindert memoryleaks
  @override
  void dispose() {
    companyController.dispose();
    firsNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    streetController.dispose();
    districtNumberController.dispose();
    districtNameController.dispose();
    employmentController.dispose();
    rankController.dispose();
    birthdateController.dispose();
    yearsOfServiceController.dispose();
    kidsController.dispose();
    studentController.dispose();
    companyFocusNode.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
    birthdateFocusNode.dispose();
    streetFocusNode.dispose();
    districtNameFocusNode.dispose();
    districtNumberFocusNode.dispose();
    yearsOfServiceFocusNode.dispose();
    employmentFocusNode.dispose();
    rankFocusNode.dispose();
    kidsFocusNode.dispose();
    studentFocusNode.dispose();
    buttonFocusNode.dispose();
    super.dispose();
  }

  /// Funktion zum Registrieren
  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // try-catch Block um Fehler abzufangen
      try {
        String company = companyController.text;
        String firstName = firsNameController.text;
        String lastName = lastNameController.text;
        String email = emailController.text;
        String password = passwordController.text;
        String confirmPassword = passwordConfirmController.text;
        String street = streetController.text;
        String districtNumber = districtNumberController.text;
        String districtName = districtNameController.text;
        String employment = employmentController.text;
        String rank = rankController.text;
        String birthdate = birthdateController.text;
        String yearsOfService = yearsOfServiceController.text;
        bool kids = kidsController.text.toLowerCase() == 'true' ? true : false;
        bool student =
            studentController.text.toLowerCase() == 'true' ? true : false;

        HttpService httpService = HttpService();
        await httpService.registerUser(
          company,
          firstName,
          lastName,
          email,
          password,
          confirmPassword,
          street,
          districtNumber,
          districtName,
          employment,
          rank,
          birthdate,
          yearsOfService,
          kids,
          student,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// UI vom RegisterScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleGuide.kSecondaryAppbar(title: 'Registrierung'),
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
                  Icons.lock_outlined,
                  size: 100,
                  color: StyleGuide.kColorGrey,
                ),
                StyleGuide.SizeBoxHeight32,
                // Textfelder für die Registrierung
                NameTextFormField(
                  controller: companyController,
                  focusNode: companyFocusNode,
                  label: 'Firma',
                  hint: 'Name der Firma',
                  suffixIcon: const Icon(Icons.business),
                ),
                StyleGuide.SizeBoxHeight16,
                NameTextFormField(
                  controller: firsNameController,
                  focusNode: firstNameFocusNode,
                  label: 'Vorname',
                  hint: 'Max',
                  suffixIcon: const Icon(Icons.person),
                ),
                StyleGuide.SizeBoxHeight16,
                NameTextFormField(
                  controller: lastNameController,
                  focusNode: lastNameFocusNode,
                  label: 'Familienname',
                  hint: 'Muster',
                  suffixIcon: const Icon(Icons.person),
                ),
                StyleGuide.SizeBoxHeight16,
                EmailTextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  suffixIcon: const Icon(Icons.email),
                  hint: 'max@muster.ch',
                  label: 'Email',
                ),
                StyleGuide.SizeBoxHeight16,
                PasswordTextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  suffixIcon: const Icon(Icons.lock),
                  hint: 'Passwort muss mindestens 8 Zeichen lang sein',
                  label: 'Passwort',
                ),
                StyleGuide.SizeBoxHeight16,
                PasswordConfirmTextFormField(
                  passwordController: passwordController,
                  controller: passwordConfirmController,
                  focusNode: passwordConfirmFocusNode,
                  label: 'Passwort bestätigen',
                  hint: 'Passwort muss übereinstimmen',
                  suffixIcon: const Icon(Icons.check),
                ),
                StyleGuide.SizeBoxHeight16,
                DateTextFormField(
                  controller: birthdateController,
                  focusNode: birthdateFocusNode,
                  label: 'Geburtsdatum',
                  hint: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
                StyleGuide.SizeBoxHeight16,
                NameNumberTextFormField(
                    controller: streetController,
                    focusNode: streetFocusNode,
                    label: 'Strasse',
                    hint: 'Musterstrasse 1',
                    suffixIcon: const Icon(Icons.signpost)),
                StyleGuide.SizeBoxHeight16,
                DistrictNumberTextFormField(
                    controller: districtNumberController,
                    focusNode: districtNumberFocusNode,
                    label: 'Postleitzahl',
                    hint: '5000',
                    suffixIcon: const Icon(Icons.location_on)),
                StyleGuide.SizeBoxHeight16,
                NameNumberTextFormField(
                    controller: districtNameController,
                    focusNode: districtNameFocusNode,
                    label: 'Gemeinde',
                    hint: 'Aarau',
                    suffixIcon: const Icon(Icons.location_city)),
                StyleGuide.SizeBoxHeight16,
                DateTextFormField(
                    controller: yearsOfServiceController,
                    focusNode: yearsOfServiceFocusNode,
                    label: 'Einstellungsdatum',
                    hint: 'YYYY-MM-DD',
                    suffixIcon: const Icon(Icons.calendar_month)),
                StyleGuide.SizeBoxHeight16,
                EmploymentNumberTextFormField(
                    controller: employmentController,
                    focusNode: employmentFocusNode,
                    label: 'Beschäftigungsgrad',
                    hint: 'Maximal 100',
                    suffixIcon: const Icon(Icons.work_history)),
                StyleGuide.SizeBoxHeight16,
                RankTextFormField(
                    controller: rankController,
                    focusNode: rankFocusNode,
                    label: 'Position',
                    hint: 'DEV, SUPPORT, ADMINISTRATION, LEADER',
                    suffixIcon: const Icon(Icons.work)),
                StyleGuide.SizeBoxHeight16,
                BooleanTextFormField(
                  initialValue: false,
                  controller: kidsController,
                  focusNode: kidsFocusNode,
                  label: 'Hast du Kinder im Schulalter?',
                ),
                StyleGuide.SizeBoxHeight16,
                BooleanTextFormField(
                  initialValue: false,
                  controller: studentController,
                  focusNode: studentFocusNode,
                  label: 'Besuchst du aktuell eine Schule?',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      focusNode: buttonFocusNode,
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      child: const Text(
                        'Zurück zum login',
                        style: TextStyle(
                            fontSize: StyleGuide.kTextSizeSmall,
                            color: StyleGuide.kColorLink),
                      ),
                    ),
                  ],
                ),
                // Button zum Registrieren
                RegisterLoginButton(
                    // Wenn isLoading true ist, wird die Funktion nicht ausgeführt
                    // Wenn isLoading false ist, wird die Funktion ausgeführt
                    function: isLoading ? () {} : registerUser,
                    // Text wird angepasst
                    text: isLoading ? 'Lädt...' : 'Registrierung',
                    suffixIcon: const Icon(
                      Icons.how_to_reg,
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
