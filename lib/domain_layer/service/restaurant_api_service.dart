import 'package:acacmobile/models/Restaurant.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final restaurantAPIServiceProvider = Provider<RestaurantAPIService>((ref) {
  final service = RestaurantAPIService();
  return service;
});

class RestaurantAPIService {
  RestaurantAPIService();

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final request = ModelQueries.list(Restaurant.classType);
      final response = await Amplify.API.query(request: request).response;

      final spaces = response.data?.items;
      if (spaces == null) {
        safePrint('getSpaces errors: ${response.errors}');
        return const [];
      }

      return spaces.map((e) => e as Restaurant).toList();
    } on Exception catch (error) {
      safePrint('getSpaces failed: $error');

      return const [];
    }
  }

  Future<void> deleteRestaurant(Restaurant restaurant) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.delete(restaurant),
          )
          .response;
    } on Exception catch (error) {
      safePrint('deleteTrip failed: $error');
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      final request = ModelMutations.create(restaurant);
      final response = await Amplify.API.mutate(request: request).response;

      final createRestaurantPing = response.data;
      if (createRestaurantPing == null) {
        safePrint('AddRestaurantPing errors: ${response.errors}');
        return;
      }
    } on Exception catch (error) {
      safePrint('AddRestaurantPing failed: $error');
    }
  }
}
