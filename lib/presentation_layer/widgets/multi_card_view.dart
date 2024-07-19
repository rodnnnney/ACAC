import 'dart:async';
import 'dart:convert';

import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/domain_layer/repository_interface/phone_call.dart';
import 'package:ACAC/domain_layer/repository_interface/time_formatter.dart';
import 'package:ACAC/presentation_layer/pages/home.dart';
import 'package:ACAC/presentation_layer/pages/maps.dart';
import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:ACAC/presentation_layer/widgets/home_page_widgets/restaurant_additional_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class CardViewerHomePage extends ConsumerStatefulWidget {
  static const String id = 'card_viewer';

  late final String cuisineType;

  CardViewerHomePage({super.key, required this.cuisineType});

  @override
  ConsumerState<CardViewerHomePage> createState() => CardViewerHomePageState();
}

class CardViewerHomePageState extends ConsumerState<CardViewerHomePage> {
  LatLng userPosition = const LatLng(0, 0);
  UserLocation location = UserLocation();
  LaunchLink phoneCall = LaunchLink();

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
    final restaurantProvider = ref.read(restaurant);
    List<restaurantCard> filteredRestaurants = restaurantProvider
        .where((card) => card.cuisineType.contains(widget.cuisineType))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: filteredRestaurants.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomePage.id);
                      },
                      child: const Text('Go back'))
                ],
              ))
            : buildList(filteredRestaurants),
      ),
    );
  }

  Widget buildList(List<restaurantCard> filteredRestaurants) {
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.cuisineType),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: filteredRestaurants.length == 1
                  ? Text('${filteredRestaurants.length.toString()} item found')
                  : Text(
                      '${filteredRestaurants.length.toString()} items found')),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredRestaurants.length,
        itemBuilder: (BuildContext context, int index) {
          String getHours() {
            DateTime now = DateTime.now();
            int weekday = now.weekday;
            if (weekday == 1) {
              return ('${filteredRestaurants[index].hours.monday.startTime} - ${filteredRestaurants[index].hours.monday.endTime}');
            } else if (weekday == 2) {
              return ('${filteredRestaurants[index].hours.tuesday.startTime} - ${filteredRestaurants[index].hours.tuesday.endTime}');
            } else if (weekday == 3) {
              return ('${filteredRestaurants[index].hours.wednesday.startTime} - ${filteredRestaurants[index].hours.wednesday.endTime}');
            } else if (weekday == 4) {
              return ('${filteredRestaurants[index].hours.thursday.startTime} - ${filteredRestaurants[index].hours.thursday.endTime}');
            } else if (weekday == 5) {
              return ('${filteredRestaurants[index].hours.friday.startTime} - ${filteredRestaurants[index].hours.friday.endTime}');
            } else if (weekday == 6) {
              return ('${filteredRestaurants[index].hours.saturday.startTime} - ${filteredRestaurants[index].hours.saturday.endTime}');
            } else if (weekday == 7) {
              return ('${filteredRestaurants[index].hours.sunday.startTime} - ${filteredRestaurants[index].hours.sunday.endTime}');
            } else {
              return 'Closed';
            }
          }

          Future<String> getDistance() async {
            String url = await maps.createHttpUrl(
                userPosition.latitude,
                userPosition.longitude,
                filteredRestaurants[index].location.latitude,
                filteredRestaurants[index].location.longitude);
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
                      restaurant: filteredRestaurants[index],
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
                        imageUrl: filteredRestaurants[index].imageSrc,
                        width: double.infinity,
                        height: 130,
                        fit: BoxFit.cover,
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
                                filteredRestaurants[index].restaurantName,
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
                          Text(filteredRestaurants[index].address),
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
                                    filteredRestaurants[index]
                                        .hours
                                        .getTodayStartStop()
                                        .startTime,
                                    filteredRestaurants[index]
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
                      padding: const EdgeInsets.only(
                          bottom: 13, right: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextButton(
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
                                      filteredRestaurants[index]
                                          .location
                                          .latitude,
                                      filteredRestaurants[index]
                                          .location
                                          .longitude);

                                  maps.processPolylineData(url);
                                  maps.updateCameraBounds([
                                    user,
                                    filteredRestaurants[index].location
                                  ]);
                                  nav.updateRouteDetails(url);
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, MapScreen.id);
                                  }
                                } catch (e) {}
                              },
                              child: const Text('Find on Map'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 12)),
                                backgroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.black),
                                foregroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.white),
                              ),
                              onPressed: () async {
                                phoneCall.makePhoneCall(
                                    filteredRestaurants[index].phoneNumber);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Reserve'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.phone)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE8E8E8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    filteredRestaurants[index]
                                        .rating
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
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
