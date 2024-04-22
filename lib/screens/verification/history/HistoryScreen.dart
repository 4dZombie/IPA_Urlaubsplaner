import 'package:flutter/material.dart';
import 'package:ipa_urlaubsplaner/constants/style_guide/StyleGuide.dart';

import '../../../widgets/drawer/Drawer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleGuide.kPrimaryAppbar(title: "Historie"),
      drawer: DrawerWidget(),
    );
  }
}
