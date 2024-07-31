import 'dart:convert';

import 'package:ACAC/common/services/getDistance.dart';
import 'package:ACAC/common/widgets/helper_functions/time_formatter.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'additional_data_dbb.dart';

class HomePageUserCard extends StatelessWidget {
  HomePageUserCard({
    super.key,
    required this.restaurantInfoCard,
    required this.user,
    required this.index,
    required this.ref,
  });

  final RestaurantInfoCard restaurantInfoCard;
  final int weekday = DateTime.now().weekday;
  final GetDistance getDistance = GetDistance();
  final LatLng user;
  final int index;
  final WidgetRef ref;

  Future<String> getDistanceForRestaurant(RestaurantInfoCard restaurant) async {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String distance = await getDistance.getDistanceForRestaurant(
            restaurantInfoCard, user);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalDataDbb(
              restaurant: restaurantInfoCard,
              distance: distance,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: restaurantInfoCard.imageSrc,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FutureBuilder<String>(
                            future:
                                getDistanceForRestaurant(restaurantInfoCard),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ??
                                    'Getting Distance'
                                        '..',
                                style: const TextStyle(color: Colors.black),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          width: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8E8E8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                restaurantInfoCard.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurantInfoCard.restaurantName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  restaurantInfoCard.address,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            Text(
                              getHour(restaurantInfoCard, weekday),
                              style: TextStyle(
                                fontSize: 11,
                                color: timeColor(
                                  DateTime.now(),
                                  getOpeningTimeSingle(
                                      weekday, restaurantInfoCard),
                                  getClosingTimeSingle(
                                      weekday, restaurantInfoCard),
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    color: Color(0xff68ba7b),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Text(
                  ' ${index + 1}# Most Popular!',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
