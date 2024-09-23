import 'dart:async';

import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_list_controller.g.dart';

@riverpod
class UserListController extends _$UserListController {
  Future<List<User>> fetchUsers() async {
    final userRepository = ref.read(userRepositoryProvider);
    final user = await userRepository.getUsers();
    return user;
  }

  @override
  FutureOr<List<User>> build() async {
    return fetchUsers();
  }

  Future<User> fetchUser(String userId) async {
    final userRepository = ref.watch(userRepositoryProvider);
    return userRepository.getUser(userId);
  }

  Future<void> addUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final user = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        favouriteRestaurants: []);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.addUser(user);
      return fetchUsers();
    });
  }

  Future<void> removeUser(User user) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final itemsRepository = ref.read(userRepositoryProvider);
      await itemsRepository.deleteUser(user);

      return fetchUsers();
    });
  }

  Future<void> addToFavourite(String rest) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final itemsRepository = ref.read(userRepositoryProvider);

      // Fetch current user ID
      var userId = (await Amplify.Auth.getCurrentUser()).userId;

      // Fetch the current user object
      User currentUser = await itemsRepository.getUser(userId);

      // Check if the restaurant is already in the favorites
      if (!currentUser.favouriteRestaurants.contains(rest)) {
        // Create updated list of favorite restaurants
        List<String> updatedFavorites = [
          ...currentUser.favouriteRestaurants,
          rest
        ];

        // Create updated user object
        User updatedUser =
            currentUser.copyWith(favouriteRestaurants: updatedFavorites);

        // Print updated user (for debugging)
        safePrint(updatedUser);

        // Update the user in the repository
        await itemsRepository.updateUser(updatedUser);
      }

      // Optionally refresh or return something (ensure fetchUsers() is defined)
      return fetchUsers();
    });
  }

  Future<void> addToFavourite1(String restName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final itemsRepository = ref.read(userRepositoryProvider);
      var authUser = await Amplify.Auth.getCurrentUser();
      User currentUser = await itemsRepository.getUser(authUser.userId);

      bool isAlreadyFavorite =
          currentUser.favouriteRestaurants.any((r) => r == restName) ?? false;

      if (!isAlreadyFavorite) {
        // Create a new list with the existing favorites and the new restaurant
        List<String> updatedFavorites = [
          ...currentUser.favouriteRestaurants,
          restName
        ];

        // Use copyWith to create an updated user with the new favorites list
        User updatedUser =
            currentUser.copyWith(favouriteRestaurants: updatedFavorites);

        // Update the user in the repository
        await itemsRepository.updateUser(updatedUser);

        safePrint(
            "User favorites updated. New count: ${updatedUser.favouriteRestaurants}");
      } else {
        safePrint("Restaurant ${restName} is already a favorite");
      }

      return fetchUsers();
    });
  }

  Future<void> removeFromFavourite(String restName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final itemsRepository = ref.read(userRepositoryProvider);
      var userID = await Amplify.Auth.getCurrentUser();
      User currentUser = await itemsRepository.getUser(userID.userId);

      // Create a new list without the restaurant to be removed
      List<String> updatedFavorites =
          currentUser.favouriteRestaurants.where((r) => r != restName).toList();

      User updatedUser =
          currentUser.copyWith(favouriteRestaurants: updatedFavorites);
      safePrint(updatedUser);
      await itemsRepository.updateUser(updatedUser);

      return fetchUsers();
    });
  }
}
