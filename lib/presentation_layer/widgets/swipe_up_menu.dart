import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/domain_layer/repository_interface/location.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:googlemaptest/presentation_layer/widgets/swipe_up_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy;

class SwipeUpMenu extends ConsumerStatefulWidget {
  LatLng userLocation;

  SwipeUpMenu({super.key, required this.userLocation});

  @override
  ConsumerState<SwipeUpMenu> createState() => _SwipeUpMenuState();
}

class _SwipeUpMenuState extends ConsumerState<SwipeUpMenu> {
  UserLocation location = UserLocation();

  Future<LatLng> getLocation() async {
    return await location.find();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = ref.watch(restaurant);
    final data = legacy.Provider.of<Restaurant>(context);
    final maps = legacy.Provider.of<PolyInfo>(context);
    final nav = legacy.Provider.of<NavInfo>(context);
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
                return SwipeUpCard(
                  restaurant: restaurantProvider[index],
                  data: data,
                  gmaps: maps,
                  nav: nav,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
