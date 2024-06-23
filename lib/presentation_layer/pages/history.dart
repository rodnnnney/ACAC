import 'dart:convert';

import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/domain_layer/controller/restaurant_list_controller.dart';
import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:ACAC/presentation_layer/widgets/additionalV2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as legacy;

// Define the page route ID
class History extends ConsumerStatefulWidget {
  static String id = '/history';

  History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

late String distance;

// Function to format date string
String formatDateString(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
  return formattedDate;
}

// Function to retrieve restaurant card information
restaurantCard getInfo(List<restaurantCard> infoList, String checkName) {
  for (var info in infoList) {
    if (info.awsMatch == checkName) {
      return info;
    }
  }
  throw Error();
}

UserLocation location = UserLocation();

// Function to fetch user's current location
Future<LatLng> getLocation() async {
  return await location.find();
}

// Stateful widget for the history page
class _HistoryState extends ConsumerState<History> {
  @override
  Widget build(BuildContext context) {
    final maps = legacy.Provider.of<PolyInfo>(context); // Legacy provider usage
    var pastRestaurants = ref
        .watch(restaurantListControllerProvider); // Riverpod state management
    final restaurantProvider =
        ref.watch(restaurant); // Riverpod state management

    // Function to fetch distance between user and restaurant
    Future<String> getDistance(LatLng user, LatLng restaurant) async {
      String url = await maps.createHttpUrl(user.latitude, user.longitude,
          restaurant.latitude, restaurant.longitude);
      var decodedJson = jsonDecode(url);
      String distanceNew = decodedJson['routes'][0]['legs'][0]['distance']['tex'
          't'];
      return distanceNew;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 600,
                child: pastRestaurants.when(
                  data: (restaurants) {
                    if (restaurants.isEmpty) {
                      return const Center(child: Text('It\'s empty'));
                    } else {
                      // Sorting restaurants by createdAt in descending order
                      restaurants.sort(
                        (a, b) {
                          if (a.createdAt == null && b.createdAt == null) {
                            return 0;
                          } else if (a.createdAt == null) {
                            return 1;
                          } else if (b.createdAt == null) {
                            return -1;
                          } else {
                            return b.createdAt!
                                .compareTo(a.createdAt!); // Descending order
                          }
                        },
                      );

                      return FutureBuilder<LatLng>(
                        future: getLocation(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: Text('Location not found'));
                          } else {
                            return ListView.builder(
                              itemCount: restaurants.length,
                              itemBuilder: (context, index) {
                                var card = getInfo(restaurantProvider,
                                    restaurants[index].restaurant);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Card(
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 32,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            card.imageLogo),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        card.restaurantName,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        formatDateString(
                                                            restaurants[index]
                                                                .createdAt
                                                                .toString()),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  HapticFeedback.heavyImpact();
                                                  distance = await getDistance(
                                                      snapshot.data!,
                                                      card.location);
                                                  if (context.mounted) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdditionalV2(
                                                          restaurant: card,
                                                          distance: distance,
                                                          user: snapshot.data!,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'View Store',
                                                  style: TextStyle(
                                                      color: ref
                                                              .watch(darkLight)
                                                              .theme
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                  error: (error, stack) {
                    return Center(
                      child: Text('Error: $error'),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBarBottom(id: History.id),
    );
  }
}
