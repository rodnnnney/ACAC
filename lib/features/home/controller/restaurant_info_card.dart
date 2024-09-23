import 'dart:async';

import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controller for operations related to RestaurantInfoCard
final restaurantInfoCardAPIServiceProvider =
    Provider<RestaurantInfoCardAPIService>((ref) {
  final service = RestaurantInfoCardAPIService();
  return service;
});

class RestaurantInfoCardAPIService {
  RestaurantInfoCardAPIService();

  Future<List<RestaurantInfoCard>> getRestaurants() async {
    try {
      final request = ModelQueries.list(RestaurantInfoCard.classType,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API.query(request: request).response;
      final restaurantInfoCard = response.data?.items;
      if (restaurantInfoCard == null) {
        safePrint('getTrips errors: ${response.errors}');
        return const [];
      }

      return restaurantInfoCard.map((e) => e as RestaurantInfoCard).toList();
    } on Exception catch (error) {
      safePrint('getTrips failed: $error');

      return const [];
    }
  }

  Future<void> addRestaurantInfoCard(RestaurantInfoCard restaurant) async {
    try {
      final request = ModelMutations.create(restaurant,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API
          .mutate(
            request: request,
          )
          .response;

      final createdTrip = response.data;
      if (createdTrip == null) {
        safePrint('addTrip errors: ${response.errors}');
        return;
      }
    } on Exception catch (error) {
      safePrint('addTrip failed: $error');
    }
  }

  Future<void> deleteRestaurantInfoCard(RestaurantInfoCard restaurant) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.delete(restaurant,
                authorizationMode: APIAuthorizationType.apiKey),
          )
          .response;
    } on Exception catch (error) {
      safePrint('deleteTrip failed: $error');
    }
  }

  Future<RestaurantInfoCard> getRestaurantInfoCard(String restaurantID) async {
    try {
      final request = ModelQueries.get(
        RestaurantInfoCard.classType,
        RestaurantInfoCardModelIdentifier(id: restaurantID),
      );
      final response = await Amplify.API.query(request: request).response;

      final trip = response.data!;
      return trip;
    } on Exception catch (error) {
      safePrint('getTrip failed: $error');
      rethrow;
    }
  }

  Future<void> updateRestaurantVisit(RestaurantInfoCard restaurant) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.update(restaurant,
                authorizationMode: APIAuthorizationType.apiKey),
          )
          .response;
    } on Exception catch (error) {
      safePrint('updateItem failed: $error');
    }
  }
}
