import 'dart:async';

import 'package:ACAC/domain_layer/data/restaurant_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_list_controller.g.dart';

@riverpod
class RestaurantListController extends _$RestaurantListController {
  Future<List<Restaurant>> _fetchRestaurant() async {
    final restaurantRepository = ref.read(restaurantRepositoryProvider);
    final restaurant = await restaurantRepository.getRestaurants();
    return restaurant;
  }

  @override
  FutureOr<List<Restaurant>> build() async {
    return _fetchRestaurant();
  }

  Future<void> addRestaurant(
      {required String user,
      required String restaurantName,
      required String email,
      required String date}) async {
    final restaurant = Restaurant(
      user: user,
      restaurant: restaurantName,
      email: email,
      date: TemporalDateTime(
        DateTime.parse(date),
      ),
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final restaurantRepository = ref.read(restaurantRepositoryProvider);
      await restaurantRepository.add(restaurant);
      return _fetchRestaurant();
    });
  }
}
