import 'dart:async';

import 'package:ACAC/domain_layer/data/user_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_list_controller.g.dart';

@riverpod
class UserListController extends _$UserListController {
  Future<List<User>> _fetchUser() async {
    final userRepository = ref.read(userRepositoryProvider);
    final restaurant = await userRepository.getUsers();
    return restaurant;
  }

  @override
  FutureOr<List<User>> build() async {
    return _fetchUser();
  }

  Future<void> addUser({
    required String firstName,
    required String email,
  }) async {
    final user = User(firstName: firstName, email: email);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.addUser(user);
      return _fetchUser();
    });
  }

  Future<void> removeUser(User user) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final itemsRepository = ref.read(userRepositoryProvider);
      await itemsRepository.deleteUser(user);

      return _fetchUser();
    });
  }
}
