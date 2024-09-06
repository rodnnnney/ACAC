import 'dart:convert';

import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/routing/ui/app_bar.dart';
import 'package:ACAC/common/routing/ui/centerNavButton.dart';
import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/helper_widgets/card/additional_data_dbb.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

// Define the page route ID
class Favourites extends ConsumerStatefulWidget {
  static String id = '/favs';

  Favourites({super.key});

  @override
  ConsumerState<Favourites> createState() => _HistoryState();
}

late String distance;
UserLocation location = UserLocation();
List<RestaurantInfoCard> allInfoCards = [];

RestaurantInfoCard getInfo(
    List<RestaurantInfoCard> infoList, String checkName) {
  for (var info in infoList) {
    if (info.restaurantName == checkName) {
      return info;
    }
  }
  throw ErrorDescription('${checkName} not found');
}

// Function to fetch user's current location
Future<LatLng> getLocation() async {
  return await location.find();
}

List<RestaurantInfoCard> filterObjectsByNames(
    List<RestaurantInfoCard> objects, List<String> namesToMatch) {
  return objects
      .where((obj) => namesToMatch.contains(obj.restaurantName))
      .toList();
}

// Stateful widget for the history page
class _HistoryState extends ConsumerState<Favourites> {
  @override
  Widget build(BuildContext context) {
    final maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    var test = ref.watch(restaurantInfoCardListProvider);
    final itemsRepository = ref.read(userRepositoryProvider);

    Future<User> getUserInfo() async {
      var userID = await Amplify.Auth.getCurrentUser();
      return await itemsRepository.getUser(userID.userId);
    }

    // Function to fetch distance between user and restaurant
    Future<String> getDistance(LatLng user, LatLng restaurant) async {
      String url = await maps.createHttpUrl(user.latitude, user.longitude,
          restaurant.latitude, restaurant.longitude);
      var decodedJson = jsonDecode(url);
      String distanceNew = decodedJson['routes'][0]['legs'][0]['distance']['tex'
          't'];
      return distanceNew;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CenterNavWidget(
        ref: ref,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<User>(
                future: getUserInfo(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 600,
                      child: test.when(
                        data: (restaurants) {
                          allInfoCards = filterObjectsByNames(restaurants,
                              snapshot.data?.favouriteRestaurants ?? []);
                          if (allInfoCards.isEmpty) {
                            return const Scaffold(
                                body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No history so far!'),
                                  Text('Scanned restaurants will show up here!')
                                ],
                              ),
                            ));
                          } else {
                            return FutureBuilder<LatLng>(
                              future: getLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return const Center(
                                      child: Text('Location not found'));
                                } else {
                                  return ListView.builder(
                                    itemCount: allInfoCards.length,
                                    itemBuilder: (context, index) {
                                      var card = allInfoCards[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 32,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                  card.imageLogo),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              card.restaurantName,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Opacity(
                                                                  opacity: 0.65,
                                                                  child: Text(
                                                                    card.address,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        HapticFeedback
                                                            .heavyImpact();
                                                        LatLng user = await data
                                                            .getLocation();
                                                        String distance =
                                                            await getDistance(
                                                          user,
                                                          LatLng(
                                                            double.parse(card
                                                                .location
                                                                .latitude),
                                                            double.parse(card
                                                                .location
                                                                .longitude),
                                                          ),
                                                        );
                                                        if (context.mounted) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AdditionalDataDbb(
                                                                restaurant:
                                                                    card,
                                                                distance:
                                                                    distance,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        'View Store',
                                                        style: TextStyle(
                                                            color: ref
                                                                    .watch(
                                                                        darkLight)
                                                                    .theme
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                        error: (error, stack) {
                          return Center(
                            child: Text('Error: $error'),
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else {
                    return const Text('data');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBarBottom(id: Favourites.id),
    );
  }
}
