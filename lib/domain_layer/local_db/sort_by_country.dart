import 'package:flutter/cupertino.dart';
import 'package:googlemaptest/presentation_layer/widgets/home_page_card.dart';
import 'package:googlemaptest/presentation_layer/widgets/multi_card_view.dart';

final List<HomeCard> sortByCountry = [
  HomeCard(
    displayIMG: 'images/chinese2.png',
    text: 'chinese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Chinese',
      );
    },
  ),
  HomeCard(
    displayIMG: 'images/viet.webp',
    text: 'vietnamese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Vietnamese',
      );
    },
  ),
  HomeCard(
    displayIMG: 'images/japan.avif',
    text: 'japanese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Japanese',
      );
    },
  ),
  HomeCard(
    displayIMG: 'images/korean.jpeg',
    text: 'korean',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Korean',
      );
    },
  ),
];
