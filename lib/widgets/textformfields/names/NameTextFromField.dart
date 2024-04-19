import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

/// Ein [StatelessWidget] Widget, das ein [TextFormField] für Namen erstellt
///
class NameTextFormField extends StatelessWidget {
  // Attribute für das Textfeld und deklaration der Variablen typen
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool? isMandatory;
  final Widget suffixIcon;
  final FocusNode? focusNode;

  /// Konstruktor für das Textfeld
  const NameTextFormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.isMandatory = true,
    required this.suffixIcon,
    this.focusNode,
    super.key,
  });

  /// UI für das Textfeld
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: TextInputAction.next, // Nächste Taste auf dem Handy
        textCapitalization: TextCapitalization.words, // Erster Buchstabe gross
        focusNode: focusNode, // Fokusnode für die Steuerung mit dem Keyboard
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.deny(RegExp(
              r'[!@#<>?":_;[\]\\|=+)(*&^%§°]')), // Sonderzeichen die nicht erlaubt sind & auf der Tastatur gefunden habe
        ],
        style: const TextStyle(
          fontSize: StyleGuide.kTextSizeMedium,
          color: StyleGuide.kColorSecondaryBlue,
        ),
        cursorColor: StyleGuide.kColorBlack,
        controller: controller,
        decoration: StyleGuide.kInputDecoration(
                label: label, hint: hint, isMandatory: isMandatory)
            .copyWith(
          suffixIcon: suffixIcon,
        ),
        // Validierung des Textfeldes ob es leer ist und ob es ein Pflichtfeld ist
        validator: (value) {
          if (isMandatory == true && (value == null || value.isEmpty)) {
            // Wenn es ein Pflichtfeld ist und leer ist, wird eine Fehlermeldung ausgegeben
            return '$label ist ein Pflichtfeld';
          }
          return null;
        });
  }
}
