import 'package:ACAC/presentation_layer/widgets/home_page_card.dart';
import 'package:ACAC/presentation_layer/widgets/multi_card_view.dart';
import 'package:flutter/cupertino.dart';

final List<HomeCard> sortByCountry = [
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/chinese2.png',
    text: 'Chinese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Chinese',
      );
    },
  ),
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/image.png',
    text: 'Vietnamese',
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
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/japanese1.png',
    text: 'Japanese',
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
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/korean1.png',
    text: 'Korean',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.pushNamed(
        context,
        CardViewerHomePage.id,
        arguments: 'Korean',
      );
    },
  ),
];
