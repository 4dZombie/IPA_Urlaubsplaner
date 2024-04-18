import 'package:flutter/material.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

class PasswordTextFormField extends StatelessWidget {
  final password = TextEditingController(); // Provisorisch
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool? isMandatory;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  PasswordTextFormField({
    super.key, //Constructors for public widgets should have a named 'key' parameter. durch IDE eingefügt nutzen noch nicht klar
    // const wiedereinfügen
    required this.controller,
    this.label = 'Passwort',
    this.hint,
    this.isMandatory = true,
    this.suffixIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
        fontSize: StyleGuide.kTextSizeMedium,
        color: StyleGuide.kColorSecondaryBlue,
      ),
      cursorColor: StyleGuide.kColorGrey,
      controller: controller,
      decoration: StyleGuide.InputDecoration(
              label: label!, hint: hint, isMandatory: isMandatory)
          .copyWith(
        suffixIcon: suffixIcon,
      ),
      obscureText: true, // Passwort wird versteckt
      validator: (value) {
        // Überprüfung des Passworts auf Länge und ob es leer ist
        if (value == null || value.isEmpty) {
          return 'Bitte bestätige dein Passwort';
        } else if (password.text != value) {
          return 'Passwort stimmt nicht überein';
        }
        return null;
      },
    );
  }
}
