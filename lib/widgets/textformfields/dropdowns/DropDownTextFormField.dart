import 'package:flutter/material.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

/// Ein [StatefulWidget] Widget, das ein [TextFormField] mit einem [Dropdown] erstellt
class RankTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isMandatory;
  final Widget suffixIcon;
  final FocusNode? focusNode;

  /// Erstellt ein [RankTextFormField] mit den gegebenen Parametern
  const RankTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isMandatory = true,
    required this.suffixIcon,
    this.focusNode,
  });

  /// Erstellt ein [State] Objekt, das [RankTextFormField] verwaltet
  @override
  _RankTextFormFieldState createState() => _RankTextFormFieldState();
}

/// Ein [State] Objekt, das [RankTextFormField] verwaltet.
class _RankTextFormFieldState extends State<RankTextFormField> {
  String? _selectedRank;

  /// Erstellt ein [Widget] mit einem [TextFormField] und einem [Dropdown] Widget
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusNode: widget.focusNode,
      dropdownColor: StyleGuide.kColorWhite,
      value: _selectedRank,
      //Namesngebung gleich wie im Backend, deshalb noch Leader in english statt deutsch, wird erst nach der IPA bearbeitet
      items: ['ADMINISTRATOR', 'DEV', 'SUPPORT', 'LEADER']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: const TextStyle(
                  color: StyleGuide.kColorSecondaryBlue,
                  fontSize: StyleGuide.kTextSizeMedium)),
        );
      }).toList(),
      //Setzt den ausgewählten Wert in das TextFormField
      onChanged: (String? newValue) {
        setState(() {
          _selectedRank = newValue;
          widget.controller.text = newValue ?? "";
        });
      },
      decoration: StyleGuide.kInputDecoration(
              label: widget.label,
              hint: widget.hint,
              isMandatory: widget.isMandatory)
          .copyWith(suffixIcon: widget.suffixIcon),
      validator: (value) {
        if (widget.isMandatory == true && (value == null || value.isEmpty)) {
          return '${widget.label} ist ein Pflichtfeld';
        }
        return null;
      },
    );
  }
}
