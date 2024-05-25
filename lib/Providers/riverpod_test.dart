import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

class RiverpodTest extends ChangeNotifier {
  RiverpodTest({required this.counter});
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

  void _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, isDarkMode);
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

final userPageCounter = ChangeNotifierProvider<RiverpodTest>(
  (ref) {
    return RiverpodTest(counter: 0);
  },
);

final darkLight = ChangeNotifierProvider<DarkLight>(
  (ref) {
    return DarkLight(theme: false);
  },
);
