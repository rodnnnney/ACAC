import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/domain_layer/repository_interface/cards.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:googlemaptest/presentation_layer/widgets/restaurant_additional_info.dart';

class SwipeUpCard extends StatelessWidget {
  final restaurantCard restaurant;
  final Restaurant data;
  final PolyInfo maps;
  final NavInfo nav;

  const SwipeUpCard({
    super.key,
    required this.restaurant,
    required this.data,
    required this.maps,
    required this.nav,
  });

  String getHours() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;

    switch (weekday) {
      case DateTime.monday:
        return '${restaurant.hours.monday.startTime} - ${restaurant.hours.monday.endTime}';
      case DateTime.tuesday:
        return '${restaurant.hours.tuesday.startTime} - ${restaurant.hours.tuesday.endTime}';
      case DateTime.wednesday:
        return '${restaurant.hours.wednesday.startTime} - ${restaurant.hours.wednesday.endTime}';
      case DateTime.thursday:
        return '${restaurant.hours.thursday.startTime} - ${restaurant.hours.thursday.endTime}';
      case DateTime.friday:
        return '${restaurant.hours.friday.startTime} - ${restaurant.hours.friday.endTime}';
      case DateTime.saturday:
        return '${restaurant.hours.saturday.startTime} - ${restaurant.hours.saturday.endTime}';
      case DateTime.sunday:
        return '${restaurant.hours.sunday.startTime} - ${restaurant.hours.sunday.endTime}';
      default:
        return 'Closed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RestaurantAdditionalInfo(restaurant: restaurant),
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
                    restaurant.imageSrc,
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.restaurantName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(restaurant.address),
                      Text(getHours()),
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
                                LatLng user = await data.getLocation();
                                String url = await maps.createHttpUrl(
                                  user.latitude,
                                  user.longitude,
                                  restaurant.location.latitude,
                                  restaurant.location.longitude,
                                );
                                maps.processPolylineData(url);
                                maps.updateCameraBounds(
                                    [user, restaurant.location]);
                                nav.updateRouteDetails(url);
                                Navigator.pop(context);
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
                                restaurant.rating.toString(),
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
