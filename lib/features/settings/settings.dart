import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/routing/ui/app_bar.dart';
import 'package:ACAC/common/routing/ui/centerNavButton.dart';
import 'package:ACAC/common/widgets/helper_functions/phone_call.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/home/history.dart';
import 'package:ACAC/features/settings/sorting/Favourites.dart';
import 'package:ACAC/features/user_auth/data/cache_user.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountInfo extends ConsumerWidget with RouteAware {
  static String id = 'Account_screen';
  AccountInfo({super.key});
  bool isSwitched = false;
  final LaunchLink launchLink = LaunchLink();

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  Future<void> deleteUser() async {
    try {
      await Amplify.Auth.deleteUser();
      safePrint('Delete user succeeded');
    } on AuthException catch (e) {
      safePrint('Delete user failed with error: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userObject = ref.watch(currentUserProvider);
    return Scaffold(
        body: userObject.when(
      data: (user) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: CenterNavWidget(
            ref: ref,
          ),
          appBar: AppBar(
            title: const Text('Account Settings'),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (user.id == dotenv.get('GUEST_ID'))
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                ref.read(userPageCounter).setCounter(7);
                                Navigator.pushNamed(context, History.id);
                              },
                              child: const SizedBox(
                                height: 100,
                                width: 120,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      children: [
                                        Icon(Icons.timeline_outlined,
                                            size: 40, color: AppTheme.kGreen2),
                                        Text(
                                          'History',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                ref.read(userPageCounter).setCounter(8);
                                Navigator.pushNamed(context, Favourites.id);
                              },
                              child: const SizedBox(
                                height: 100,
                                width: 120,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Icon(
                                          Icons.favorite_outlined,
                                          size: 35,
                                          color: Colors.redAccent,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            'Favourites',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Adjust the width as needed
                                child: Opacity(
                                  opacity: 0.65,
                                  child: Text(
                                    (user.id == dotenv.get('GUEST_ID'))
                                        ? 'guestaccount@gmail.com'
                                            ''
                                        : user.email,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                            ),
                            onPressed: () {
                              const ResponsePopUp(
                                response: 'Coming Soon...😂',
                                location: DelightSnackbarPosition.top,
                                icon: Icons.error_outline,
                                color: Colors.redAccent,
                              ).showToast(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: ref.watch(darkLight).theme
                                      ? Colors.white
                                      : Colors.black,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Change',
                                style: TextStyle(
                                  color: ref.watch(darkLight).theme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Opacity(opacity: 0.65, child: Text('*******'))
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                            ),
                            onPressed: () {
                              const ResponsePopUp(
                                response: 'Coming Soon...😂',
                                location: DelightSnackbarPosition.top,
                                icon: Icons.error_outline,
                                color: Colors.redAccent,
                              ).showToast(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: ref.watch(darkLight).theme
                                    ? Border.all(color: Colors.white, width: 1)
                                    : Border.all(color: Colors.black, width: 1),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Change',
                                style: TextStyle(
                                    color: ref.watch(darkLight).theme
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'App Appearance',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Opacity(
                                opacity: 0.65,
                                child: Text(ref.watch(darkLight).theme
                                    ? 'Dark Mode🌚'
                                    : 'Light Mode🌞'),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  elevation: WidgetStateProperty.all(0),
                                  padding:
                                      WidgetStateProperty.all(EdgeInsets.zero),
                                ),
                                onPressed: () {
                                  ref.watch(darkLight).theme == false
                                      ? null
                                      : ref.read(darkLight).toggleThemeOff();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: ref.watch(darkLight.notifier).theme
                                        ? null
                                        : Border.all(
                                            color: Colors.black, width: 1),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(Icons.light_mode,
                                      color: ref.watch(darkLight).theme
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    elevation: WidgetStateProperty.all(0),
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.zero)),
                                onPressed: () {
                                  ref.watch(darkLight).theme
                                      ? null
                                      : ref
                                          .read(darkLight.notifier)
                                          .toggleThemeOn();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: ref.watch(darkLight).theme
                                          ? Border.all(
                                              color: Colors.white, width: 1)
                                          : null
                                      //borderRadius: BorderRadius.circular(8),
                                      ),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.dark_mode,
                                    color: ref.watch(darkLight).theme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledLogoutActionButton(
                            buttonText: 'Logout',
                            iconData: Icons.logout_outlined,
                            action: signOutCurrentUser,
                            warningTextH1: 'Confirm '
                                'Sign Out',
                            warningTextH2: 'Are you sure you want '
                                'to sign out?',
                            actionButtonText: 'Sign Out',
                          ),
                          (user.id == dotenv.get('GUEST_ID'))
                              ? Container()
                              : DeleteAccountForever(
                                  ref: ref,
                                  action: deleteUser,
                                )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Questions or Concerns?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Opacity(
                                opacity: 0.65,
                                child: Text('Reach out '
                                    'below(Tap) : ')),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      launchLink.launchURL(
                                          'https://www.instagram.com/asiancanadians_carleton/');
                                    },
                                    child: Image.asset(
                                      'images/ig2.png',
                                      width: 50,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      launchLink.launchEmail(
                                          'asiancanadianscarleton@gmail.com');
                                    },
                                    child: Image.asset(
                                      'images/gmail.png',
                                      width: 50,
                                    ),
                                  )
                                ])
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AppBarBottom(id: AccountInfo.id),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        safePrint('An error occurred: $error');
        return Text('An error occurred: $error');
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    ));
  }
}

class DeleteAccountForever extends StatelessWidget {
  const DeleteAccountForever({
    super.key,
    required this.ref,
    required this.action,
  });

  final Future<void> Function() action;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    TextEditingController confirmText = TextEditingController();
    return TextButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter localState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      ref.watch(darkLight).theme ? Colors.grey : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Adjust the column size dynamically
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Delete account',
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('Deleting your account is '
                            'an irreversible action, '
                            'type "I understand" to continue'),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: confirmText,
                          decoration: InputDecoration(
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
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ref.watch(darkLight).theme
                                    ? Colors.grey
                                    : Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ref.watch(darkLight).theme
                                    ? Colors.grey
                                    : Colors.white,
                                foregroundColor: Colors.red,
                                side: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              onPressed: () {
                                if (confirmText.text.trim() == 'I understand') {
                                  action();
                                } else {
                                  const ResponsePopUp(
                                    response: 'Bad input',
                                    location: DelightSnackbarPosition.top,
                                    icon: Icons.error,
                                    color: Colors.redAccent,
                                  ).showToast(ctx);
                                }
                              },
                              child: const Text('Delete Account'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
                color: Colors.red, width: 1.0), // Border color and width
          ),
        ),
      ),
      child: const Row(
        children: [
          Text(
            'Delete Account',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}

class StyledLogoutActionButton extends StatelessWidget {
  const StyledLogoutActionButton(
      {super.key,
      required this.buttonText,
      required this.iconData,
      required this.action,
      required this.warningTextH1,
      required this.warningTextH2,
      required this.actionButtonText});

  final String buttonText;
  final IconData iconData;
  final Future<void> Function() action;
  final String warningTextH1;
  final String warningTextH2;
  final String actionButtonText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmQuit(
                destination: action,
                title: 'Confirm Sign Out',
                subtitle: 'Are you sure you want to sign out?',
                actionButton: 'Sign Out',
              );
            });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
                color: Colors.red, width: 1.0), // Border color and width
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            buttonText,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            iconData,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
