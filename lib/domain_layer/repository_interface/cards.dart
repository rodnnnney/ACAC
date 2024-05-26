import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'times.dart';

class restaurantCard {
  late String restaurantName;
  late LatLng location;
  late String address;
  late String imageSrc;
  late String imageLogo;
  late Time hours;
  late double rating;
  late String cuisineType;
  late int reviewNum;
  late List<String> discounts;
  late String phoneNumber;

  restaurantCard(
      {required this.restaurantName,
      required this.location,
      required this.address,
      required this.imageSrc,
      required this.imageLogo,
      required this.hours,
      required this.rating,
      required this.reviewNum,
      required this.cuisineType,
      required this.discounts,
      required this.phoneNumber});
}
