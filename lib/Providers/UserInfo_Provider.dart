import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

class UserInfo extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  dynamic _authData = '';
  int selected = 0;
  bool signInAcc = false;
  bool signInAuth2 = false;

  void signedInWithAccount() {
    signInAcc = true;
    notifyListeners();
  }

  void signedInWithO2Auth() {
    signInAuth2 = true;
    notifyListeners();
  }

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

  void set setO2AuthData(dynamic authData) {
    authData = authData;
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
        "name": name,
      };
      final record = await pb.collection('users').create(body: body);
      setAuthData = record;
      //pb.authStore.isValid;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void userId() {
    RecordModel jsonString = authData;
    Map<String, dynamic> user = jsonDecode(jsonString as String);
    String userId = user['id'];
    print('User ID: $userId');
  }

  String getName(dynamic data) {
    Map<String, dynamic> jsonData = jsonDecode(data);
    String name = jsonData['record']['name'];

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

  Future<void> o2AthSendFeedBack(
      String feedback, String email, dynamic id) async {
    final body = <String, dynamic>{
      "feedback": feedback,
      "field": id,
      'email': email,
    };
    final record = await pb.collection('feedback').create(body: body);
    print(record);
  }

  void setNum(int hover) {
    selected = hover;
    notifyListeners();
  }

  Future<void> signOut() async {
    _authData = '';
    pb.authStore.clear();
  }

  String getUserNameAuthData() {
    // var prettyString = JsonEncoder.withIndent('  ').convert(authData);
    // print(prettyString);
    Map<String, dynamic> userData = jsonDecode(authData.toString());
    String nameFromO2Auth = userData['record']['name'];
    return nameFromO2Auth;
  }

  String getUserEmailAuthData() {
    var prettyString = JsonEncoder.withIndent('  ').convert(authData);
    print(prettyString);
    Map<String, dynamic> userData = jsonDecode(authData.toString());
    String emailFromO2Auth = userData['record']['email'];
    return emailFromO2Auth;
  }

  String getO2AuthID() {
    Map<String, dynamic> userData = jsonDecode(authData.toString());
    String idFromO2Auth = userData['record']['id'];
    return idFromO2Auth;
  }

  Future<void> O2AuthSignUp() async {
    final Uri url = Uri.parse(
        'https://acac2-thrumming-wind-3122.fly.dev/api/oauth2-redirect');
    final authData = await pb.collection('users').authWithOAuth2(
      'google',
      (url) async {
        await launchUrl(url);
      },
    );

    setAuthData = authData;
    notifyListeners();
  }

  void getInfo() {
    print(pb.authStore.isValid);
  }
}
