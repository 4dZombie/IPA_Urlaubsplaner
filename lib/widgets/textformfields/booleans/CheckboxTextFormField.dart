import 'package:flutter/material.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

/// Ein [StatefulWidget] Widget, das ein [TextFormField] mit einem [Checkbox] erstellt
class BooleanTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool initialValue;
  final String label;
  final FocusNode? focusNode;

  /// Erstellt ein [BooleanTextFormField] mit den gegebenen Parametern
  const BooleanTextFormField({
    super.key,
    required this.controller,
    required this.initialValue,
    required this.label,
    this.focusNode,
  });

  /// Erstellt ein [State] Objekt, das [BooleanTextFormField] verwaltet
  @override
  _BooleanTextFormFieldState createState() => _BooleanTextFormFieldState();
}

/// Ein [State] Objekt, das [BooleanTextFormField] verwaltet
class _BooleanTextFormFieldState extends State<BooleanTextFormField> {
  bool _value = false;

  /// Setzt den initialen Wert des [Checkbox] auf den Wert von [initialValue]
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  /// Erstellt ein [Widget] mit einem [Checkbox] und einem [Text] Widget
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          focusNode: widget.focusNode,
          activeColor: StyleGuide.kColorPrimaryGreen,
          value: _value,
          onChanged: (bool? value) {
            setState(() {
              _value = value ?? false;
              widget.controller.text = _value.toString();
            });
          },
        ),
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: StyleGuide.kTextSizeMedium,
            color: StyleGuide.kColorSecondaryBlue,
          ),
        ),
      ],
    );
  }
}
