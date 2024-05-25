import 'package:flutter/material.dart';
import 'package:googlemaptest/domain_layer/use_cases/Login.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'Sign_Up.dart';

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_screen';
  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShadCard(
          title: Text('Welcome to my app'),
          content: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ShadButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  text: const Text('Login'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.login,
                      size: 16,
                    ),
                  ),
                ),
                ShadButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  text: const Text('Create an account'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.person,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
