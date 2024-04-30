import 'package:flutter/material.dart';
import 'package:googlemaptest/Login/Login.dart';
import 'package:googlemaptest/Pages/Home.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Pages/Maps.dart';
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
  final Uri _url = Uri.parse('http://127.0.0.1:8090/api/oauth2-redirect');
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    UserInfo userInfo = Provider.of<UserInfo>(context);
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
                    userInfo.setName = name;
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
                    userInfo.setEmail = email;
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
                    userInfo.setPassword = pass;
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.6,
                    ),
                    child: const ShadProgress(),
                  );
                  try {
                    if (userInfo.password.length < 7) {
                      ShadToaster.of(context).show(
                        const ShadToast.destructive(
                          title:
                              Text('Uh oh, let\'s make that password stronger'),
                          description: Text(
                              'Ensure the password is more than 8 characters'),
                        ),
                      );
                    } else if (userInfo.email.contains('@') == false) {
                      ShadToaster.of(context).show(
                        const ShadToast.destructive(
                          title: Text('Uh oh, somethings not right'),
                          description: Text('Please enter a valid email'),
                        ),
                      );
                    } else if (userInfo.name.isEmpty &&
                        userInfo.email.isEmpty &&
                        userInfo.password.isEmpty) {
                      ShadToaster.of(context).show(
                        const ShadToast.destructive(
                          title: Text('Uh oh, somethings not right'),
                          description: Text('Please enter a valid email'),
                        ),
                      );
                    } else {
                      userInfo
                          .signUp(
                              userInfo.name, userInfo.email, userInfo.password)
                          .then((value) =>
                              Navigator.pushNamed(context, MapScreen.id));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              ShadButton(
                text: Text('Google'),
                onPressed: () async {
                  final authData = await pb.collection('users').authWithOAuth2(
                    'google',
                    (_url) async {
                      await launchUrl(_url);
                    },
                  );
                  Navigator.pushNamed(context, HomePage.id);
                  userInfo.setO2AuthData = authData;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
