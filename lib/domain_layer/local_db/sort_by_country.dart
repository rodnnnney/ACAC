import 'package:ACAC/presentation_layer/widgets/home_page_card.dart';
import 'package:ACAC/presentation_layer/widgets/multi_card_view.dart';
import 'package:flutter/cupertino.dart';

final List<HomeCard> sortByCountry = [
  HomeCard(
    displayIMG: 'https://acacpicturesgenerealbucket.s3.amazonaws'
        '.com/ai_gen/openart-image_G585saq6_1719106933802_raw.png',
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
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/ai_gen/openart-image_W8ZOTKz__1719106517856_raw.png',
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
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/ai_gen/openart-image_8MOLZGVs_1719107165925_raw.png',
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
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/ai_gen/openart-image_Dn-YfkBF_1719107094617_raw.png',
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
