import 'dart:convert';

import 'package:ACAC/common_layer/cachedRestaurantProvider.dart';
import 'package:ACAC/common_layer/consts/globals.dart';
import 'package:ACAC/common_layer/services/getDistance.dart';
import 'package:ACAC/common_layer/services/route_observer.dart';
import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/common_layer/widgets/common/home_page_card.dart';
import 'package:ACAC/common_layer/widgets/welcome_text.dart';
import 'package:ACAC/domain_layer/local_db/sort_by_country.dart';
import 'package:ACAC/domain_layer/local_db/sort_by_food_type.dart';
import 'package:ACAC/domain_layer/repository_interface/time_formatter.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/presentation_layer/pages/settings.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/widgets/sort_by_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'history.dart';

class HomePage extends ConsumerStatefulWidget {
  static String id = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

LatLng userLocation = LatLng(0, 0);
GetDistance getDistance = GetDistance();
final Map<String, String> distanceCache = {};

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
  final List<String> images = [
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/china.webp',
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/tofu.webp',
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/japan.avif',
  ];

  Future<void> _initializeLocation() async {
    try {
      userLocation = await location.find();
    } catch (e) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    ref.read(userPageCounter).setCounter(0);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    var restaurantData = ref.watch(cachedRestaurantInfoCardListProvider);

    return Scaffold(
      body: restaurantData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (allInfoCards) {
            int weekday = DateTime.now().weekday;
            final restaurantsByTimesVisited =
                List<RestaurantInfoCard>.from(allInfoCards)
                  ..sort((a, b) => b.timesVisited.compareTo(a.timesVisited));
            return SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 5, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Welcome(),
                              Row(
                                children: [
                                  // IconButton(
                                  //   onPressed: () async {},
                                  //   icon: const Icon(
                                  //       Icons.card_giftcard_outlined),
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      Navigator.pushNamed(
                                          context, AccountInfo.id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            GlobalTheme.kDarkGreen,
                                            GlobalTheme.kGreen,
                                            Color(0xff98C48D)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: const Icon(
                                        Icons.account_circle,
                                        color: GlobalTheme.kWhite,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      Navigator.pushNamed(context, History.id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            GlobalTheme.kGreen,
                                            Color(0xff98C48D),
                                            GlobalTheme.kDarkGreen,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: const Icon(Icons.receipt,
                                          color: GlobalTheme.kWhite),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: GlobalTheme.spacing,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(colors: [
                                      GlobalTheme.kDarkGreen,
                                      GlobalTheme.kGreen,
                                    ]).createShader(bounds),
                                    child: const Text(
                                      'Featured',
                                      style: TextStyle(
                                          color: GlobalTheme.kWhite,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(colors: [
                                      GlobalTheme.kDarkGreen,
                                      GlobalTheme.kGreen,
                                    ]).createShader(bounds),
                                    child: Text(
                                      'Items Found: ${images.length}',
                                      style: const TextStyle(
                                          color: GlobalTheme.kWhite,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: screenHeight * 0.19,
                                child: PageView.builder(
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        imageUrl: images[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(colors: [
                                  GlobalTheme.kDarkGreen,
                                  GlobalTheme.kGreen,
                                ]).createShader(bounds),
                                child: const Text(
                                  'ACAC Favourites:',
                                  style: TextStyle(
                                      color: GlobalTheme.kWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                        width: 200,
                                        child: UserCard(
                                          restaurantInfoCard:
                                              restaurantsByTimesVisited[index],
                                        ));
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(colors: [
                                  GlobalTheme.kDarkGreen,
                                  GlobalTheme.kGreen,
                                ]).createShader(bounds),
                                child: const Text(
                                  'Country:',
                                  style: TextStyle(
                                      color: GlobalTheme.kWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sortByCountry.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return HomeCard(
                                        displayIMG:
                                            sortByCountry[index].displayIMG,
                                        text: sortByCountry[index].text,
                                        routeName:
                                            sortByCountry[index].routeName);
                                  },
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(colors: [
                                  GlobalTheme.kDarkGreen,
                                  GlobalTheme.kGreen,
                                ], stops: [
                                  0.0,
                                  0.5,
                                ]).createShader(bounds),
                                child: const Text(
                                  'Food Type:',
                                  style: TextStyle(
                                      color: GlobalTheme.kWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sortByFoodType.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return HomeCard(
                                        displayIMG:
                                            sortByFoodType[index].displayIMG,
                                        text: sortByFoodType[index].text,
                                        routeName:
                                            sortByFoodType[index].routeName);
                                  },
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(colors: [
                                  GlobalTheme.kDarkGreen,
                                  GlobalTheme.kGreen,
                                ], stops: [
                                  0.0,
                                  0.5,
                                ]).createShader(bounds),
                                child: const Text(
                                  'Popularity:',
                                  style: TextStyle(
                                      color: GlobalTheme.kWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      child: HomeCard(
                                        displayIMG:
                                            'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/chinese2.png',
                                        text: 'Rating',
                                        routeName: (BuildContext, String) {
                                          Navigator.pushNamed(
                                            context,
                                            SortedByRating.id,
                                          );
                                        },
                                      ),
                                    ),
//TODO All cards

// GestureDetector(
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => const DbbTest()),
//     );
//   },
//   child: const SizedBox(
//     height: 130,
//     child: Card(
//       color: Colors.pink,
//       child: SizedBox(
//           width: 120,
//           height: 130,
//           child: Text('s')),
//     ),
//   ),
// ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: AppBarBottom(
        id: HomePage.id,
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard({super.key, required this.restaurantInfoCard});

  final RestaurantInfoCard restaurantInfoCard;
  final int weekday = DateTime.now().weekday;

  Future<String> getDistanceForRestaurant(RestaurantInfoCard restaurant) async {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: restaurantInfoCard.imageSrc,
                  width: double.infinity,
                  height: 100,
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
                  child: FutureBuilder<String>(
                    future: getDistanceForRestaurant(restaurantInfoCard),
                    builder: (context, snapshot) {
                      return Text(snapshot.data ?? 'Getting Distance..');
                    },
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: Container(
                  width: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE8E8E8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        restaurantInfoCard.rating.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              )
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
                      restaurantInfoCard.restaurantName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          restaurantInfoCard.address,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      getHour(restaurantInfoCard, weekday),
                      style: TextStyle(
                        color: timeColor(
                          DateTime.now(),
                          getOpeningTimeSingle(weekday, restaurantInfoCard),
                          getClosingTimeSingle(weekday, restaurantInfoCard),
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
