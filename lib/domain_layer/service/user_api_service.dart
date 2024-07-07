import 'package:ACAC/models/User.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userAPIServiceProvider = Provider<UserAPIService>((ref) {
  final service = UserAPIService();
  return service;
});

class UserAPIService {
  UserAPIService();

  Future<List<User>> getUsers() async {
    try {
      final request = ModelQueries.list(User.classType,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API.query(request: request).response;

      final spaces = response.data?.items;
      if (spaces == null) {
        safePrint('get User errors: ${response.errors}');
        return const [];
      }

      return spaces.map((e) => e as User).toList();
    } on Exception catch (error) {
      safePrint('getSpaces failed: $error');

      return const [];
    }
  }

  Future<User> getUser(String userId) async {
    try {
      final request = ModelQueries.get(
        User.classType,
        UserModelIdentifier(id: userId),
      );
      final response = await Amplify.API.query(request: request).response;

      return response.data!;
    } on Exception catch (error) {
      safePrint('getUser failed: $error');
      return User(
          firstName: "Deleted User",
          email: "Error fetching email",
          lastName: 'Delete User');
    }
  }

  // Future<Post> getPost(String postId) async {
  //   try {
  //     final request = ModelQueries.get(
  //       Post.classType,
  //       PostModelIdentifier(id: postId),
  //     );
  //     final response = await Amplify.API.query(request: request).response;
  //
  //     final post = response.data!;
  //     return post;
  //   } on Exception catch (error) {
  //     safePrint('getPost failed: $error');
  //     rethrow;
  //   }
  // }

  Future<void> deleteUser(User user) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.delete(user),
          )
          .response;
    } on Exception catch (error) {
      safePrint('Delete user failed: $error');
    }
  }

  Future<void> addUser(User user) async {
    try {
      final request = ModelMutations.create(user);
      final response = await Amplify.API.mutate(request: request).response;

      final createRestaurantPing = response.data;
      if (createRestaurantPing == null) {
        safePrint('Add user errors: ${response.errors}');
        return;
      }
    } on Exception catch (error) {
      safePrint('Add user failed: $error');
    }
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.update(updatedUser),
          )
          .response;
    } on Exception catch (error) {
      safePrint('Update user failed: $error');
    }
  }
}
