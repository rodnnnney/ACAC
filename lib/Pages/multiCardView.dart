import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/Pages/Maps.dart';
import 'package:googlemaptest/Providers/Restaurant_Provider.dart';
import 'package:provider/provider.dart';

import '../Locations/location.dart';
import '../Models+Data/Cards.dart';
import '../Providers/Navigation_Info_Provider.dart';
import '../Providers/Polyline_Info.dart';
import '../Providers/UserInfo_Provider.dart';

class cardViewerHomePage extends StatefulWidget {
  static String id = 'card_viewer';

  late String cuisineType;

  cardViewerHomePage({required this.cuisineType});

  @override
  State<cardViewerHomePage> createState() => _cardViewerHomePageState();
}

class _cardViewerHomePageState extends State<cardViewerHomePage> {
  LatLng userPosition = LatLng(0, 0);
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
    PolyInfo maps = Provider.of<PolyInfo>(context);
    Restaurant data = Provider.of<Restaurant>(context);
    NavInfo nav = Provider.of<NavInfo>(context);
    UserInfo loco = Provider.of<UserInfo>(context);
    List<Cards> filteredRestaurants = data.restaurantInfo
        .where((card) => card.cuisineType == widget.cuisineType)
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
                                filteredRestaurants[index].hours.getDay(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                getHours(),
                              ),
                            ],
                          )
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
                            onPressed: () async {
                              try {
                                // Navigator.pushNamed(context, MapScreen.id,
                                //     arguments:
                                //         data.restaurantInfo[index].location);
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
                                Navigator.pushNamed(context, MapScreen.id);
                                loco.setNum(1);
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
