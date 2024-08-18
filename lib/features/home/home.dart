import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/routing/ui/app_bar.dart';
import 'package:ACAC/common/services/cachedRestaurantProvider.dart';
import 'package:ACAC/common/services/getDistance.dart';
import 'package:ACAC/common/services/route_observer.dart';
import 'package:ACAC/common/widgets/restaurant_related_ui/home_page_card.dart';
import 'package:ACAC/common/widgets/ui/welcome_text.dart';
import 'package:ACAC/features/chat/chat.dart';
import 'package:ACAC/features/home/helper_widgets/card/home_page_user_card.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_country.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_food_type.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_rating.dart';
import 'package:ACAC/features/scanner/scannerV3.dart';
import 'package:ACAC/features/settings/settings.dart';
import 'package:ACAC/models/MarketingCard.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'controller/marketing_card_controller.dart';
import 'history.dart';

class HomePage extends ConsumerStatefulWidget {
  static String id = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

LatLng userLocation = const LatLng(0, 0);
GetDistance getDistance = GetDistance();
final Map<String, String> distanceCache = {};
final gemini = Gemini.instance;

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
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
    var restaurantData = ref.watch(cachedRestaurantInfoCardListProvider);
    var test = ref.watch(marketingCardControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CenterNavWidget(
        ref: ref,
      ),
      body: restaurantData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (allInfoCards) {
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
                                  TopMenuButton(
                                    iconData: Icons.search_outlined,
                                    pathFunction: () {
                                      Navigator.pushNamed(context, Chat.id);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  TopMenuButton(
                                    iconData: Icons.account_circle,
                                    pathFunction: () {
                                      Navigator.pushNamed(
                                          context, AccountInfo.id);
                                      ref.read(userPageCounter).setCounter(5);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  TopMenuButton(
                                    iconData: Icons.receipt,
                                    pathFunction: () {
                                      Navigator.pushNamed(context, History.id);
                                      ref.read(userPageCounter).setCounter(4);
                                    },
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
                                          fontFamily: 'helveticanowtext',
                                          color: GlobalTheme.kWhite,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        GlobalTheme.kDarkGreen,
                                        GlobalTheme.kGreen,
                                      ],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Items Found: 2',
                                      style: TextStyle(
                                          fontFamily: 'helveticanowtext',
                                          color: GlobalTheme.kWhite,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              test.when(
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (error, stack) =>
                                    Center(child: Text('Error: $error')),
                                data: (marketingCard) {
                                  List<MarketingCard> cardList = marketingCard;
                                  return SizedBox(
                                    height: 240,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: PageView.builder(
                                      itemCount: cardList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CouponCard(
                                                  imageUrl:
                                                      cardList[index].imageUrl,
                                                  header: cardList[index]
                                                      .headerText,
                                                  description: cardList[index]
                                                      .descriptionText,
                                                );
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fitWidth,
                                              width: double.infinity,
                                              imageUrl:
                                                  cardList[index].imageUrl,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const GradientText(gradText: "ACAC Favourites:"),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width: 200,
                                      child: HomePageUserCard(
                                        restaurantInfoCard:
                                            restaurantsByTimesVisited[index],
                                        user: userLocation,
                                        index: index,
                                        ref: ref,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const GradientText(gradText: "Country:"),
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
                              const GradientText(gradText: 'Food Type:'),
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
                                  'Sort by:',
                                  style: TextStyle(
                                      fontFamily: 'helveticanowtext',
                                      color: GlobalTheme.kWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    NoImgCard(
                                      text: 'Rating',
                                      routeName: (BuildContext, String) {
                                        Navigator.pushNamed(
                                            context, SortedByRating.id,
                                            arguments: "RATING");
                                      },
                                    ),
                                    NoImgCard(
                                      text: 'Combined Times Visited',
                                      routeName: (BuildContext, String) {
                                        Navigator.pushNamed(
                                            context, SortedByRating.id,
                                            arguments: "VISIT");
                                      },
                                    ),
                                    NoImgCard(
                                      text: 'Alphabetical',
                                      routeName: (BuildContext, String) {
                                        Navigator.pushNamed(
                                            context, SortedByRating.id,
                                            arguments: "ALPHA");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
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

class GradientText extends StatelessWidget {
  const GradientText({
    super.key,
    required this.gradText,
  });

  final String gradText;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(colors: [
        GlobalTheme.kDarkGreen,
        GlobalTheme.kGreen,
      ], stops: [
        0.0,
        0.5,
      ]).createShader(bounds),
      child: Text(
        gradText,
        style: const TextStyle(
            fontFamily: 'helveticanowtext',
            color: GlobalTheme.kWhite,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CenterNavWidget extends StatelessWidget {
  const CenterNavWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ref.watch(userPageCounter).counter != 1) {
          ref.read(userPageCounter).setCounter(1);
          Navigator.pushNamed(context, App.id);
        }
      },
      child: SizedBox(
        width: 65,
        height: 65,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(35),
          ),
          child: const FittedBox(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopMenuButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback pathFunction;

  const TopMenuButton(
      {super.key, required this.iconData, required this.pathFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        pathFunction();
        // Navigator.pushNamed(context, Chat.id);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GlobalTheme.kDarkGreen,
              GlobalTheme.kGreen,
              Color(0xff98C48D)
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Icon(
          iconData,
          color: GlobalTheme.kWhite,
          size: 30,
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String imageUrl;
  final String header;
  final String description;

  const CouponCard({
    super.key,
    required this.imageUrl,
    required this.header,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          width: double.infinity,
                          imageUrl: imageUrl,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              header,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white),
                      child: const Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
