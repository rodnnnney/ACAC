import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppTheme {
  static const cacheDuration = Duration(hours: 1);

  static const Color kDarkGreen = Color(0xff14342B);
  static const Color kGreen = Color(0xff60935D);
  static const Color kGreen2 = Color(0xff8CC084);
  static const Color kGreen3 = Color(0xffA9E1A9);

  static const Color kWhite = Color(0xffFDFFFC);

  static const double roundedRadius = 12;
  static const double spacing = 10;

  static const double headerTwo = 18;

  static const LatLng backUpLocation =
      LatLng(45.3873261757469, -75.69588214536877);

  static const TextStyle styling = TextStyle(
      fontFamily: 'helveticanowtext',
      color: Color(0xff8CC084),
      fontWeight: FontWeight.bold);
}
