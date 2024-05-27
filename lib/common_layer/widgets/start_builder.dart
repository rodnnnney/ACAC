import 'package:flutter/material.dart';

double starSize = 19;

Widget buildStarRating(double rating) {
  List<Widget> stars = [];
  int fullStars = rating.floor();
  double remainder = rating - fullStars;
  if (remainder >= 0.75) {
    fullStars += 1;
    remainder = 0;
  } else if (remainder >= 0.25) {
    remainder = 0.5;
  } else {
    remainder = 0;
  }
  for (int i = 0; i < fullStars; i++) {
    stars.add(
      Icon(
        Icons.star,
        color: const Color(0xffF4B932),
        size: starSize,
      ),
    );
  }
  if (remainder == 0.5) {
    stars.add(
      Icon(
        Icons.star_half,
        color: const Color(0xffF4B932),
        size: starSize,
      ),
    );
  }
  while (stars.length < 5) {
    stars.add(
      Icon(
        Icons.star_border,
        color: const Color(0xffF4B932),
        size: starSize,
      ),
    );
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: stars,
  );
}
