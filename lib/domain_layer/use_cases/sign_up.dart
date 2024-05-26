import 'package:flutter/material.dart';
import 'package:googlemaptest/domain_layer/use_cases/login.dart';
import 'package:googlemaptest/presentation_layer/pages/home.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../presentation_layer/state_management/provider/user_info_provider.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'Registration_screen';

  RegistrationScreen({super.key});

  static TextStyle styling = const TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);
  final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');
  String uName = '';
  String uEmail = '';
  String uPassword = '';

  @override
  Widget build(BuildContext context) {
    UserInfo userInfo = Provider.of<UserInfo>(context);
    //final theme = ShadTheme.of(context);
    return Scaffold(
      body: Center(
        child: ShadCard(
          title: const Text('Create Account'),
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
                    uName = name;
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
                    uEmail = email;
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
                    uPassword = pass;
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
                onPressed: () async {
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
                    } else if (await userInfo.emailExists(userInfo.email)) {
                      ShadToaster.of(context).show(
                        ShadToast.destructive(
                          title: const Text('That email is taken'),
                          description: const Text('Navigate to sign in?'),
                          action: ShadButton.outline(
                              text: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, LoginScreen.id);
                                ShadToaster.of(context).hide();
                                userInfo.setEmail = '';
                                userInfo.setPassword = '';
                                userInfo.setName = '';
                              }),
                        ),
                      );
                    } else {
                      print(await userInfo.emailExists(userInfo.email));
                      print(userInfo.email);
                      userInfo.signedInWithAccount();
                      userInfo.signUp(uName, uEmail, uPassword).then(
                          (value) => Navigator.pushNamed(context, HomePage.id));
                      userInfo.sendUserAuthMail(userInfo.email);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // ShadButton(
              //   text: Text('Google'),
              //   onPressed: () async {
              //     //launchUrl('www.google.com' as Uri);
              //
              //     try {
              //       // final Uri url = Uri.parse(
              //       //     'https://acac2-thrumming-wind-3122.fly.dev/api/oauth2-redirect');
              //       // final authData =
              //       //     await pb.collection('users').authWithOAuth2(
              //       //   'google',
              //       //   (url) async {
              //       //     await launchUrl(url);
              //       //   },
              //       // );
              //       await userInfo.O2AuthSignUp().then((value) =>
              //           Navigator.pushNamed(context, HomePage.id)
              //               .then((value) => userInfo.signedInWithO2Auth()));
              //     } catch (e) {
              //       ShadToaster.of(context).show(
              //         ShadToast.destructive(
              //           title: const Text('Uh oh, somethings not right'),
              //           description: Text('Error: $e'),
              //         ),
              //       );
              //     }
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
