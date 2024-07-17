import 'dart:convert';

import 'package:ACAC/domain_layer/controller/restaurant_info_card_list.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/domain_layer/repository_interface/phone_call.dart';
import 'package:ACAC/domain_layer/repository_interface/time_formatter.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../state_management/provider/navigation_info_provider.dart';
import '../state_management/provider/restaurant_provider.dart';

class DbbTest extends ConsumerStatefulWidget {
  const DbbTest({super.key});

  @override
  ConsumerState<DbbTest> createState() => _DbbTestState();
}

class _DbbTestState extends ConsumerState<DbbTest> {
  List<RestaurantInfoCard> allInfoCards = [];
  late LatLng userPosition;
  UserLocation location = UserLocation();

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    LatLng newPosition = await location.find();
    setState(() {
      userPosition = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
    var test = ref.watch(restaurantInfoCardListProvider);
    LaunchLink phoneCall = LaunchLink();
    DateTime now = DateTime.now();
    int weekday = now.weekday;

    switch (test) {
      case AsyncData(value: final allInfoLoaded):
        for (var data in allInfoLoaded) {
          allInfoCards.add(data);
        }
    }

    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: allInfoCards.length,
          itemBuilder: (BuildContext context, int index) {
            Future<String> getDistance() async {
              String url = await maps.createHttpUrl(
                  userPosition.latitude,
                  userPosition.longitude,
                  double.parse(allInfoCards[index].location.latitude),
                  double.parse(allInfoCards[index].location.longitude));
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
                  // String distance = await getDistance();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => RestaurantAdditionalInfo(
                  //       restaurant: filteredRestaurants[index],
                  //       distance: distance,
                  //     ),
                  //   ),
                  // );
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
                          imageUrl: allInfoCards[index].imageSrc!,
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
                                  allInfoCards[index].restaurantName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                            Text(allInfoCards[index].address),
                            Row(
                              children: [
                                Text(
                                  getHours(allInfoCards, index, weekday),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                FutureBuilder<Map<String, dynamic>>(
                                  future: getCurrentStatusWithColor(
                                      getOpeningTime(
                                          weekday, allInfoCards, index),
                                      getClosingTime(
                                          weekday, allInfoCards, index)),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      var status = snapshot.data?['status'] ??
                                          'Unknown status';
                                      var color = snapshot.data?['color'] ??
                                          Colors.black;
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
                                      WidgetStatePropertyAll<Color>(
                                          Colors.green),
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          Colors.white),
                                ),
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  // try {
                                  //   LatLng user = await data.getLocation();
                                  //   String url = await maps.createHttpUrl(
                                  //       user.latitude,
                                  //       user.longitude,
                                  //       filteredRestaurants[index]
                                  //           .location
                                  //           .latitude,
                                  //       filteredRestaurants[index]
                                  //           .location
                                  //           .longitude);
                                  //
                                  //   maps.processPolylineData(url);
                                  //   maps.updateCameraBounds([
                                  //     user,
                                  //     filteredRestaurants[index].location
                                  //   ]);
                                  //   nav.updateRouteDetails(url);
                                  //   if (context.mounted) {
                                  //     Navigator.pushNamed(context, MapScreen.id);
                                  //   }
                                  // } catch (e) {}
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
                                      WidgetStatePropertyAll<Color>(
                                          Colors.black),
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          Colors.white),
                                ),
                                onPressed: () async {
                                  phoneCall.makePhoneCall(
                                      allInfoCards[index].phoneNumber);
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
                                      allInfoCards[index].rating.toString(),
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
      ),
    );
  }
}
