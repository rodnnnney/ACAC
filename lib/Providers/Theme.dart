import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool lightDark = false;

  void setTheme() {
    lightDark = !lightDark;
    notifyListeners();
  }
}
