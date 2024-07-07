import 'dart:async';
import 'dart:convert';

import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/domain_layer/repository_interface/time_formatter.dart';
import 'package:ACAC/presentation_layer/pages/home.dart';
import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:ACAC/presentation_layer/widgets/restaurant_additional_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../pages/maps.dart';

class SortedByRating extends ConsumerStatefulWidget {
  static const String id = 'sorted_by_rating_list';

  const SortedByRating({super.key});

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

  @override
  Widget build(BuildContext context) {
    List<restaurantCard> sortedRestaurants =
        List.from(ref.read(sortedRestaurantsProvider));

    return Scaffold(
      body: SafeArea(
        child: sortedRestaurants.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No restaurants of the cuisine available!'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomePage.id);
                      },
                      child: const Text('Go back'))
                ],
              ))
            : buildList(sortedRestaurants.cast<restaurantCard>()),
      ),
    );
  }

  Widget buildList(List<restaurantCard> sortedRestaurants) {
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
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
                  ? Text('${sortedRestaurants.length.toString()} item found')
                  : Text('${sortedRestaurants.length.toString()} items found')),
        ],
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: sortedRestaurants.length,
        itemBuilder: (BuildContext context, int index) {
          String getHours() {
            DateTime now = DateTime.now();
            int weekday = now.weekday;
            if (weekday == 1) {
              return ('${sortedRestaurants[index].hours.monday.startTime} - ${sortedRestaurants[index].hours.monday.endTime}');
            } else if (weekday == 2) {
              return ('${sortedRestaurants[index].hours.tuesday.startTime} - ${sortedRestaurants[index].hours.tuesday.endTime}');
            } else if (weekday == 3) {
              return ('${sortedRestaurants[index].hours.wednesday.startTime} - ${sortedRestaurants[index].hours.wednesday.endTime}');
            } else if (weekday == 4) {
              return ('${sortedRestaurants[index].hours.thursday.startTime} - ${sortedRestaurants[index].hours.thursday.endTime}');
            } else if (weekday == 5) {
              return ('${sortedRestaurants[index].hours.friday.startTime} - ${sortedRestaurants[index].hours.friday.endTime}');
            } else if (weekday == 6) {
              return ('${sortedRestaurants[index].hours.saturday.startTime} - ${sortedRestaurants[index].hours.saturday.endTime}');
            } else if (weekday == 7) {
              return ('${sortedRestaurants[index].hours.sunday.startTime} - ${sortedRestaurants[index].hours.sunday.endTime}');
            } else {
              return 'Closed';
            }
          }

          Future<String> getDistance() async {
            String url = await maps.createHttpUrl(
                userPosition.latitude,
                userPosition.longitude,
                sortedRestaurants[index].location.latitude,
                sortedRestaurants[index].location.longitude);
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
                    builder: (context) => RestaurantAdditionalInfo(
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
                                getHours(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              FutureBuilder<Map<String, dynamic>>(
                                future: getCurrentStatusWithColor(
                                    sortedRestaurants[index]
                                        .hours
                                        .getTodayStartStop()
                                        .startTime,
                                    sortedRestaurants[index]
                                        .hours
                                        .getTodayStartStop()
                                        .endTime),
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
                                LatLng user = await data.getLocation();
                                String url = await maps.createHttpUrl(
                                    user.latitude,
                                    user.longitude,
                                    sortedRestaurants[index].location.latitude,
                                    sortedRestaurants[index]
                                        .location
                                        .longitude);

                                maps.processPolylineData(url);
                                maps.updateCameraBounds(
                                    [user, sortedRestaurants[index].location]);
                                nav.updateRouteDetails(url);
                                Navigator.pushNamed(context, MapScreen.id);
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
