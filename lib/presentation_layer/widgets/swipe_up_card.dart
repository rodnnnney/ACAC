import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy;

class SwipeUpMenu extends ConsumerStatefulWidget {
  LatLng userLocation;

  SwipeUpMenu({super.key, required this.userLocation});

  @override
  ConsumerState<SwipeUpMenu> createState() => _SwipeUpMenuState();
}

class _SwipeUpMenuState extends ConsumerState<SwipeUpMenu> {
  @override
  Widget build(BuildContext context) {
    final restaurantProvider = ref.read(restaurant);
    Restaurant data = legacy.Provider.of<Restaurant>(context);
    PolyInfo maps = legacy.Provider.of<PolyInfo>(context);
    NavInfo nav = legacy.Provider.of<NavInfo>(context);
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.05364807, left: 5, right: 5),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Center(
                child: Icon(
                  Icons.remove,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ),
            // padding: EdgeInsets.only(top: 80),
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of cards in a row
                crossAxisSpacing: 10, // Horizontal space between cards
                mainAxisSpacing: 10, // Vertical space between cards
                childAspectRatio:
                    (screenHeight * 0.00081316), // Aspect ratio of the cards
              ),
              itemCount: restaurantProvider.length,
              itemBuilder: (context, index) {
                String getHours() {
                  DateTime now = DateTime.now();
                  int weekday = now.weekday;
                  if (weekday == 1) {
                    return ('${restaurantProvider[index].hours.monday.startTime} - ${restaurantProvider[index].hours.monday.endTime}');
                  } else if (weekday == 2) {
                    return ('${restaurantProvider[index].hours.tuesday.startTime} - ${restaurantProvider[index].hours.tuesday.endTime}');
                  } else if (weekday == 3) {
                    return ('${restaurantProvider[index].hours.wednesday.startTime} - ${restaurantProvider[index].hours.wednesday.endTime}');
                  } else if (weekday == 4) {
                    return ('${restaurantProvider[index].hours.thursday.startTime} - ${restaurantProvider[index].hours.thursday.endTime}');
                  } else if (weekday == 5) {
                    return ('${restaurantProvider[index].hours.friday.startTime} - ${restaurantProvider[index].hours.friday.endTime}');
                  } else if (weekday == 6) {
                    return ('${restaurantProvider[index].hours.saturday.startTime} - ${restaurantProvider[index].hours.saturday.endTime}');
                  } else if (weekday == 7) {
                    return ('${restaurantProvider[index].hours.sunday.startTime} - ${restaurantProvider[index].hours.sunday.endTime}');
                  } else {
                    return 'Closed';
                  }
                }

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              restaurantProvider[index]
                                  .imageSrc, // Adjust the image path as necessary
                              width: double.infinity,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(restaurantProvider[index].restaurantName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold)), // Example title
                                const SizedBox(height: 4),
                                Text(restaurantProvider[index].address),
                                Text(getHours()),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      style: const ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 8)),
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                                Colors.green),
                                        foregroundColor:
                                            WidgetStatePropertyAll<Color>(
                                                Colors.white),
                                      ),
                                      onPressed: () async {
                                        try {
                                          LatLng user =
                                              await data.getLocation();
                                          String url = await maps.createHttpUrl(
                                              user.latitude,
                                              user.longitude,
                                              restaurantProvider[index]
                                                  .location
                                                  .latitude,
                                              restaurantProvider[index]
                                                  .location
                                                  .longitude);
                                          maps.processPolylineData(url);
                                          maps.updateCameraBounds([
                                            user,
                                            restaurantProvider[index].location
                                          ]);
                                          nav.updateRouteDetails(url);

                                          Navigator.pop(context);
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: const Text('Find on Map'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFE8E8E8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          restaurantProvider[index]
                                              .rating
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
