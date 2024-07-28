import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorTheme {
  ColorTheme(this.context);

  late BuildContext context;

  ThemeData themeDataLight() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ));
  }

  ThemeData themeDataDark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context)
          .textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white)),
    );
  }
}
