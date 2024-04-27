import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googlemaptest/Models+Data/Cards.dart';
import 'package:googlemaptest/Pages/multiCardView.dart';
import 'package:googlemaptest/Providers/UserInfo_Provider.dart';
import 'package:provider/provider.dart';
import '../GoogleMaps/WelcomeText.dart';
import '../GoogleMaps/appBar.dart';
import 'Account.dart';
import 'maps.dart';
import 'package:pocketbase/pocketbase.dart';

class HomePage extends StatelessWidget {
  static String id = 'home_screen';
  final pb = PocketBase('http://127.0.0.1:8090');

  String cutAndLowercase(String name) {
    int spaceIndex = name.indexOf(' '); // Find the index of the first space
    if (spaceIndex == -1) {
      return name
          .toLowerCase(); // If no space found, return the whole string in lowercase
    }
    return name
        .substring(0, spaceIndex)
        .toLowerCase(); // Cut off after the first space and convert to lowercase
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    UserInfo user = Provider.of<UserInfo>(context);
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
                Text(
                  user.name == ''
                      ? 'rodney'
                      : cutAndLowercase(
                          user.getName(
                            user.authData.toString(),
                          ),
                        ),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'featured',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Card(
                        elevation: 5,
                        child: Center(
                          child: Container(
                            height: screenHeight * 0.19,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'images/china.webp',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('category'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/tofu.webp',
                              text: 'chinese',
                              flag: '🇨🇳',
                              routeName: cardViewerHomePage.id,
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/viet.webp',
                              text: 'vietnamese',
                              flag: '🇻🇳',
                              routeName: null,
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/japan.avif',
                              text: 'japanese',
                              flag: '🇯🇵',
                              routeName: null,
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
                              routeName: null,
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/boba.jpeg',
                              text: 'bubble tea',
                              flag: '🧋',
                              routeName: null,
                            ),
                            HomeCard(
                              screenHeight: screenHeight,
                              displayIMG: 'images/club.webp',
                              text: 'bars',
                              flag: '🍷',
                              routeName: null,
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

class HomeCard extends StatelessWidget {
  HomeCard(
      {super.key,
      required this.screenHeight,
      required this.displayIMG,
      required this.text,
      required this.flag,
      required this.routeName});

  final double screenHeight;
  final String displayIMG;
  final String text;
  final String flag;
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, routeName!);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    displayIMG,
                    height: screenHeight * 0.15,
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  children: [
                    Text(text),
                    Text(flag),
                  ],
                ),
              ],
            ),
          ),
        ),
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
