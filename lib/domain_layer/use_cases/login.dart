import 'package:flutter/material.dart';
import 'package:googlemaptest/domain_layer/use_cases/sign_up.dart';
import 'package:googlemaptest/presentation_layer/pages/home.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../presentation_layer/state_management/provider/user_info_provider.dart';
import 'welcome.dart';

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

const kInputDecoration = InputDecoration(
  hintText: 'Enter your email',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class LoginScreen extends StatefulWidget {
  static const String id = 'Login_screen';
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool showSpinner = false;
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserInfo user = Provider.of<UserInfo>(context);
    return Scaffold(
      body: Center(
        child: ShadCard(
          title: Text('Welcome Back'),
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email'),
                ShadInput(
                  onChanged: (email) {
                    user.setEmail = email;
                  },
                  placeholder: const Text('Enter your email'),
                ),
                const Text('Password'),
                ShadInput(
                  onChanged: (pass) {
                    user.setPassword = pass;
                  },
                  placeholder: Text('Enter your password'),
                  obscureText: true,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  child: Text('Don\'t have an account? Sign up now'),
                ),
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShadButton.outline(
                text: const Text('Cancel'),
                onPressed: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
              ),
              ShadButton(
                text: const Text('Login'),
                onPressed: () async {
                  try {
                    final data = await user.signIn(user.email, user.password);

                    if (user.authData != '') {
                      (Navigator.pushNamed(context, HomePage.id)
                          .then((value) => user.signedInWithAccount()));
                    } else {
                      ShadToaster.of(context).show(
                        const ShadToast.destructive(
                          title: Text('Uh oh, somethings not right'),
                          description: Text('Invalid email or password'),
                        ),
                      );
                    }
                  } catch (e) {
                    ShadToaster.of(context).show(
                      const ShadToast.destructive(
                        title: Text('Uh oh, somethings not right'),
                        description: Text('Invalid email or password'),
                      ),
                    );
                  }
                },
              ),
              ShadButton(
                text: Text('Google'),
                onPressed: () async {
                  await user.O2AuthSignUp().then((value) =>
                      Navigator.pushNamed(context, HomePage.id)
                          .then((value) => user.signedInWithO2Auth()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}