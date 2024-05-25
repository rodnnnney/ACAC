import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Navigation_Info_Provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Polyline_Info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Restaurant_Provider.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  LatLng userLocation;

  AddTask({super.key, required this.userLocation});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    Restaurant data = Provider.of<Restaurant>(context);
    PolyInfo maps = Provider.of<PolyInfo>(context);
    NavInfo nav = Provider.of<NavInfo>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 50),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Icon(Icons.remove, size: 40),
          ),
        ),
        // padding: EdgeInsets.only(top: 80),
        body: Scaffold(
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of cards in a row
              crossAxisSpacing: 10, // Horizontal space between cards
              mainAxisSpacing: 10, // Vertical space between cards
              childAspectRatio: 0.74, // Aspect ratio of the cards
            ),
            itemCount: data.restaurantInfo.length,
            // Assuming 'items' is a list in your Data provider
            itemBuilder: (context, index) {
              String getHours() {
                DateTime now = DateTime.now();
                int weekday = now.weekday;
                if (weekday == 1) {
                  return ('${data.restaurantInfo[index].hours.monday.startTime} - ${data.restaurantInfo[index].hours.monday.endTime}');
                } else if (weekday == 2) {
                  return ('${data.restaurantInfo[index].hours.tuesday.startTime} - ${data.restaurantInfo[index].hours.tuesday.endTime}');
                } else if (weekday == 3) {
                  return ('${data.restaurantInfo[index].hours.wednesday.startTime} - ${data.restaurantInfo[index].hours.wednesday.endTime}');
                } else if (weekday == 4) {
                  return ('${data.restaurantInfo[index].hours.thursday.startTime} - ${data.restaurantInfo[index].hours.thursday.endTime}');
                } else if (weekday == 5) {
                  return ('${data.restaurantInfo[index].hours.friday.startTime} - ${data.restaurantInfo[index].hours.friday.endTime}');
                } else if (weekday == 6) {
                  return ('${data.restaurantInfo[index].hours.saturday.startTime} - ${data.restaurantInfo[index].hours.saturday.endTime}');
                } else if (weekday == 7) {
                  return ('${data.restaurantInfo[index].hours.sunday.startTime} - ${data.restaurantInfo[index].hours.sunday.endTime}');
                } else {
                  return 'Closed';
                }
              }

              return Container(
                child: Card(
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
                              data.restaurantInfo[index]
                                  .imageSrc, // Adjust the image path as necessary
                              width: double.infinity,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.restaurantInfo[index].restaurantName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold)), // Example title
                                const SizedBox(height: 4),
                                Text(data.restaurantInfo[index].address),
                                Text(getHours()),
                                Row(
                                  children: [
                                    TextButton(
                                      style: const ButtonStyle(
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
                                              data.restaurantInfo[index]
                                                  .location.latitude,
                                              data.restaurantInfo[index]
                                                  .location.longitude);
                                          maps.processPolylineData(url);
                                          maps.updateCameraBounds([
                                            user,
                                            data.restaurantInfo[index].location
                                          ]);
                                          nav.updateRouteDetails(url);

                                          Navigator.pop(context);
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Text('Find on Map'),
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFE8E8E8),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text(
                                          data.restaurantInfo[index].rating
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
