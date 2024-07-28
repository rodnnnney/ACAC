import 'package:ACAC/features/home/service/user_api_service.dart';
import 'package:ACAC/models/User.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userAPIService = ref.read(userAPIServiceProvider);
  return UserRepository(userAPIService);
});

class UserRepository {
  UserRepository(this.userAPIService);

  final UserAPIService userAPIService;

  Future<List<User>> getUsers() {
    return userAPIService.getUsers();
  }

  Future<void> addUser(User user) async {
    return userAPIService.addUser(user);
  }

  Future<User> getUser(String userId) async {
    return userAPIService.getUser(userId);
  }

  Future<void> deleteUser(User deleteUser) async {
    return userAPIService.deleteUser(deleteUser);
  }

  Future<void> updateUser(User updateUser) async {
    return userAPIService.updateUser(updateUser);
  }
}
