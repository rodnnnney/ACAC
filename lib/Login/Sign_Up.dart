import 'package:flutter/material.dart';
import 'package:googlemaptest/Login/Login.dart';
import 'package:googlemaptest/Pages/Home.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../Providers/UserInfo_Provider.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'Registration_screen';
  RegistrationScreen({super.key});

  static TextStyle styling = const TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);
  final pb = PocketBase('http://127.0.0.1:8090');
  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    UserInfo user = Provider.of(context);
    final theme = ShadTheme.of(context);
    return Scaffold(
      body: Center(
        child: ShadCard(
          title: Text('Create Account', style: theme.textTheme.h4),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: styling,
                ),
                ShadInput(
                  placeholder: const Text('Enter your first name'),
                  onChanged: (name) {
                    user.setName = name;
                    print(user.name);
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  'Email',
                  style: styling,
                ),
                ShadInput(
                  placeholder: const Text('Enter an email'),
                  onChanged: (email) {
                    user.setEmail = email;
                    print(user.email);
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  'Password',
                  style: styling,
                ),
                ShadInput(
                  placeholder: const Text('Enter your password'),
                  obscureText: true,
                  onChanged: (pass) {
                    user.setPassword = pass;
                    print(user.password);
                  },
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
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              ShadButton(
                text: const Text('Create Account'),
                onPressed: () {
                  if (user.name.isEmpty ||
                      user.email.isEmpty ||
                      user.password.isEmpty) {
                    ShadToaster.of(context).show(
                      const ShadToast.destructive(
                        title: Text('Uh oh, somethings not right'),
                        description:
                            Text('Make sure all the fields are filled out'),
                      ),
                    );
                  } else if (!user.email.contains('@')) {
                    ShadToaster.of(context).show(
                      const ShadToast.destructive(
                        title: Text('Uh oh, somethings not right'),
                        description:
                            Text('Make sure you entered a valid email'),
                      ),
                    );
                  } else if (user.password.length < 7) {
                    ShadToaster.of(context).show(
                      const ShadToast.destructive(
                        title: Text('Lets make that password stronger'),
                        description:
                            Text('Make sure it is at least 8 characters'),
                      ),
                    );
                  } else {
                    try {
                      user.signUp(user.name, user.email, password).then(
                          (value) => Navigator.pushNamed(context, HomePage.id));
                    } catch (e) {
                      ShadToaster.of(context).show(
                        ShadToast.destructive(
                          title: const Text('Uh oh, somethings not right'),
                          description: Text('Error: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// try {
// user.signUp(user.name, user.email, user.password);
// if (user.password.length < 7) {
// ShadToaster.of(context).show(
// const ShadToast.destructive(
// title:
// Text('Uh oh, let\'s make that password stronger'),
// description: Text(
// 'Ensure the password is more than 8 characters'),
// ),
// );
// } else if (user.email.contains('@') == false) {
// ShadToaster.of(context).show(
// const ShadToast.destructive(
// title: Text('Uh oh, somethings not right'),
// description: Text('Please enter a valid email'),
// ),
// );
// } else {
// Navigator.pushNamed(context, MapScreen.id);
// }
// } catch (e) {
// print(e);
// }
