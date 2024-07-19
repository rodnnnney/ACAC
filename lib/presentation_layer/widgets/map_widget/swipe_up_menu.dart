import 'package:ACAC/domain_layer/controller/restaurant_info_card_list.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/widgets/map_widget/swipe_up_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy;

class SwipeUpMenu extends ConsumerStatefulWidget {
  final LatLng userLocation;

  const SwipeUpMenu({super.key, required this.userLocation});

  @override
  ConsumerState<SwipeUpMenu> createState() => _SwipeUpMenuState();
}

class _SwipeUpMenuState extends ConsumerState<SwipeUpMenu> {
  UserLocation location = UserLocation();
  List<RestaurantInfoCard> allInfoCards = [];

  Future<LatLng> getLocation() async {
    return await location.find();
  }

  @override
  Widget build(BuildContext context) {
    final data = legacy.Provider.of<RestaurantInfo>(context);
    final maps = legacy.Provider.of<PolyInfo>(context);
    final nav = legacy.Provider.of<NavInfo>(context);
    final double screenHeight = MediaQuery.sizeOf(context).height;
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    var test = ref.watch(restaurantInfoCardListProvider);

    switch (test) {
      case AsyncData(value: final allInfoLoaded):
        for (var data in allInfoLoaded) {
          allInfoCards.add(data);
        }
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.05364807, left: 5, right: 5),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: Icon(
                  Icons.remove,
                  size: 35,
                  color:
                      ref.watch(darkLight).theme ? Colors.white : Colors.black,
                ),
              ),
            ),
            body: FutureBuilder<LatLng>(
              future: getLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Location not found'));
                } else {
                  return GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of cards in a row
                      crossAxisSpacing: 10, // Horizontal space between cards
                      mainAxisSpacing: 10, // Vertical space between cards
                      childAspectRatio: 2 / 3, //(screenHeight * 0.00091316), //
                      // Aspect ratio of the cards
                    ),
                    itemCount: allInfoCards.length,
                    itemBuilder: (context, index) {
                      return SwipeUpCard(
                        restaurant: allInfoCards[index],
                        data: data,
                        gmaps: maps,
                        nav: nav,
                        weekday: weekday,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
