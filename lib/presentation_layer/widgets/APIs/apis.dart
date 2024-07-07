import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Apis {
  Future<void> cognito2DynamoDBB(
      String firstName, String lastName, String email, String id) async {
    final url =
        Uri.parse('https://x1ddj5dgxl.execute-api.us-east-1.amazonaws.com/Dev');
    var uuid = const Uuid();
    DateTime now = DateTime.now().toUtc();
    String formattedDateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(now);

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'id': id,
      'createdAt': formattedDateTime.toString(),
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'owner': uuid.v4().toString(),
      'updatedAt': formattedDateTime.toString(),
      '__typename': 'User',
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      debugPrint(response.body);
    } else {
      debugPrint('Request failed with status: ${response.statusCode}');
      debugPrint(response.body);
    }
  }
}
