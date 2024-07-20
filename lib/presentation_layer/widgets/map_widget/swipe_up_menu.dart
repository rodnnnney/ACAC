import 'package:ACAC/common_layer/cachedRestaurantProvider.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/widgets/map_widget/swipe_up_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SwipeUpMenu extends ConsumerStatefulWidget {
  final LatLng userLocation;

  const SwipeUpMenu({Key? key, required this.userLocation}) : super(key: key);

  @override
  ConsumerState<SwipeUpMenu> createState() => _SwipeUpMenuState();
}

class _SwipeUpMenuState extends ConsumerState<SwipeUpMenu> {
  LatLng userPosition = const LatLng(0, 0);
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
    final double screenHeight = MediaQuery.of(context).size.height;
    var restaurantData = ref.watch(cachedRestaurantInfoCardListProvider);

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
            body: restaurantData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (allInfoCards) => GridView.builder(
                physics: const ClampingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: allInfoCards.length,
                itemBuilder: (context, index) {
                  return IgnorePointer(
                    ignoring: userPosition == const LatLng(0, 0),
                    child: Opacity(
                      opacity: userPosition == const LatLng(0, 0) ? 0.5 : 1.0,
                      child: SwipeUpCard(
                        restaurant: allInfoCards[index],
                        userPosition: userPosition,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
