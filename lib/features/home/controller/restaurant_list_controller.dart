import 'dart:async';

import 'package:ACAC/features/home/data/restaurant_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
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

  Future<void> addRestaurant({
    required String userFirstName,
    required String userLastName,
    required String restaurantName,
    required String email,
  }) async {
    final restaurant = Restaurant(
      firstName: userFirstName,
      lastName: userLastName,
      restaurant: restaurantName,
      email: email,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final restaurantRepository = ref.read(restaurantRepositoryProvider);
      await restaurantRepository.add(restaurant);
      return _fetchRestaurant();
    });
  }
}
