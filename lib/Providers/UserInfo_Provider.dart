import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:convert';

final pb = PocketBase('http://127.0.0.1:8090');

class UserInfo extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  dynamic _authData = '';
  int selected = 0;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  dynamic get authData => _authData;

  set setName(String name) {
    _name = name;
    notifyListeners();
  }

  set setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  set setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  set setAuthData(dynamic authData) {
    _authData = authData;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    final authData =
        await pb.collection('users').authWithPassword(email, password);
    setAuthData = authData;
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final body = <String, dynamic>{
        "email": email,
        "emailVisibility": true,
        "password": password,
        "passwordConfirm": password,
        "name": name
      };
      final record = await pb.collection('users').create(body: body);
      setAuthData = record;
      pb.authStore.isValid;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> read() async {
    final records = await pb.collection('users').getFullList(
          sort: '-username',
        );
    print(records);
  }

  String getName(dynamic data) {
    Map<String, dynamic> jsonData = jsonDecode(data);
    String name = jsonData['record']['name'];
    //print(name);
    return name;
  }

  Future<void> sendFeedBack(String feedback, String email) async {
    final body = <String, dynamic>{
      "field": pb.authStore.model.id,
      "feedback": feedback,
      'email': email,
    };
    final record = await pb.collection('feedback').create(body: body);
    print(record);
  }

  void setNum(int hover) {
    selected = hover;
    notifyListeners();
  }
}
