import 'package:ACAC/common_layer/consts/globals.dart';
import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/common_layer/widgets/welcome_text.dart';
import 'package:ACAC/domain_layer/local_db/sort_by_country.dart';
import 'package:ACAC/domain_layer/local_db/sort_by_food_type.dart';
import 'package:ACAC/presentation_layer/pages/history.dart';
import 'package:ACAC/presentation_layer/pages/settings.dart';
import 'package:ACAC/presentation_layer/widgets/home_page_card.dart';
import 'package:ACAC/presentation_layer/widgets/sort_by_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'discount_card.dart';

class HomePage extends ConsumerWidget {
  static String id = 'home_screen';

  final List<String> images = [
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/china.webp',
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/tofu.webp',
    'https://acacpicturesgenerealbucket.s3.amazonaws.com/japan.avif',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final userInfoAsyncValue = ref.watch(userInfoProvider);
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
                    Welcome(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // userInfoAsyncValue.when(
                        //   data: (Map<String, String> userinfo) {
                        //     final name = userinfo['name'];
                        //     if (name != null) {
                        //       return ShaderMask(
                        //         shaderCallback: (bounds) =>
                        //             const LinearGradient(colors: [
                        //           GlobalTheme.kDarkGreen,
                        //           GlobalTheme.kGreen,
                        //           GlobalTheme.kWhite
                        //         ], stops: [
                        //           0.05,
                        //           0.97,
                        //           1.0
                        //         ]).createShader(bounds),
                        //         child: Text(
                        //           name,
                        //           style: const TextStyle(
                        //               fontSize: 18,
                        //               color: GlobalTheme.kWhite,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       );
                        //     } else {
                        //       return Text(name ?? '');
                        //     }
                        //   },
                        //   error: (error, stack) {
                        //     return const Text('');
                        //   },
                        //   loading: () => const Text('....'),
                        // ),
                        const Text(''),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, DiscountCard.id,
                                      arguments: 'hello');
                                },
                                icon: const Icon(Icons.card_giftcard_outlined)),
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
                                        BorderRadius.all(Radius.circular(30))),
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
                                        BorderRadius.all(Radius.circular(30))),
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
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  GlobalTheme.kDarkGreen,
                                  GlobalTheme.kGreen,
                                ],
                              ).createShader(bounds),
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
                        SizedBox(
                          height: 130,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SortedByRating.id);
                            },
                            child: Card(
                              child: SizedBox(
                                width: 120,
                                height: 130,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        height: 100,
                                        fit: BoxFit.contain,
                                        imageUrl:
                                            'https://acacpicturesgenerealbucket.s3.amazonaws.com/chinese2.png',
                                      ),
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Rating',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
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
        id: id,
      ),
    );
  }
}
