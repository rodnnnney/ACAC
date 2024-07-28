import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantInfo extends ChangeNotifier {
  LatLng? distance;

  //Polyline generating
  void fetchData() async {
    try {
      LatLng user = await getLocation();
      distance = LatLng(user.latitude, user.longitude);
      notifyListeners();
    } catch (e) {
      debugPrint('ERROR: $e');
    }
  }

  Future<LatLng> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      return LatLng(position.latitude,
          position.longitude); // Returns a non-null LatLng object
    } catch (e) {
      // If there's any error fetching the location, throw an exception
      throw Exception("Failed to get current location: ${e.toString()}");
    }
  }
}
