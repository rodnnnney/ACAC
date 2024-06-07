import 'package:acacmobile/presentation_layer/widgets/home_page_card.dart';
import 'package:acacmobile/presentation_layer/widgets/multi_card_view.dart';
import 'package:flutter/cupertino.dart';

final List<HomeCard> sortByCountry = [
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/chinese2.png',
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
    displayIMG: 'https://acacpicturesgenerealbucket.s3.amazonaws.com/viet.webp',
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
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/japan.avif',
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
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/korean.jpeg',
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
