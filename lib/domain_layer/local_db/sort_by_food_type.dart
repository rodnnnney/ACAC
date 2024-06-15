import 'package:ACAC/presentation_layer/widgets/home_page_card.dart';
import 'package:ACAC/presentation_layer/widgets/multi_card_view.dart';
import 'package:flutter/cupertino.dart';

final List<HomeCard> sortByFoodType = [
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/japan.avif',
    text: 'Ramen',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Noodle',
      );
    },
  ),
  HomeCard(
    displayIMG: 'https://acacpicturesgenerealbucket.s3.amazonaws.com/boba.png',
    text: 'Bubble Tea',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Bubble Tea',
      );
    },
  ),
];
