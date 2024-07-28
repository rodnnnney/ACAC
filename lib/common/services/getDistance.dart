import 'dart:convert';

import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GetDistance {
  Future<String> createHttpUrl(double originLat, double originLng,
      double destinationLat, double destinationLng) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    String origin = '$originLat,$originLng';
    String destination = '$destinationLat,$destinationLng';
    String url =
        '$baseUrl?origin=$origin&destination=$destination&key=AIzaSyCw23kDf2jJs7sUILVm2vk6oIki8n8zymY';
    try {
      final parsedURL = Uri.parse(url);
      http.Response response = await http.get(parsedURL);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Http error: ${response.statusCode}');
      }
    } catch (e) {
      print('General error:$e');
    }
    return 'ERROR';
  }

  Future<String> getDistanceForRestaurant(
      RestaurantInfoCard restaurant, LatLng user) async {
    if (distanceCache.containsKey(restaurant.id)) {
      return distanceCache[restaurant.id]!;
    }
    // If not cached, make the API call
    String url = await getDistance.createHttpUrl(
      user.latitude,
      user.longitude,
      double.parse(restaurant.location.latitude),
      double.parse(restaurant.location.longitude),
    );
    var decodedJson = jsonDecode(url);
    String distance = decodedJson['routes'][0]['legs'][0]['distance']['text'];
    // Cache the result
    distanceCache[restaurant.id] = distance;
    return distance;
  }
}
