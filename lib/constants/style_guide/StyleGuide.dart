import 'package:flutter/material.dart';

class StyleGuide {
  //Farben von Figma & Corporate Design übernommen
  static const kColorPrimaryGreen = Color.fromRGBO(175, 202, 11, 1);
  static const kColorSecondaryBlue = Color.fromRGBO(41, 35, 92, 1);
  static const kColorRed = Color.fromRGBO(240, 4, 4, 1);
  static const kColorWhite = Color.fromRGBO(255, 255, 255, 1);
  static const kColorBlack = Color.fromRGBO(0, 0, 0, 1);
  static const kColorGrey = Color.fromRGBO(196, 196, 196, 1);

  //Appbars für die verschiedenen Screens mit der Pflicht einen Titel anzugeben

  //diese Appbar hat einen Banner und wird auf allen Screens benutzt die nicht login / register sind
  static AppBar kPrimaryAppbar({required String title}) {
    return AppBar(
      backgroundColor: kColorPrimaryGreen,
      title: Text(title, style: const TextStyle(color: kColorBlack)),
      centerTitle: true,
      //elevation: 0,
    );
  }

  // Diese Appbar hat kein Banner und wird auf den login / register Screens benutzt
  static AppBar kSecondaryAppbar({required String title}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(title, style: const TextStyle(color: kColorBlack)),
      centerTitle: true,
      elevation: 0, //setzt schatten auf 0
    );
  }

//TODO: Beschreiben welche text grösse wo genutzt wird
  //Schriftgrössen
  static const kTextSizeSmall = 12.0;
  static const kTextSizeMedium = 16.0;
  static const kTextSizeLarge = 20.0;
  static const kTextSizeExtraLarge = 24.0;
  static const kTextSizeExxtraLarge = 48.0;

  //InputDecoration
//TODO: sobald ich beim login bin diese einfügen um geordnete Validierung anzuzeigen
}
