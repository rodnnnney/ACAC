import 'package:ACAC/common/APIs/apis.dart';
import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/loading.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FirstTimeSignIn extends ConsumerStatefulWidget {
  const FirstTimeSignIn({super.key, required this.email});

  final String email;

  @override
  ConsumerState<FirstTimeSignIn> createState() => _FirstTimeSignInState();
}

class _FirstTimeSignInState extends ConsumerState<FirstTimeSignIn> {
  late TextEditingController newPassword;
  late TextEditingController newPassword2;
  late TextEditingController firstName;
  late TextEditingController lastName;
  bool obscureText = true;
  Loading loading = Loading();
  Apis apis = Apis();
  bool isLoading = false;
  bool showHelp = false;

  @override
  void initState() {
    newPassword = TextEditingController();
    newPassword2 = TextEditingController();
    firstName = TextEditingController();
    lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newPassword.dispose();
    newPassword2.dispose();
    firstName.dispose();
    lastName.dispose();
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'What should we call you?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showHelp = !showHelp;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: firstName,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: const TextStyle(
                                  color: Color(0xff2E2E2E),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.roundedRadius),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.roundedRadius),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: lastName,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: const TextStyle(
                                  color: Color(0xff2E2E2E),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.roundedRadius),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.roundedRadius),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'Create your own password',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      showHelp ? const HelpBox() : Container(),
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
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedRadius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedRadius),
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
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedRadius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xff2E2E2E), width: 2),
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedRadius),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedRadius),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedRadius),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Back to Sign In'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          if (firstName.text.isEmpty || lastName.text.isEmpty) {
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
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                try {
                                  AuthUser data =
                                      await Amplify.Auth.getCurrentUser();
                                  await apis.cognito2DynamoDBB(firstName.text,
                                      lastName.text, widget.email, data.userId);
                                } catch (e) {}
                              });
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

class HelpBox extends StatelessWidget {
  const HelpBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.withOpacity(0.55), width: 1),
        color: Colors.red.withOpacity(0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Use your real name!',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'This will be the name shown on your '
            'ACAC membership card and cannot be '
            'changed!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
