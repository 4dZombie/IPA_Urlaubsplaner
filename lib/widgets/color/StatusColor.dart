import 'dart:ui';

import '../../constants/style_guide/StyleGuide.dart';

class getStatusColor {
  Color tileColor(String? status) {
    switch (status) {
      case 'AKZEPTIERT':
        return StyleGuide.kColorPrimaryGreen;
      case 'ABGELEHNT':
        return StyleGuide.kColorRed;
      case 'KEINE_STELLVERTRETUNG':
        return StyleGuide.kColorOrange;
      default:
        return StyleGuide.kColorBlack;
    }
  }
}
