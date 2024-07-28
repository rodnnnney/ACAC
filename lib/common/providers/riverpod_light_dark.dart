import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkLightToggle extends ChangeNotifier {
  DarkLightToggle({required this.counter});
  int counter;

  void setCounter(int newCounter) {
    counter = newCounter;
    notifyListeners();
  }
}

class DarkLight extends ChangeNotifier {
  DarkLight({required this.theme});

  bool theme;
  static const String _key = 'isDarkMode';

  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, isDarkMode);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    theme = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  void toggleThemeOff() {
    theme = false;
    _saveTheme(theme);
    notifyListeners();
  }

  void toggleThemeOn() {
    theme = true;
    _saveTheme(theme);
    notifyListeners();
  }
}

final userPageCounter = ChangeNotifierProvider<DarkLightToggle>(
  (ref) {
    return DarkLightToggle(counter: 0);
  },
);

final darkLight = ChangeNotifierProvider<DarkLight>(
  (ref) {
    final darkLight = DarkLight(theme: false);
    darkLight.loadTheme();
    return darkLight;
  },
);
