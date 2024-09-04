import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/models/User.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  Future<User> _fetchUser(String userId) async {
    final userRepository = ref.read(userRepositoryProvider);
    return userRepository.getUser(userId);
  }

  @override
  FutureOr<User> build(String userId) async {
    return _fetchUser(userId);
  }
}
