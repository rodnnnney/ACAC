import 'dart:convert';

import 'package:ACAC/domain_layer/repository_interface/time_formatter.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:ACAC/presentation_layer/pages/maps.dart';
import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/userLocation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class SwipeUpCard extends ConsumerStatefulWidget {
  final RestaurantInfoCard restaurant;
  final RestaurantInfo data;
  final PolyInfo gmaps;
  final NavInfo nav;
  final int weekday;

  const SwipeUpCard({
    super.key,
    required this.restaurant,
    required this.data,
    required this.gmaps,
    required this.nav,
    required this.weekday,
  });

  @override
  ConsumerState<SwipeUpCard> createState() => _SwipeUpCardState();
}

class _SwipeUpCardState extends ConsumerState<SwipeUpCard> {
  double fSize = 11;
  late String distance;

  @override
  Widget build(BuildContext context) {
    final userLocationAsyncValue = ref.watch(userLocationProvider);
    final watchCounter = ref.watch(userPageCounter);
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);

    Future<String> getDistance(LatLng user, LatLng restaurant) async {
      String url = await widget.gmaps.createHttpUrl(user.latitude,
          user.longitude, restaurant.latitude, restaurant.longitude);
      var decodedJson = jsonDecode(url);
      String distance = decodedJson['routes'][0]['legs'][0]['distance']['text'];
      return distance;
    }

    void updatePage(int index, String route) {
      Navigator.pushNamed(context, route);
      ref.read(userPageCounter).setCounter(index);
    }

    return GestureDetector(
      onTap: () {
        // distance.isNotEmpty
        //     ? String distance = await getDistance();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AdditionalDataDbb(
        //       restaurant: allInfoCards[index],
        //       distance: distance,
        //     ),
        //   ),
        // );
        //     : () {};
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.restaurant.imageSrc,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: userLocationAsyncValue.when(
                      data: (location) {
                        return FutureBuilder<String>(
                          future: getDistance(
                            location,
                            LatLng(
                              double.parse(widget.restaurant.location.latitude),
                              double.parse(
                                  widget.restaurant.location.longitude),
                            ),
                          ),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Waiting',
                                  style: TextStyle(fontSize: fSize));
                            } else if (snap.hasError) {
                              return Text('Error: ${snap.error}',
                                  style: TextStyle(fontSize: fSize));
                            } else if (snap.hasData) {
                              distance = snap.data!;
                              return Text(snap.data ?? '',
                                  style: TextStyle(
                                      fontSize: fSize,
                                      color: watchCounter.counter == 0
                                          ? Colors.white
                                          : Colors.black));
                            } else {
                              return Text('Unknown error',
                                  style: TextStyle(fontSize: fSize));
                            }
                          },
                        );
                      },
                      error: (err, stack) => Text('Error: $err'),
                      loading: () => const CircularProgressIndicator(),
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
                        widget.restaurant.restaurantName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            widget.restaurant.address,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        getHour(widget.restaurant, widget.weekday),
                        style: TextStyle(
                          color: timeColor(
                            DateTime.now(),
                            getOpeningTimeSingle(
                                widget.weekday, widget.restaurant),
                            getClosingTimeSingle(
                                widget.weekday, widget.restaurant),
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 6)),
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
                                      double.parse(
                                          widget.restaurant.location.latitude),
                                      double.parse(widget
                                          .restaurant.location.longitude));

                                  maps.processPolylineData(url);
                                  maps.updateCameraBounds([
                                    user,
                                    widget.restaurant.location as LatLng
                                  ]);
                                  nav.updateRouteDetails(url);
                                } catch (e) {}
                              },
                              child: const Text('Find on Map'),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE8E8E8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  widget.restaurant.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
