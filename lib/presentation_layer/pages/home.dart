import 'package:ACAC/common_layer/consts/globals.dart';
import 'package:ACAC/common_layer/services/route_observer.dart';
import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/common_layer/widgets/welcome_text.dart';
import 'package:ACAC/domain_layer/controller/restaurant_info_card_list.dart';
import 'package:ACAC/domain_layer/local_db/sort_by_country.dart';
import 'package:ACAC/domain_layer/local_db/sort_by_food_type.dart';
import 'package:ACAC/domain_layer/service/restaurant_api_service.dart';
import 'package:ACAC/domain_layer/service/restaurant_info_card.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:ACAC/presentation_layer/pages/settings.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/widgets/home_page_card.dart';
import 'package:ACAC/presentation_layer/widgets/sort_by_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dbb_test.dart';
import 'history.dart';

class HomePage extends ConsumerStatefulWidget {
  static String id = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
  final List<String> images = [
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/china.webp',
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/tofu.webp',
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/japan.avif',
  ];

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
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
                            IconButton(
                              onPressed: () async {
                                RestaurantInfoCard test = RestaurantInfoCard(
                                  restaurantName: 'Kinton Ramen',
                                  location: LatLng(
                                      latitude: '45.41913804744197',
                                      longitude: '-75.6914954746089'),
                                  address: '216 Elgin St #2',
                                  imageSrc:
                                      'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/kt.jpeg',
                                  imageLogo:
                                      'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/kintonlogo.png',
                                  scannerDataMatch: 'Kinton_Ramen',
                                  hours: Time(
                                    monday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                    tuesday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                    wednesday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                    thursday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                    friday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                    saturday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                    sunday: StartStop(
                                        start: '11:30 AM', stop: '10:30 PM'),
                                  ),
                                  rating: 4.8,
                                  cuisineType: ['Japanese', 'Noodle'],
                                  reviewNum: 1569,
                                  discounts: ['10% off dine in'],
                                  discountPercent: '10',
                                  phoneNumber: '+1613 565 8138',
                                  gMapsLink:
                                      'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
                                  websiteLink:
                                      'https://www.kintonramen.com/menu/',
                                  topRatedItemsImgSrc: [
                                    'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/ramen1.webp',
                                    'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/ramen2.webp',
                                    'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/ramen3.png'
                                  ],
                                  topRatedItemsName: [
                                    'Pork Original',
                                    'Beef Original',
                                    'Pork Shoyu'
                                  ],
                                );
                                await ref
                                    .read(restaurantInfoCardAPIServiceProvider)
                                    .addRestaurantInfoCard(test);
                                print('done');
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => DiscountCard(
                                //             restName: 'Kinton_Ramen',
                                //             firstName: 'Rodney',
                                //             lastName: 'Shen',
                                //           )),
                                // );
                              },
                              icon: const Icon(Icons.card_giftcard_outlined),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                Navigator.pushNamed(context, AccountInfo.id);
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Country:',
                            style: TextStyle(
                                color: GlobalTheme.kWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 130,
                          // Set appropriate height for GridView
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sortByCountry.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeCard(
                                  displayIMG: sortByCountry[index].displayIMG,
                                  text: sortByCountry[index].text,
                                  routeName: sortByCountry[index].routeName);
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
                          // Set appropriate height for GridView
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sortByFoodType.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeCard(
                                  displayIMG: sortByFoodType[index].displayIMG,
                                  text: sortByFoodType[index].text,
                                  routeName: sortByFoodType[index].routeName);
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
                        Row(
                          children: [
                            SizedBox(
                              height: 130,
                              child: HomeCard(
                                displayIMG: 'https://acacpicture'
                                    'sgenerealbucket.s3.amazonaws.com/chinese2'
                                    '.png',
                                text: 'Rating',
                                routeName: (BuildContext, String) {
                                  Navigator.pushNamed(
                                    context,
                                    SortedByRating.id,
                                  );
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DbbTest()),
                                );
                              },
                              child: const SizedBox(
                                height: 130,
                                child: Card(
                                  color: Colors.pink,
                                  child: SizedBox(
                                      width: 120,
                                      height: 130,
                                      child: Text('s')),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        // GestureDetector(
                        //   onTap: ,
                        //     child: Text('data'))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBarBottom(
        id: HomePage.id,
      ),
    );
  }
}

// Name is a future provider that is cached upon first time loading page
// final userNameProviderProvider = FutureProvider<String>((ref) async {
//   try {
//     var currentUser = await Amplify.Auth.getCurrentUser();
//     var users = await ref.read(userAPIServiceProvider).getUsers();
//     for (var user in users) {
//       if (user.id == currentUser.userId) {
//         return user.firstName;
//       }
//     }
//     throw Exception('User not found');
//   } catch (e) {
//     debugPrint('Error getting user name: $e');
//     rethrow;
//   }
// });
