import 'dart:async';

import 'package:ACAC/domain_layer/data/restaurantInfoCard_repository.dart';
import 'package:ACAC/domain_layer/data/restaurant_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_info_card_list.g.dart';

@riverpod
class RestaurantInfoCardList extends _$RestaurantInfoCardList {
  Future<List<RestaurantInfoCard>> _fetchRestaurant() async {
    final restaurantRepository = ref.read(restaurantInfoCardRepositoryProvider);
    final restaurant = await restaurantRepository.getRestaurants();
    return restaurant;
  }

  @override
  FutureOr<List<RestaurantInfoCard>> build() async {
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
