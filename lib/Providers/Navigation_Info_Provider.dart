import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NavInfo extends ChangeNotifier {
  String? eta;
  double? travelTime;
  double? travelKm;

  void updateRouteDetails(String jsonData) {
    var data = jsonDecode(jsonData);

    if (data['status'] != 'OK' ||
        data['routes'] == null ||
        data['routes'].isEmpty) {
      throw Exception("Invalid data or no routes available");
    }

    var route = data['routes'][0];
    var legs = route['legs'];
    if (legs == null || legs.isEmpty) {
      print("No route information available.");
      return;
    }

    double totalDistance = 0;
    int totalDurationInSeconds = 0;

    for (var leg in legs) {
      if (leg['distance'] != null && leg['distance']['value'] != null) {
        totalDistance += leg['distance']?['value'] ?? 0;
      }
      if (leg['duration'] != null && leg['duration']['value'] != null) {
        totalDurationInSeconds += leg['duration']?['value'] as int;
      }
    }

    // Calculate total distance in kilometers
    travelKm = totalDistance / 1000;

    // Calculate total duration in minutes
    travelTime = totalDurationInSeconds / 60;

    // Calculate ETA based on current time and total duration
    DateTime now = DateTime.now();
    DateTime arrivalTime = now.add(Duration(seconds: totalDurationInSeconds));
    eta = DateFormat('h:mm a').format(arrivalTime);

    // Notify all listeners about the changes
    notifyListeners();

    print('Updated travel Km: $travelKm');
    print('Updated travel Time: $travelTime');
    print('Updated ETA: $eta');
  }

  void closeNav() {
    travelTime = null;
    notifyListeners();
  }
}
