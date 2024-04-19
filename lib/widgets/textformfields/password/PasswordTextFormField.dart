import 'package:flutter/material.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

/// Ein [StatelessWidget] Widget, das ein [TextFormField] für Passwörter erstellt
class PasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool? isMandatory;
  final Widget suffixIcon;
  final FocusNode? focusNode;

  /// Konstruktor für das Textfeld
  const PasswordTextFormField({
    super.key, //Constructors for public widgets should have a named 'key' parameter. durch IDE eingefügt nutzen noch nicht klar
    required this.controller,
    required this.label,
    required this.hint,
    this.isMandatory = true,
    required this.suffixIcon,
    this.focusNode,
  });

  /// UI für das Textfeld
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textInputAction: TextInputAction.next, // Nächste Taste auf dem Handy
      style: const TextStyle(
        fontSize: StyleGuide.kTextSizeMedium,
        color: StyleGuide.kColorSecondaryBlue,
      ),
      cursorColor: StyleGuide.kColorGrey,
      controller: controller,
      decoration: StyleGuide.kInputDecoration(
              label: label, hint: hint, isMandatory: isMandatory)
          .copyWith(
        suffixIcon: suffixIcon,
      ),
      obscureText: true, // Passwort wird versteckt
      validator: (value) {
        // Überprüfung des Passworts auf Länge und ob es leer ist
        if (isMandatory == true && (value == null || value.isEmpty)) {
          return "$label ist ein Pflichtfeld";
        }
        if (label.toLowerCase().contains("passwort") &&
            value != null &&
            value.length < 8) {
          return "Das Passwort muss mindestens 8 Zeichen lang sein";
        }
        return null;
      },
    );
  }
}
