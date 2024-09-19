import 'dart:async';

import 'package:ACAC/features/home/data/restaurantInfoCard_repository.dart';
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

  Future<void> updateRestInfo(RestaurantInfoCard restaurant) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      RestaurantInfoCard updatedRest =
          restaurant.copyWith(timesVisited: restaurant.timesVisited + 1);
      final restaurantRepository =
          ref.read(restaurantInfoCardRepositoryProvider);
      await restaurantRepository.update(updatedRest);

      return _fetchRestaurant();
    });
  }

  // Delete Restaurant Card method
  Future<void> deleteRestaurantInfo(RestaurantInfoCard restaurant) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final restaurantRepository =
          ref.read(restaurantInfoCardRepositoryProvider);
      await restaurantRepository.delete(restaurant);
      return _fetchRestaurant();
    });
  }

  Future<void> addRestaurantInfo({
    required String restaurantName,
    required String restaurantAddress,
    required String restaurantImageSrc,
    required String restaurantImageLogo,
    required List<String> restaurantAttributes,
    required LatLong latLng,
    required Time restaurantHours,
    required double restaurantRatings,
    required int numRestaurantReviews,
    required String restaurantDiscountPercentage,
    required List<String> restaurantTopItemName,
    required List<String> restaurantTopItemImage,
  }) async {
    final restaurantDetails = RestaurantInfoCard(
      restaurantName: restaurantName,
      location: latLng,
      address: restaurantAddress,
      imageSrc: restaurantImageSrc,
      imageLogo: restaurantImageLogo,
      scannerDataMatch: '',
      hours: restaurantHours,
      rating: restaurantRatings,
      cuisineType: restaurantAttributes,
      reviewNum: numRestaurantReviews,
      discounts: [],
      discountPercent: restaurantDiscountPercentage,
      phoneNumber: '',
      gMapsLink: '',
      websiteLink: '',
      topRatedItemsImgSrc: restaurantTopItemImage,
      topRatedItemsName: restaurantTopItemName,
      timesVisited: 0,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final restaurantRepository =
          ref.read(restaurantInfoCardRepositoryProvider);
      await restaurantRepository.add(restaurantDetails);
      return _fetchRestaurant();
    });
  }
}
