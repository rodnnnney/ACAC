import 'dart:async';

import 'package:ACAC/domain_layer/data/restaurantInfoCard_repository.dart';
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
    RestaurantInfoCard updatedRest =
        restaurant.copyWith(timesVisited: restaurant.timesVisited + 1);
    final restaurantRepository = ref.read(restaurantInfoCardRepositoryProvider);
    await restaurantRepository.update(updatedRest);
  }

// Future<void> addRestaurantInfo({
//   required String userFirstName,
//   required String userLastName,
//   required String restaurantName,
//   required String email,
//   required String x,
//   required String y,
//   required double rating,
//   required int reviewNum,
// }) async {
//   final restaurantDetails = RestaurantInfoCard(
//       restaurantName: '',
//       location: LatLong(latitude: x, longitude: y),
//       address: '',
//       imageSrc: '',
//       imageLogo: '',
//       scannerDataMatch: '',
//       hours: Time(
//         monday: StartStop(start: '', stop: ''),
//         tuesday: StartStop(start: '', stop: ''),
//         wednesday: StartStop(start: '', stop: ''),
//         thursday: StartStop(start: '', stop: ''),
//         friday: StartStop(start: '', stop: ''),
//         saturday: StartStop(start: '', stop: ''),
//         sunday: StartStop(start: '', stop: ''),
//       ),
//       rating: rating,
//       cuisineType: [],
//       reviewNum: reviewNum,
//       discounts: [],
//       discountPercent: '',
//       phoneNumber: '',
//       gMapsLink: '',
//       websiteLink: '',
//       topRatedItemsImgSrc: [],
//       topRatedItemsName: [],
//       timesVisited: 0);
//
//   state = const AsyncValue.loading();
//
//   state = await AsyncValue.guard(() async {
//     final restaurantRepository =
//         ref.read(restaurantInfoCardRepositoryProvider);
//     await restaurantRepository.add(restaurantDetails);
//     return fetchRestaurant();
//   });
// }
}
