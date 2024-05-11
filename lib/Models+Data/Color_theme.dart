import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  static const Color kBackGroundColorITMZ = Color(0xffEFEFEF);
  static const Color kTextColorITMZ = Color(0xff2E2E2E);

  static ShadThemeData get lightTheme {
    return ShadThemeData(
      colorScheme: const ShadColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        border: Colors.black,
        background: Colors.white,
        // TODO BACKGROUND COLOR
        foreground: kTextColorITMZ,
        card: Colors.white,
        // TODO Inside card color
        cardForeground: kTextColorITMZ,
        // TODO Text inside cards
        popover: Colors.white,
        popoverForeground: kTextColorITMZ,
        primary: Colors.black,
        // Button Background colour and text
        primaryForeground: Colors.white,
        secondary: Colors.white,
        secondaryForeground: Colors.white,
        muted: Colors.grey,
        mutedForeground: Colors.grey,
        accent: Colors.grey,
        accentForeground: Colors.white,
        destructive: Colors.red,
        destructiveForeground: Colors.white,
        input: kTextColorITMZ,
        ring: Colors.white,
        selection: Colors.grey,
      ),
      brightness: Brightness.light,
    );
  }

  static ShadThemeData get darkTheme {
    return ShadThemeData(
        colorScheme: const ShadColorScheme(
            // Decide how you want to apply your own custom them, to the MaterialApp
            border: Colors.black,
            background: Colors.black,
            // TODO BACKGROUND COLOR
            foreground: kTextColorITMZ,
            card: Color(0xff343A40),
            // TODO Inside card color
            cardForeground: Colors.white,
            // TODO Text inside cards
            popover: Colors.white,
            popoverForeground: kTextColorITMZ,
            primary: Colors.black,
            // Button Background colour and text
            primaryForeground: Colors.white,
            secondary: Colors.white,
            secondaryForeground: Colors.white,
            muted: Colors.grey,
            mutedForeground: Colors.grey,
            accent: Colors.grey,
            accentForeground: Colors.white,
            destructive: Colors.red,
            destructiveForeground: Colors.white,
            input: kTextColorITMZ,
            ring: Colors.white,
            selection: Colors.grey),
        brightness: Brightness.dark);
  }
}

// The color scheme reflects the platform's light or dark setting
// which is retrieved with `MediaQuery.platformBrightnessOf`. The color
// scheme's colors will be different for light and dark settings although
