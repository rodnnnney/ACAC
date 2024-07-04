import 'package:ACAC/common_layer/consts/globals.dart';
import 'package:ACAC/common_layer/widgets/loading.dart';
import 'package:ACAC/common_layer/widgets/response_pop_up.dart';
import 'package:ACAC/presentation_layer/widgets/APIs/apis.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirstTimeSignIn extends StatefulWidget {
  static String id = 'First_Time';

  FirstTimeSignIn({super.key});

  @override
  State<FirstTimeSignIn> createState() => _FirstTimeSignInState();
}

class _FirstTimeSignInState extends State<FirstTimeSignIn> {
  late TextEditingController newPassword;
  late TextEditingController newPassword2;
  late TextEditingController firstName;
  String email = '';
  bool obscureText = true;
  Loading loading = Loading();
  Apis apis = Apis();

  @override
  void initState() {
    newPassword = TextEditingController();
    newPassword2 = TextEditingController();
    firstName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newPassword.dispose();
    newPassword2.dispose();
    firstName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  "images/acac1.png",
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Text(
                        'What should we call you?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: firstName,
                        decoration: InputDecoration(
                          labelText: 'What\'s your name?',
                          labelStyle: const TextStyle(
                            color: Color(0xff2E2E2E),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Create your own password',
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  speed: const Duration(milliseconds: 250),
                                ),
                              ],
                              repeatForever: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: newPassword,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          labelText: 'Create New Password',
                          labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: newPassword2,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xff2E2E2E), width: 2),
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(
                                GlobalTheme.roundedRadius),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateColor.transparent,
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () {},
                        child: const Text('Back to Sign In'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          if (firstName.text.isEmpty) {
                            return const ResponsePopUp(
                              color: Colors.red,
                              icon: Icons.error_outline,
                              location: DelightSnackbarPosition.top,
                              response: 'Please enter a name!',
                            ).showToast(context);
                          } else if (newPassword.text == newPassword2.text) {
                            if (newPassword.text.length >= 8) {
                              loading.showLoadingDialog(context);
                              await Amplify.Auth.confirmSignIn(
                                confirmationValue: newPassword.text,
                              );
                              var data = await Amplify.Auth.getCurrentUser();

                              final result =
                                  await Amplify.Auth.fetchUserAttributes();
                              for (final element in result) {
                                if (element.userAttributeKey.toString() ==
                                    'email') {
                                  email = element.value.toString();
                                }
                              }
                              await apis.cognito2DynamoDBB(
                                  firstName.text, email, data.userId);
                              print('successfully added ${firstName.text}, '
                                  '${email}, ${data.userId}');

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              return const ResponsePopUp(
                                color: Colors.red,
                                icon: Icons.error_outline,
                                location: DelightSnackbarPosition.top,
                                response:
                                    'Passwords must be greater than 8 characters',
                              ).showToast(context);
                            }
                          } else {
                            return const ResponsePopUp(
                              color: Colors.red,
                              icon: Icons.error_outline,
                              location: DelightSnackbarPosition.top,
                              response: 'Passwords do not match',
                            ).showToast(context);
                          }
                        },
                        splashFactory: InkRipple.splashFactory,
                        splashColor: const Color(0xff8FCF8B),
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff14342B),
                                Color(0xff60935D),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Text(
                            'Create New Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
