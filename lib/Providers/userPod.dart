import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

class UserInfo {
  final String email;

  UserInfo({required this.email});

  Future<void> sendFeedBack(String feedback, String email) async {
    final body = <String, dynamic>{
      "field": pb.authStore.model.id,
      "feedback": feedback,
      'email': email,
    };
    final record = await pb.collection('feedback').create(body: body);
    print(record);
  }

  Future<void> signOut() async {
    pb.authStore.clear();
  }
}

// Provider for UserInfoNotifier
// final userInfoProvider = StateNotifierProvider<UserInfo>((ref) {
//   return UserInfo(email: '');
// });
