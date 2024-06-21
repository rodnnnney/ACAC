import 'package:ACAC/common_layer/consts/globals.dart';
import 'package:ACAC/common_layer/widgets/loading.dart';
import 'package:ACAC/common_layer/widgets/response_pop_up.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class FirstTimeSignIn extends StatefulWidget {
  static String id = 'First_Time';

  FirstTimeSignIn({super.key});

  @override
  State<FirstTimeSignIn> createState() => _FirstTimeSignInState();
}

class _FirstTimeSignInState extends State<FirstTimeSignIn> {
  late TextEditingController newPassword;
  late TextEditingController newPassword2;
  bool obscureText = true;
  Loading loading = Loading();

  void initState() {
    newPassword = TextEditingController();
    newPassword2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newPassword.dispose();
    newPassword2.dispose();
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
                            ('Create your own password'),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            speed: const Duration(milliseconds: 250),
                          ),
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
                        controller: newPassword,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          labelText: 'Create New Password',
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
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateColor.transparent,
                              padding:
                                  WidgetStateProperty.all(EdgeInsets.zero)),
                          // onPressed: () => widget.state.changeStep(
                          //   AuthenticatorStep.resetPassword,
                          // ),
                          onPressed: () {},
                          child: const Text('Back to Sign In')),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          if (newPassword.text == newPassword2.text) {
                            if (newPassword.text.length >= 8) {
                              loading.showLoadingDialog(context);
                              await Amplify.Auth.confirmSignIn(
                                confirmationValue: newPassword.text,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              return const ResponsePopUp(
                                      color: Colors.red,
                                      icon: Icons.error_outline,
                                      location: DelightSnackbarPosition.top,
                                      response: 'Passwords must greater than 8 '
                                          'characters')
                                  .showToast(context);
                            }
                          } else {
                            return const ResponsePopUp(
                                    color: Colors.red,
                                    icon: Icons.error_outline,
                                    location: DelightSnackbarPosition.top,
                                    response: 'Passwords do not match')
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
