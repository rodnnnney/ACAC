import 'dart:convert';

import 'package:flutter/services.dart';

String questionFormat(String data) {
  return '''
  You are a smart and helpful food assistant. You want to try your best to 
  recommend the user a restaurant from the following list of restaurant/
  Suggest me a SINGLE restaurant with cuisine type of $data,
  ''';
}

Future<List<Map<String, dynamic>>> loadJsonData() async {
  final jsonString = await rootBundle.loadString('assets/restaurantData.json');
  final jsonData = json.decode(jsonString) as List<dynamic>;
  return jsonData.cast<Map<String, dynamic>>();
}

Future<List<Map<String, dynamic>>> getRestaurantData(
    String? cuisineType) async {
  final restaurantData = await loadJsonData();
  if (cuisineType == null) {
    return restaurantData;
  } else {
    return restaurantData.where((restaurant) {
      final cuisineTypes = List<String>.from(restaurant['cuisine_type']);
      return cuisineTypes.contains(cuisineType);
    }).toList();
  }
}

String initText = '''
Hey I am Owen, your personal food recommendation buddy! \n 
I have context of all the best ACAC restaurants so I would love to
recommend you your next meal! 😀''';

String answerFormat = '''
Structure the response like this:

Based on your request, I suggest:
--------------------------------
Restaurant: restaurant_name 🏠
Address: address_of_restaurant 📍
Rating: restaurant_rating ⭐️
Number of Reviews: review_num 🗣️
Average Cost/person: average_cost _per_person 💸
ACAC Discount: discount 🏷️
--------------------------------
Always say, is there anything else I can help with at the very end.
''';
