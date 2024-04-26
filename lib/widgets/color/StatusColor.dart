import 'dart:ui';

import '../../constants/style_guide/StyleGuide.dart';

///[getStatusColor] ist eine Klasse die die Farbe des Status zurückgibt
class getStatusColor {
  Color tileColor(String? status) {
    switch (status) {
      case 'AKZEPTIERT':
        return StyleGuide.kColorPrimaryGreen;
      case 'ABGELEHNT':
        return StyleGuide.kColorRed;
      case 'KEINE_STELLVERTRETUNG':
        return StyleGuide.kColorOrange;
      case 'VORLAEUFIG_AKZEPTIERT':
        return StyleGuide.kColorSecondaryBlue;
      case 'VORLAEUFIG_ABGELEHNT':
        return StyleGuide.kColorPurple;
      default:
        return StyleGuide.kColorGrey;
    }
  }
}
