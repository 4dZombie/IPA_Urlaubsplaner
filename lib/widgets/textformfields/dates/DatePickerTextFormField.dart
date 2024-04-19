import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

/// Ein [StatefulWidget] Widget, das ein [TextFormField] mit einem [DatePicker] erstellt
class DateTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isMandatory;
  final Widget suffixIcon;
  final FocusNode? focusNode;

  /// Erstellt ein [DateTextFormField] mit den gegebenen Parametern
  const DateTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isMandatory = true,
    required this.suffixIcon,
    this.focusNode,
  });

  /// Erstellt ein [State] Objekt, das [DateTextFormField] verwaltet
  @override
  _DateTextFormFieldState createState() => _DateTextFormFieldState();
}

/// Ein [State] Objekt, das [DateTextFormField] verwaltet
class _DateTextFormFieldState extends State<DateTextFormField> {
  DateTime? _selectedDate;

  /// Erstellt ein [Widget] mit einem [TextFormField] und einem [DatePicker] Widget
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.next,
      readOnly: true,
      cursorColor: StyleGuide.kColorBlack,
      controller: widget.controller,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDate(context);
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

//TODO: Textfarbe vom datepicker ist zu dunkel noch anpassen
  /// Öffnet den [DatePicker] und setzt das ausgewählte Datum in das [TextFormField]
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: StyleGuide.kColorPrimaryGreen,
                onPrimary: StyleGuide.kColorWhite,
                surface: StyleGuide.kColorSecondaryBlue,
                onSurface: StyleGuide.kColorWhite,
              ),
              dialogBackgroundColor: StyleGuide.kColorWhite,
            ),
            child: child!,
          );
        });

    /// Formatiert das Datum in das Format "yyyy/MM/dd" da backend in diesem Format ist
    String formatDate(DateTime date) {
      return DateFormat('MM/dd/yyyy').format(date);
    }

    /// Setzt das ausgewählte Datum in das [TextFormField]
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = formatDate(_selectedDate!);
      });
    }
  }
}
