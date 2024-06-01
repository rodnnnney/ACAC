import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  try {
    final result = await Amplify.Auth.fetchUserAttributes();
    Map<String, String> attributes = {};

    for (final attribute in result) {
      if (attribute.userAttributeKey.toString() == 'email' ||
          attribute.userAttributeKey.toString() == 'name') {
        attributes[attribute.userAttributeKey.toString()] =
            attribute.value.toString();
      }
    }

    return attributes;
  } on AuthException catch (e) {
    safePrint('Error fetching user attributes: ${e.message}');
    throw Exception('Failed to fetch user attributes');
  }
});
