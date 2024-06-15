import 'package:ACAC/common_layer/widgets/response_pop_up.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class SignInCustom extends StatefulWidget {
  SignInCustom({super.key, required this.state});

  AuthenticatorState state;

  @override
  State<SignInCustom> createState() => _SignInCustomState();
}

late TextEditingController usernameController;
late TextEditingController passwordController;
double round = 7;
bool obscureText = true;

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> signInUser(
    String username, String password, BuildContext context) async {
  try {
    showLoadingDialog(context);
    await Amplify.Auth.signIn(
      username: username,
      password: password,
    );
    Navigator.pop(context);
  } on AuthException catch (e) {
    debugPrint(e.toString());
    if (e is UserNotFoundException) {
      if (context.mounted) {
        const ResponsePopUp(
                color: Colors.red,
                icon: Icons.error_outline,
                location: DelightSnackbarPosition.top,
                response: 'No account found')
            .showToast(context);
        Navigator.pop(context);
      }
    } else if (e is NotAuthorizedServiceException) {
      if (context.mounted) {
        const ResponsePopUp(
                color: Colors.red,
                icon: Icons.error_outline,
                location: DelightSnackbarPosition.top,
                response: 'Invalid Sign Credentials')
            .showToast(context);
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        const ResponsePopUp(
                color: Colors.red,
                icon: Icons.error_outline,
                location: DelightSnackbarPosition.top,
                response: 'An unknown error has occurred :(')
            .showToast(context);
        Navigator.pop(context);
      }
    }
  }
}

class _SignInCustomState extends State<SignInCustom> {
  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
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
                const SizedBox(
                  height: 100,
                ),
                Image.asset("images/acac1.png",
                    width: MediaQuery.of(context).size.width * 0.3),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            ('Welcome Back'),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            speed: const Duration(milliseconds: 250),
                          ),
                          // TypewriterAnimatedText(
                          //   ('Welcome Back in korean'),
                          //   speed: const Duration(milliseconds: 250),
                          // ),
                          // TypewriterAnimatedText(
                          //   ('Welcome Back Vietnamese'),
                          //   speed: const Duration(milliseconds: 250),
                          // ),
                          // TypewriterAnimatedText(
                          //   ('Welcome Back in Mandarin'),
                          //   speed: const Duration(milliseconds: 250),
                          // ),
                        ],
                        repeatForever: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            color: Color(0xff2E2E2E),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(round),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(round),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Color(0xff2E2E2E)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(round),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xff2E2E2E), width: 2),
                            borderRadius: BorderRadius.circular(round),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(round),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(round),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateColor.transparent,
                            padding: WidgetStateProperty.all(EdgeInsets.zero)),
                        onPressed: () => widget.state.changeStep(
                          AuthenticatorStep.resetPassword,
                        ),
                        child: RichText(
                          text: const TextSpan(
                              text: 'Forgot your',
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' password?',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          if (usernameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            await signInUser(usernameController.text,
                                passwordController.text, context);
                          } else {
                            const ResponsePopUp(
                                    color: Colors.red,
                                    icon: Icons.error_outline,
                                    location: DelightSnackbarPosition.top,
                                    response: 'All fields need to be filled')
                                .showToast(context);
                          }
                        },
                        splashFactory: InkRipple.splashFactory,
                        splashColor: const Color(0xff8FCF8B),
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xff14342B),
                                  Color(0xff60935D),
                                  Color(0xffF3F9D2),
                                ],
                                stops: [
                                  0.3,
                                  0.6,
                                  1
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(vertical: 10.0),
                //     height: 0.4,
                //     width: double.infinity, // Full width
                //     color: Colors.black,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     children: [
                //       const Text(
                //         'Don\'t have an account?',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //       const SizedBox(height: 15),
                //       GestureDetector(
                //         onTap: () =>
                //             widget.state.changeStep(AuthenticatorStep.signUp),
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(horizontal: 40),
                //           decoration: BoxDecoration(
                //               border:
                //               Border.all(color: Colors.black, width: 0.8),
                //               borderRadius: BorderRadius.circular(2)),
                //           child: ElevatedButton(
                //             style: ButtonStyle(
                //                 backgroundColor: WidgetStateColor.transparent,
                //                 elevation: WidgetStateProperty.all(0)),
                //             onPressed: () {},
                //             child: GestureDetector(
                //               onTap: () => widget.state
                //                   .changeStep(AuthenticatorStep.signUp),
                //               child: const Text(
                //                 'Create an Account',
                //                 style: TextStyle(color: Colors.black),
                //               ),
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
