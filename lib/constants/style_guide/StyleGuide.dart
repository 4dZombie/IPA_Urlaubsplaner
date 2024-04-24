// ignore_for_file: file_names, non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

/// StyleGuide enthält alle Konstanten die für das Design der App benötigt werden
class StyleGuide {
  static const kMandatoryText = '*';

  //Farben von Figma & Corporate Design übernommen
  static const kColorPrimaryGreen = Color.fromRGBO(175, 202, 11, 1);
  static const kColorSecondaryBlue = Color.fromRGBO(41, 35, 92, 1);
  static const kColorRed = Color.fromRGBO(240, 4, 4, 1);
  static const kColorWhite = Color.fromRGBO(255, 255, 255, 1);
  static const kColorBlack = Color.fromRGBO(0, 0, 0, 1);
  static const kColorGrey = Color.fromRGBO(196, 196, 196, 1);
  static const kColorLink = Color.fromRGBO(40, 163, 233, 1);
  static const kColorOrange = Color.fromRGBO(255, 165, 0, 1);

  //Appbars für die verschiedenen Screens mit der Pflicht einen Titel anzugeben

  //diese Appbar hat einen Banner und wird auf allen Screens benutzt die nicht login / register sind
  static AppBar kPrimaryAppbar({required String title}) {
    return AppBar(
      backgroundColor: kColorPrimaryGreen,
      title: Text(title, style: const TextStyle(color: kColorSecondaryBlue)),
      centerTitle: true,
      //elevation: 0,
    );
  }

  // Diese Appbar hat kein Banner und wird auf den login / register Screens benutzt
  static AppBar kSecondaryAppbar({required String title}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(title, style: const TextStyle(color: kColorSecondaryBlue)),
      centerTitle: true,
      elevation: 0, //setzt schatten auf 0
    );
  }

  //Schriftgrössen

  static const kTextSizeSmall = 12.0; //Link
  static const kTextSizeMedium = 16.0; //Textfelder
  static const kTextSizeLarge = 20.0; //Labels
  static const kTextSizeExtraLarge = 24.0; //Überschriften Appbar
  static const kTextSizeExxtraLarge = 48.0; //Überschriften Willkommenstext

  ///InputDecoration für die Textfelder

  static InputDecoration kInputDecoration({
    required String label,
    String? hint,
    bool? isMandatory,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      //Wenn das Feld Pflicht ist, wird ein * angezeigt
      labelText: isMandatory != null && isMandatory == true
          ? label + kMandatoryText
          : label,
      hintText: hint,
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(
        fontSize: kTextSizeMedium,
        color: kColorGrey,
      ),
      //Farben für die verschiedenen Zustände des Textfeldes
      floatingLabelStyle:
          const TextStyle(fontSize: kTextSizeLarge, color: kColorSecondaryBlue),
      //Wenn das Feld aktiv ist
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kColorPrimaryGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      //Wenn das Feld nicht aktiv ist
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kColorSecondaryBlue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      //Wenn das Feld einen Fehler hat
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kColorRed, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      //Wenn das Feld einen Fehler hat und aktiv ist
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kColorSecondaryBlue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Sizeboxes

  //Höhe
  static const SizedBox SizeBoxHeight8 = SizedBox(height: 8);
  static const SizedBox SizeBoxHeight16 = SizedBox(height: 16);
  static const SizedBox SizeBoxHeight32 = SizedBox(height: 32);
  static const SizedBox SizeBoxHeight48 = SizedBox(height: 48);
  //Breite
  static const SizedBox SizeBoxWidth8 = SizedBox(width: 8);
  static const SizedBox SizeBoxWidth16 = SizedBox(width: 16);
  static const SizedBox SizeBoxWidth32 = SizedBox(width: 32);
  static const SizedBox SizeBoxWidth48 = SizedBox(width: 48);

  // Padding
  //Padding um die gesamte App
  static const EdgeInsets kPaddingAll = EdgeInsets.all(32);
  static const EdgeInsets kPaddingHorizontal =
      EdgeInsets.symmetric(horizontal: 8, vertical: 2);
  static const EdgeInsets kPaddingVertical =
      EdgeInsets.symmetric(vertical: 8, horizontal: 2);

  ///Benachrichtigungen am unteren Bildschirmrand mit einer Snackbar

  // Allgeimene Aussagen

  static const kSnackBarSuccess = SnackBar(
    content: Text(
      'Erfolgreich',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorPrimaryGreen,
  );

  static const kSnackBarError = SnackBar(
    content: Text(
      'Es ist ein Fehler aufgetreten',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorRed,
  );

  //Login

  //Erfolgreiches Login
  static const kSnackBarLoginSuccess = SnackBar(
    content: Text(
      'Login erfolgreich',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorPrimaryGreen,
  );

  //Fehlerhaftes Login
  static const kSnackBarLoginError = SnackBar(
    content: Text(
      'Bitte überprüfe deine Daten',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorRed,
  );

  // Register

  //Erfolgreiche Registrierung
  static const kSnackBarRegisterSuccess = SnackBar(
    content: Text(
      'Register erfolgreich',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorPrimaryGreen,
  );

  //Fehlerhafte Registrierung
  static const kSnackBarRegisterError = SnackBar(
    content: Text(
      'Bitte überprüfe deine Daten',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorRed,
  );

  static const kSnackBarCreatedSuccess = SnackBar(
    content: Text(
      'Kalendereintrag erfolgreich erstellt',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorPrimaryGreen,
  );

  //Fehlerhaftes Login
  static const kSnackBarCreatedError = SnackBar(
    content: Text(
      'Der Kalendereintrag konnte nicht erstellt werden',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorRed,
  );

  static const kSnackBarCreatedDuplicate = SnackBar(
    content: Text(
      'Es existiert bereits ein Kalendereintrag für diesen Zeitraum',
      style: TextStyle(
        color: kColorWhite,
        fontSize: kTextSizeMedium,
      ),
    ),
    backgroundColor: kColorRed,
  );
}
