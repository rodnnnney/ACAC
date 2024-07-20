import 'package:ACAC/common_layer/widgets/common/home_page_card.dart';
import 'package:ACAC/presentation_layer/widgets/dbb_widgets/dbb_sort.dart';
import 'package:flutter/material.dart';

final List<HomeCard> sortByCountry = [
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/chinese2.png',
    text: 'Chinese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: 'Chinese',
          ),
        ),
      );
    },
  ),
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/image.png',
    text: 'Vietnamese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: 'Vietnamese',
          ),
        ),
      );
    },
  ),
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/japanese1.png',
    text: 'Japanese',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: 'Japanese',
          ),
        ),
      );
    },
  ),
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/korean1.png',
    text: 'Korean',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: 'Korean',
          ),
        ),
      );
    },
  ),
];
