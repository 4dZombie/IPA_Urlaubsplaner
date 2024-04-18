import 'package:flutter/material.dart';

import '../../../constants/style_guide/StyleGuide.dart';

class RegisterLoginButton extends StatelessWidget {
  final VoidCallback function; //Gibt an, dass die Funktion keine Rückgabe hat
  final String? text;
  final FocusNode? focusNode;

  const RegisterLoginButton(
      {required this.function, this.text, Key? key, this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double
          .infinity, // Breite des Buttons auf die gesamte Breite des Bildschirms vorest
      child: TextButton(
        focusNode: focusNode,
        onPressed: function,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(
              StyleGuide.kColorPrimaryGreen), // Hintergrundfarbe des Buttons
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            // Form des Buttons
            RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Abrundung des Buttons
                side: const BorderSide(
                    color:
                        StyleGuide.kColorGrey)), // Farbe des Randes des Buttons
          ),
        ),
        child: Text(
          text ?? 'Registrieren',
          style: const TextStyle(
              fontSize: StyleGuide.kTextSizeMedium,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
