import 'package:flutter/material.dart';
import 'package:googlemaptest/Providers/Restaurant_Provider.dart';
import 'package:provider/provider.dart';

import '../Models+Data/Cards.dart';

class cardViewerHomePage extends StatelessWidget {
  static String id = 'card_viewer';

  cardViewerHomePage({required this.cuisineType});

  late String cuisineType;

  @override
  Widget build(BuildContext context) {
    Restaurant data = Provider.of<Restaurant>(context);
    List<Cards> filteredRestaurants = data.restaurantInfo
        .where((card) => card.cuisineType == cuisineType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(filteredRestaurants[0].cuisineType),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child:
                  Text('${filteredRestaurants.length.toString()} items found')),
        ],
      ),
      body: ListView.builder(
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

          return Container(
            // decoration: BoxDecoration(color: Colors.white),
            margin: EdgeInsets.all(15),
            child: Container(
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
                      child: Image.asset(
                        filteredRestaurants[index].imageSrc,
                        width: double.infinity,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredRestaurants[index].restaurantName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(filteredRestaurants[index].address),
                              Row(
                                children: [
                                  Text(
                                    filteredRestaurants[index].hours.getDay(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    getHours(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.green),
                              foregroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async {},
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
                              padding: EdgeInsets.all(12),
                              child: Text(
                                filteredRestaurants[index].rating.toString(),
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
        itemCount: filteredRestaurants.length,
      ),
    );
  }
}
