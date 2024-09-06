import 'dart:convert';

import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/models/Restaurant.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

// Define the page route ID
class CostBreakdown extends ConsumerStatefulWidget {
  static String id = '/cost';

  const CostBreakdown({super.key, required this.restList});

  final List<Restaurant> restList;

  @override
  ConsumerState<CostBreakdown> createState() => _HistoryState();
}

late String distance;
UserLocation location = UserLocation();
List<RestaurantInfoCard> allInfoCards = [];
final formatCurrency = NumberFormat("#,##0.00", "en_US");

// Function to format date string (-4 cuz aws uses utc)
String formatDateString(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateTime adjustedDateTime = dateTime.subtract(const Duration(hours: 4));
  String formattedDate = DateFormat('MMMM d, yyyy').format(adjustedDateTime);
  return formattedDate;
}

// Function to retrieve restaurant card information
RestaurantInfoCard getInfo(
    List<RestaurantInfoCard> infoList, String checkName) {
  for (var info in infoList) {
    if (info.restaurantName == checkName) {
      return info;
    }
  }
  throw ErrorDescription('$checkName not found');
}

// Stateful widget for the history page
class _HistoryState extends ConsumerState<CostBreakdown> {
  @override
  Widget build(BuildContext context) {
    final maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    var pastRestaurants = ref.watch(restaurantListControllerProvider);
    var test = ref.watch(restaurantInfoCardListProvider);

    switch (test) {
      case AsyncData(value: final allInfoLoaded):
        for (var data in allInfoLoaded) {
          allInfoCards.add(data);
        }
    }

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
        title: Text('History'),
        centerTitle: true,
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
                      return const Scaffold(
                          body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No history so far!'),
                            Text('Scanned restaurants will show up here!')
                          ],
                        ),
                      ));
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

                      return ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          var card = getInfo(
                              allInfoCards, restaurants[index].restaurant);
                          final timesVisited = widget.restList
                              .where((element) => element == restaurants[index])
                              .length;
                          final revGenerated = timesVisited *
                              restaurants[index].averagePrice *
                              0.9;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  card.restaurantName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                "Times Visited: ${timesVisited.toString()}"),
                                            Text("\$${revGenerated.toString()}")
                                          ],
                                        ),
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
    );
  }
}
