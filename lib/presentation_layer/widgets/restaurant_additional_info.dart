import 'package:flutter/material.dart';
import 'package:googlemaptest/common_layer/widgets/start_builder.dart';
import 'package:googlemaptest/domain_layer/repository_interface/cards.dart';
import 'package:googlemaptest/domain_layer/repository_interface/time_formatter.dart';
import 'package:intl/intl.dart';

class RestaurantAdditionalInfo extends StatelessWidget {
  const RestaurantAdditionalInfo(
      {super.key, required this.restaurant, required this.distance});

  final restaurantCard restaurant;
  final String distance;

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  //TODO Distance from user next
  // TODO Pictures of food? List[Dish src(strings)] and List[Dish names(strings)]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset(
                restaurant.imageSrc,
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.restaurantName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            // Horizontal black line
                            Text('-' *
                                (restaurant.restaurantName.length * 1.5)
                                    .toInt()),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(restaurant.address),
                            Row(
                              children: [
                                FutureBuilder<Map<String, dynamic>>(
                                  future: getCurrentStatusWithColor(
                                      restaurant.hours
                                          .getTodayStartStop()
                                          .startTime,
                                      restaurant.hours
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
                                const SizedBox(width: 7),
                                Text(
                                    '${restaurant.hours.getTodayStartStop().startTime} - ${restaurant.hours.getTodayStartStop().endTime}')
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                buildStarRating(restaurant.rating),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(restaurant.rating.toString()),
                              ],
                            ),
                            Text(
                                '${formatNumber(restaurant.reviewNum)} + ratings'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(distance), Text('Cuisine Type')],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
