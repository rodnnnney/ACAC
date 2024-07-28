import 'package:ACAC/common/widgets/common/home_page_card.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/dbb_sort.dart';
import 'package:flutter/material.dart';

final List<HomeCard> sortByFoodType = [
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/noodle.png',
    text: 'Noodle-Based',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: 'Noodle',
          ),
        ),
      );
    },
  ),
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/boba.png',
    text: 'Bubble Tea',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: 'Bubble Tea',
          ),
        ),
      );
    },
  ),
  HomeCard(
    displayIMG:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hand_drawn/veg.png',
    text: 'Vegan',
    routeName: (BuildContext context, String cuisineType) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DbbSort(
            cuisineType: '',
          ),
        ),
      );
    },
  ),
];
