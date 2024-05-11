import 'package:flutter/material.dart';
import 'package:googlemaptest/Pages/multiCardView.dart';
import 'package:googlemaptest/Providers/UserInfo_Provider.dart';
import 'package:provider/provider.dart';

import '../GoogleMaps/WelcomeText.dart';
import '../GoogleMaps/appBar.dart';
import '../Models+Data/homePageCard.dart';

class HomePage extends StatelessWidget {
  static String id = 'home_screen';

  //final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

  String cutAndLowercase(String name) {
    int spaceIndex = name.indexOf(' ');
    if (spaceIndex == -1) {
      return name.toLowerCase();
    }
    return name.substring(0, spaceIndex).toLowerCase();
  }

  final List<String> images = [
    'images/china.webp',
    'images/tofu.webp',
    'images/japan.avif',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    UserInfo user = Provider.of<UserInfo>(context);
    final userDetails = pb.authStore.model;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 30, right: 30, bottom: 5, top: screenHeight * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Welcome(),
                // Text(
                //   user.name == '' ? pb.authStore.model.data['name'] : user.name,
                //   style: TextStyle(
                //     fontSize: 25,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'featured',
                    //   style: TextStyle(fontSize: 24),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(colors: [
                            Color(0xff14342B),
                            Color(0xff60935D),
                          ], stops: [
                            0.1,
                            0.9,
                          ]).createShader(bounds),
                          child: const Text(
                            'featured',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xff036D19),
                              Color(0xff7EA172),
                              Color(0xff60935D),
                            ],
                            // stops: [
                            //   0.1,
                            //   0.9,
                            // ],
                          ).createShader(bounds),
                          child: Text(
                            'items found: ${images.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: screenHeight * 0.19,
                        child: PageView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            })),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(colors: [
                            Color(0xff14342B),
                            Color(0xff60935D),
                            Color(0xffF3F9D2),
                          ], stops: [
                            0.1,
                            0.9,
                            1
                          ]).createShader(bounds),
                          child: const Text(
                            'categories:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/chinese2.png',
                              text: 'chinese',
                              flag: '🇨🇳',
                              routeName:
                                  (BuildContext context, String cuisineType) {
                                Navigator.pushNamed(
                                  context,
                                  cardViewerHomePage.id,
                                  arguments: 'Chinese',
                                );
                              },
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/viet.webp',
                              text: 'vietnamese',
                              flag: '🇻🇳',
                              routeName:
                                  (BuildContext context, String cuisineType) {
                                Navigator.pushNamed(
                                  context,
                                  cardViewerHomePage.id,
                                  arguments: cuisineType,
                                );
                              },
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/japan.avif',
                              text: 'japanese',
                              flag: '🇯🇵',
                              routeName:
                                  (BuildContext context, String cuisineType) {
                                Navigator.pushNamed(
                                  context,
                                  cardViewerHomePage.id,
                                  arguments: cuisineType,
                                );
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/korean.jpeg',
                              text: 'korean',
                              flag: '🇰🇷',
                              routeName:
                                  (BuildContext context, String cuisineType) {
                                Navigator.pushNamed(
                                  context,
                                  cardViewerHomePage.id,
                                  arguments: 'Chinese',
                                );
                              },
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/boba.webp',
                              text: 'bubble tea',
                              flag: '🧋',
                              routeName:
                                  (BuildContext context, String cuisineType) {
                                Navigator.pushNamed(
                                  context,
                                  cardViewerHomePage.id,
                                  arguments: cuisineType,
                                );
                              },
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/club.webp',
                              text: 'bars',
                              flag: '🍷',
                              routeName:
                                  (BuildContext context, String cuisineType) {
                                Navigator.pushNamed(
                                  context,
                                  cardViewerHomePage.id,
                                  arguments: cuisineType,
                                );
                              },
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: AppBarBottom(
        id: id,
      ),
    );
  }
}

// 21 Total Restaurants

// Pomelo Hat || Bubble Tea
// Chatime Chinatown || Bubble Tea
// Hangout Bubble Tea || Bubble Tea
// Shuyi tea Merivale || Bubble Tea

// Dakgogi || Korean

// Parle || Viet
// pho bo ga king || Viet
// Pho Lady || Viet
// Yes Mama Kitchen || Viet

// Oriental House || Chinese
// Papa Spicy || Chinese
// La Noodle Clyde || Chinese
// Hot Star Large Fried Chicken || Chinese
// Meet Noodle || Chinese
// Friends Restaurant || Chinese
// gongfu bao || Chinese
// Dumpling Bowl || Chinese

// 1383 Club Karaoke Bar || Bar

// Kirimaki Sushi || Japanese
// Kinton Ramen || Japanese

// Bun Bun Bakeshop || Bakery

// 10% drinks
// 10% off OR free item with $20+ purchase
// 10% off on $30+ purchase
// 10% off
// 20% off
// 10% off + karaoke deals
// 15% off
// 10% off OR free gyoza/takoyaki $40+
// 10% off OR free fries $40+
// 10% off
// 10% off
// 5% credit, 15% cash
// 10% off
// 10% off
// free item on $20+
// 10% off
// 10% credit, 15% cash
// 10% off
// 10% off
// 10% off
// 10% off
