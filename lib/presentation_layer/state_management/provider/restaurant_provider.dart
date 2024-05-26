import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/domain_layer/repository_interface/start_stop.dart';

import '../../../domain_layer/repository_interface/cards.dart';
import '../../../domain_layer/repository_interface/times.dart';

class Restaurant extends ChangeNotifier {
  LatLng? distance;

//TODO make more cards
  List<Cards> restaurantInfo = [
    Cards(
      restaurantName: 'Kinton Ramen',
      location: const LatLng(45.41913804744197, -75.6914954746089),
      address: '216 Elgin St #2',
      imageSrc: 'images/Kinton/kinton.jpeg',
      imageLogo: 'images/Kinton/kintonlogo.png',
      hours: Time(
        monday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        tuesday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
        thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        sunday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      ),
      rating: 4.7,
      cuisineType: 'Ramen',
    ),
    Cards(
      restaurantName: 'Friends&KTV ',
      location: const LatLng(45.36865077062187, -75.70277557461156),
      address: '1430 Prince of Wales',
      imageLogo: 'images/FriendsKTV/friends.jpeg',
      imageSrc: 'images/FriendsKTV/friends.jpeg',
      hours: Time(
        monday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        tuesday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
        thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        sunday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      ),
      rating: 3.6,
      cuisineType: 'Chinese',
    ),
    Cards(
      restaurantName: 'Papaspicy',
      location: const LatLng(45.4278039812124, -75.69032978995092),
      address: '366 Dalhousie St',
      imageSrc: 'images/PapaSpicy/papaSpicy.avif',
      imageLogo: 'images/PapaSpicy/papaSpicy.avif',
      hours: Time(
        monday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        tuesday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
        thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        sunday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      ),
      rating: 4.2,
      cuisineType: 'Chinese',
    ),
    Cards(
      restaurantName: 'Chatime',
      location: const LatLng(45.411220513918316, -75.70696356085315),
      address: '695 Somerset St',
      imageSrc: 'images/Chatime/boba.jpeg',
      imageLogo: 'images/Chatime/logo.png',
      hours: Time(
        monday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        tuesday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
        thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
        sunday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      ),
      rating: 4.4,
      cuisineType: 'Bubble Tea',
    ),
  ];

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
