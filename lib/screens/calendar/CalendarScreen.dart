// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleGuide.kPrimaryAppbar(title: "Kalender"),
    );
  }
}
