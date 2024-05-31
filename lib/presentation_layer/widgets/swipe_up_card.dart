import 'dart:async';
import 'dart:convert';

import 'package:acacmobile/domain_layer/repository_interface/cards.dart';
import 'package:acacmobile/domain_layer/repository_interface/time_formatter.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:acacmobile/presentation_layer/state_management/riverpod/userLocation.dart';
import 'package:acacmobile/presentation_layer/widgets/restaurant_additional_info.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SwipeUpCard extends ConsumerStatefulWidget {
  final restaurantCard restaurant;
  final Restaurant data;
  final PolyInfo gmaps;
  final NavInfo nav;

  const SwipeUpCard({
    super.key,
    required this.restaurant,
    required this.data,
    required this.gmaps,
    required this.nav,
  });

  @override
  ConsumerState<SwipeUpCard> createState() => _SwipeUpCardState();
}

class _SwipeUpCardState extends ConsumerState<SwipeUpCard> {
  String getHours() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    switch (weekday) {
      case DateTime.monday:
        return '${widget.restaurant.hours.monday.startTime} - ${widget.restaurant.hours.monday.endTime}';
      case DateTime.tuesday:
        return '${widget.restaurant.hours.tuesday.startTime} - ${widget.restaurant.hours.tuesday.endTime}';
      case DateTime.wednesday:
        return '${widget.restaurant.hours.wednesday.startTime} - ${widget.restaurant.hours.wednesday.endTime}';
      case DateTime.thursday:
        return '${widget.restaurant.hours.thursday.startTime} - ${widget.restaurant.hours.thursday.endTime}';
      case DateTime.friday:
        return '${widget.restaurant.hours.friday.startTime} - ${widget.restaurant.hours.friday.endTime}';
      case DateTime.saturday:
        return '${widget.restaurant.hours.saturday.startTime} - ${widget.restaurant.hours.saturday.endTime}';
      case DateTime.sunday:
        return '${widget.restaurant.hours.sunday.startTime} - ${widget.restaurant.hours.sunday.endTime}';
      default:
        return 'Closed';
    }
  }

  double fSize = 11;
  late String distance;

  @override
  Widget build(BuildContext context) {
    final userLocationAsyncValue = ref.watch(userLocationProvider);

    Future<String> getDistance(LatLng user, LatLng restaurant) async {
      String url = await widget.gmaps.createHttpUrl(user.latitude,
          user.longitude, restaurant.latitude, restaurant.longitude);
      var decodedJson = jsonDecode(url);
      String distance = decodedJson['routes'][0]['legs'][0]['distance']['text'];
      return distance;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantAdditionalInfo(
              restaurant: widget.restaurant,
              distance: distance,
            ),
          ),
        );
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
                  child: Image.asset(
                    widget.restaurant.imageSrc,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: userLocationAsyncValue.when(
                      data: (location) {
                        return FutureBuilder<String>(
                          future:
                              getDistance(location, widget.restaurant.location),
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
                                  style: TextStyle(fontSize: fSize));
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
                        getHours(),
                        style: TextStyle(
                          color: timeColor(
                              DateTime.now(),
                              widget.restaurant.hours
                                  .getTodayStartStop()
                                  .startTime,
                              widget.restaurant.hours
                                  .getTodayStartStop()
                                  .endTime),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 8)),
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.green),
                              foregroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async {
                              try {
                                LatLng user = await widget.data.getLocation();
                                String url = await widget.gmaps.createHttpUrl(
                                  user.latitude,
                                  user.longitude,
                                  widget.restaurant.location.latitude,
                                  widget.restaurant.location.longitude,
                                );
                                widget.gmaps.processPolylineData(url);
                                widget.gmaps.updateCameraBounds(
                                    [user, widget.restaurant.location]);
                                widget.nav.updateRouteDetails(url);
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: const Text('Find on Map'),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8E8E8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
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
