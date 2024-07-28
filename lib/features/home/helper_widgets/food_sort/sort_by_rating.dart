import 'dart:async';
import 'dart:convert';

import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/services/cachedRestaurantProvider.dart';
import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/common/widgets/helper_functions/time_formatter.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/features/maps/maps.dart';
import 'package:ACAC/features/maps/service/navigation_info_provider.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../card/additional_data_dbb.dart';

class SortedByRating extends ConsumerStatefulWidget {
  static const String id = 'sorted_by_rating_list';

  const SortedByRating({super.key, required this.type});

  final String type;

  @override
  ConsumerState<SortedByRating> createState() => CardViewerHomePageState();
}

class CardViewerHomePageState extends ConsumerState<SortedByRating> {
  LatLng userPosition = const LatLng(0, 0);
  UserLocation location = UserLocation();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    LatLng newPosition = await location.find();
    setState(() {
      userPosition = newPosition;
    });
  }

  List<RestaurantInfoCard> sortedRestaurants = [];

  @override
  Widget build(BuildContext context) {
    final restaurantData = ref.watch(cachedRestaurantInfoCardListProvider);
    return Scaffold(
      body: SafeArea(
        child: restaurantData.when(
          data: (allInfoCards) {
            switch (widget.type) {
              case "RATING":
                sortedRestaurants = List<RestaurantInfoCard>.from(allInfoCards)
                  ..sort((a, b) => b.rating.compareTo(a.rating));
              case "VISIT":
                sortedRestaurants = List<RestaurantInfoCard>.from(allInfoCards)
                  ..sort((a, b) => b.timesVisited.compareTo(a.timesVisited));
              case "ALPHA":
                sortedRestaurants = List<RestaurantInfoCard>.from(allInfoCards)
                  ..sort(
                      (a, b) => a.restaurantName.compareTo(b.restaurantName));
                return buildList(sortedRestaurants, DateTime.now().weekday);
            }

            // final sortedRestaurants =
            //     List<RestaurantInfoCard>.from(allInfoCards)
            //       ..sort((a, b) => b.rating.compareTo(a.rating));
            return buildList(sortedRestaurants, DateTime.now().weekday);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.id);
                  },
                  child: const Text('Go back'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(
    List<RestaurantInfoCard> sortedRestaurants,
    int weekday,
  ) {
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
    final watchCounter = ref.watch(userPageCounter);

    void updatePage(int index, String route) {
      Navigator.pushNamed(context, route);
      ref.read(userPageCounter).setCounter(index);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        //  title: Text(widget.cuisineType),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: sortedRestaurants.length == 1
                  ? Text('${sortedRestaurants.length.toString()} restaurant '
                      'found')
                  : Text(
                      '${sortedRestaurants.length.toString()} restaurants found')),
        ],
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: sortedRestaurants.length,
        itemBuilder: (BuildContext context, int index) {
          Future<String> getDistance() async {
            String url = await maps.createHttpUrl(
                userPosition.latitude,
                userPosition.longitude,
                double.parse(sortedRestaurants[index].location.latitude),
                double.parse(sortedRestaurants[index].location.longitude));
            var decodedJson = jsonDecode(url);
            String distance =
                decodedJson['routes'][0]['legs'][0]['distance']['text'];
            return distance;
          }

          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            margin: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () async {
                String distance = await getDistance();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdditionalDataDbb(
                      restaurant: sortedRestaurants[index],
                      distance: distance,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                //color: Colors.white,
                elevation: 1,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 130,
                        fit: BoxFit.cover,
                        imageUrl: sortedRestaurants[index].imageSrc,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sortedRestaurants[index].restaurantName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              FutureBuilder(
                                future: getDistance(),
                                builder: (context, snapshot) {
                                  return Text(
                                      snapshot.data ?? 'Getting Distance..');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(sortedRestaurants[index].address),
                          Row(
                            children: [
                              Text(
                                getHours(sortedRestaurants, index, weekday),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              FutureBuilder<Map<String, dynamic>>(
                                future: getCurrentStatusWithColor(
                                  getOpeningTime(
                                      weekday, sortedRestaurants, index),
                                  getClosingTime(
                                      weekday, sortedRestaurants, index),
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    var status = snapshot.data?['status'] ??
                                        'Unknown status';
                                    var color =
                                        snapshot.data?['color'] ?? Colors.black;
                                    return Text(
                                      status,
                                      style: TextStyle(color: color),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    );
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.green),
                              foregroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async {
                              HapticFeedback.heavyImpact();
                              try {
                                if (context.mounted) {
                                  Navigator.pushNamed(context, MapScreen.id);
                                }
                                if (watchCounter.counter == 2) {
                                } else {
                                  updatePage(2, MapScreen.id);
                                }
                                LatLng user = await data.getLocation();
                                String url = await maps.createHttpUrl(
                                    user.latitude,
                                    user.longitude,
                                    double.parse(sortedRestaurants[index]
                                        .location
                                        .latitude),
                                    double.parse(sortedRestaurants[index]
                                        .location
                                        .longitude));

                                maps.processPolylineData(url);
                                maps.updateCameraBounds([
                                  user,
                                  sortedRestaurants[index].location as LatLng
                                ]);
                                nav.updateRouteDetails(url);
                              } catch (e) {}
                            },
                            child: const Text('Find on Map'),
                          ),
                          const SizedBox(
                            width: 22,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8E8E8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                sortedRestaurants[index].rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
