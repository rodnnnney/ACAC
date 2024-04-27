import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googlemaptest/Login/Login.dart';
import 'package:googlemaptest/Login/Welcome.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
                  onSubmitted: (name) {
                    user.setName = name;
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
                    user.signUp(user.name, user.email, user.password);
                    if (user.password.length < 7) {
                      ShadToaster.of(context).show(
                        const ShadToast.destructive(
                          title:
                              Text('Uh oh, let\'s make that password stronger'),
                          description: Text(
                              'Ensure the password is more than 8 characters'),
                        ),
                      );
                    } else if (user.email.contains('@') == false) {
                      ShadToaster.of(context).show(
                        const ShadToast.destructive(
                          title: Text('Uh oh, somethings not right'),
                          description: Text('Please enter a valid email'),
                        ),
                      );
                    } else {
                      Navigator.pushNamed(context, MapScreen.id);
                    }
                  } catch (e) {
                    print(e);
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
