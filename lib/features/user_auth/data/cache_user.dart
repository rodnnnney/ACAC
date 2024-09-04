import 'package:ACAC/features/user_auth/data/user_controller.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_user.g.dart';

@Riverpod(keepAlive: true)
Future<User> currentUser(CurrentUserRef ref) async {
  final authUser = await Amplify.Auth.getCurrentUser();
  return await ref.read(userControllerProvider(authUser.userId).future);
}
