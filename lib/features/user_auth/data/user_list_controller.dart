import 'dart:async';

import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
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
    final user = User(firstName: firstName, lastName: lastName, email: email);
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
}
