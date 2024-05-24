import 'package:flutter/foundation.dart';

class RiverpodTest extends ChangeNotifier {
  RiverpodTest({required this.counter});

  int counter;

  void setCounter(int newCounter) {
    counter = newCounter;
    notifyListeners();
  }
}
