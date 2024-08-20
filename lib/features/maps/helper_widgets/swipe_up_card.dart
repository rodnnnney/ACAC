import 'dart:convert';

import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/common/widgets/helper_functions/time_formatter.dart';
import 'package:ACAC/features/home/helper_widgets/card/additional_data_dbb.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/features/maps/maps.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/features/user_auth/data/user_list_controller.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../service/navigation_info_provider.dart';

class SwipeUpCard extends ConsumerStatefulWidget {
  final RestaurantInfoCard restaurant;
  final LatLng userPosition;

  const SwipeUpCard(
      {super.key, required this.restaurant, required this.userPosition});

  @override
  ConsumerState<SwipeUpCard> createState() => _SwipeUpCardState();
}

class _SwipeUpCardState extends ConsumerState<SwipeUpCard> {
  double fSize = 11;
  int weekday = DateTime.now().weekday;
  final Map<String, String> distanceCache = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchCounter = ref.watch(userPageCounter);
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
    final itemsRepository = ref.read(userRepositoryProvider);

    void updatePage(int index, String route) {
      Navigator.pushNamed(context, route);
      ref.read(userPageCounter).setCounter(index);
    }

    Future<String> userRestDistance() async {
      String url = await maps.createHttpUrl(
          widget.userPosition.latitude,
          widget.userPosition.longitude,
          double.parse(widget.restaurant.location.latitude),
          double.parse(widget.restaurant.location.longitude));
      var decodedJson = jsonDecode(url);
      String distance = decodedJson['routes'][0]['legs'][0]['distance']['text'];
      return distance;
    }

    Future<String> getDistanceForRestaurant(
        RestaurantInfoCard restaurant) async {
      if (distanceCache.containsKey(restaurant.id)) {
        return distanceCache[restaurant.id]!;
      }
      // If not cached, make the API call
      String url = await getDistance.createHttpUrl(
        userLocation.latitude,
        userLocation.longitude,
        double.parse(restaurant.location.latitude),
        double.parse(restaurant.location.longitude),
      );
      var decodedJson = jsonDecode(url);
      String distance = decodedJson['routes'][0]['legs'][0]['distance']['text'];

      // Cache the result
      distanceCache[restaurant.id] = distance;

      return distance;
    }

    Future<User> getUserInfo() async {
      var userID = await Amplify.Auth.getCurrentUser();
      return await itemsRepository.getUser(userID.userId);
    }

    return GestureDetector(
      onTap: () async {
        String distance = await userRestDistance();
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdditionalDataDbb(
                restaurant: widget.restaurant,
                distance: distance,
              ),
            ),
          );
        }
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
                  child: CachedNetworkImage(
                    imageUrl: widget.restaurant.imageSrc,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FutureBuilder(
                      future: getDistanceForRestaurant(widget.restaurant),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? 'Getting Distance..',
                          style: TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),
                FutureBuilder<User>(
                  future: getUserInfo(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData) {
                      bool isFavourite = snapshot.data!.favouriteRestaurants!
                          .contains(widget.restaurant.restaurantName);
                      return Positioned(
                        right: 10,
                        top: 10,
                        child: GestureDetector(
                          onTap: () async {
                            if (isFavourite) {
                              await ref
                                  .read(userListControllerProvider.notifier)
                                  .removeFromFavourite(
                                      widget.restaurant.restaurantName);
                            } else {
                              await ref
                                  .read(userListControllerProvider.notifier)
                                  .addToFavourite(
                                      widget.restaurant.restaurantName);
                            }
                            setState(() {});
                          },
                          child: FavouriteIcon(isFavourite: isFavourite),
                        ),
                      );
                    } else {
                      return const Text('Something went wrong');
                    }
                  },
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
                        widget.restaurant.restaurantName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            widget.restaurant.address,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        getHour(widget.restaurant, weekday),
                        style: TextStyle(
                          color: timeColor(
                            DateTime.now(),
                            getOpeningTimeSingle(
                              weekday,
                              widget.restaurant,
                            ),
                            getClosingTimeSingle(
                              weekday,
                              widget.restaurant,
                            ),
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 6),
                                ),
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                  Colors.green,
                                ),
                                foregroundColor: WidgetStatePropertyAll<Color>(
                                  Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                try {
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, MapScreen.id);
                                  }
                                  if (watchCounter.counter != 2) {
                                    updatePage(2, MapScreen.id);
                                  }
                                  LatLng user = await data.getLocation();
                                  String url = await maps.createHttpUrl(
                                    user.latitude,
                                    user.longitude,
                                    double.parse(
                                      widget.restaurant.location.latitude,
                                    ),
                                    double.parse(
                                      widget.restaurant.location.longitude,
                                    ),
                                  );
                                  nav.updateRouteDetails(url);

                                  maps.processPolylineData(url);
                                  maps.updateCameraBounds([
                                    user,
                                    widget.restaurant.location as LatLng,
                                  ]);
                                } catch (e) {
                                  // Handle error
                                }
                              },
                              child: const Text('Find on Map'),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE8E8E8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
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

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({
    super.key,
    required this.isFavourite,
  });

  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.withOpacity(0.75)),
      child: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_outline,
        color: isFavourite ? Colors.red : Colors.white,
      ),
    );
  }
}
