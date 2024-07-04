import 'dart:convert';

import 'package:http/http.dart' as http;

class Apis {
  Future<void> cognito2DynamoDBB(String name, String email, String id) async {
    final url =
        Uri.parse('https://x1ddj5dgxl.execute-api.us-east-1.amazonaws.com/Dev');
    final headers = {
      'Content-Type': 'application/json',
    };
    DateTime now = DateTime.now();
    final body = json.encode({
      'id': id,
      'createdAt': now.toString(),
      'email': email,
      'firstName': name,
      'updatedAt': now.toString(),
      '__typename': 'User',
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Request successful');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }
}
