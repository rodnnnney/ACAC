import 'package:flutter/cupertino.dart';
import 'package:googlemaptest/presentation_layer/widgets/home_page_card.dart';
import 'package:googlemaptest/presentation_layer/widgets/multi_card_view.dart';

final List<HomeCard> sortByFoodType = [
  HomeCard(
    displayIMG: 'images/japan.avif',
    text: 'Ramen',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Ramen',
      );
    },
  ),
  HomeCard(
    displayIMG: 'images/korean.jpeg',
    text: 'Bubble Tea',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Bubble Tea',
      );
    },
  ),
  HomeCard(
    displayIMG: 'images/chinese2.png',
    text: 'Noodles',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Noodle',
      );
    },
  ),
  HomeCard(
    displayIMG: 'images/viet.webp',
    text: 'Pho',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Pho',
      );
    },
  ),
];
