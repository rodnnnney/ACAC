import 'package:flutter/material.dart';

class ColorTheme {
  static const Color kBackGroundColorITMZ = Color(0xffEFEFEF);
  static const Color kTextColorITMZ = Color(0xff2E2E2E);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );
  }
}

// The color scheme reflects the platform's light or dark setting
// which is retrieved with `MediaQuery.platformBrightnessOf`. The color
// scheme's colors will be different for light and dark settings although
