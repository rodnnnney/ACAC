import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:googlemaptest/common/widgets/app_bar.dart';
import 'package:googlemaptest/presentation_layer/state_management/riverpod/riverpod_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AccountInfo extends ConsumerWidget {
  static String id = 'Account_screen';
  AccountInfo({super.key});

  String feedbackText = '';
  final TextEditingController _controller = TextEditingController();
  bool isSwitched = false;

  Center text() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 50,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          child: AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText('Digital ACAC card?'),
              FadeAnimatedText('Report a bug🐜?'),
              FadeAnimatedText('AI integration🤖? '),
              FadeAnimatedText(
                  'Does this app make finding ACAC restaurants easier?'),
              FadeAnimatedText('Is this app easy to use?'),
              FadeAnimatedText('All feedback is appreciated! '),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UserInfo user = Provider.of<UserInfo>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Account Settings'),
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Email@email.com')
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: ref.watch(darkLight).theme
                                ? Border.all(color: Colors.white, width: 1)
                                : Border.all(color: Colors.black, width: 1),
                            //borderRadius: BorderRadius.circular(8),
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
                          Text('*******')
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: ref.watch(darkLight).theme
                                ? Border.all(color: Colors.white, width: 1)
                                : Border.all(color: Colors.black, width: 1),
                            //borderRadius: BorderRadius.circular(8),
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
                          Text(ref.watch(darkLight).theme
                              ? 'Dark Mode🌚'
                              : 'Light Mode🌞'),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              ref.read(darkLight).toggleThemeOff();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: ref.watch(darkLight).theme
                                    ? null
                                    : Border.all(color: Colors.black, width: 1),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.light_mode,
                                  color: ref.watch(darkLight).theme
                                      ? Colors.white
                                      : null),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                                elevation: WidgetStateProperty.all(0),
                                padding:
                                    WidgetStateProperty.all(EdgeInsets.zero)),
                            onPressed: () {
                              ref.read(darkLight).toggleThemeOn();
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
                                    : null,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  ShadInputFormField(
                    label: Text(
                      'Feedback',
                      style: TextStyle(
                          color: ref.watch(darkLight).theme
                              ? Colors.white
                              : Colors.black),
                    ),
                    placeholder:
                        const Text('Name a feature you wish this app had!'),
                    controller: _controller,
                    onChanged: (value) {
                      feedbackText = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ShadButton(
                      //   onPressed: () {
                      //     if (feedbackText.isEmpty) {
                      //       ShadToaster.of(context).show(
                      //         const ShadToast.destructive(
                      //           title: Text('Uh oh, somethings not right'),
                      //           description: Text(
                      //               'Please enter something in feedback box'),
                      //         ),
                      //       );
                      //     } else {
                      //    user.sendFeedBack(feedbackText, user.email).then(
                      //             (value) => ShadToaster.of(context).show(
                      //               ShadToast(
                      //                 backgroundColor: const Color(0xffBEE7B8),
                      //                 title: const Text('Message Sent!'),
                      //                 description: const Text(
                      //                     'Thank you for your feedback🫡'),
                      //                 action: ShadButton.outline(
                      //                     text: const Text(
                      //                       'Close',
                      //                       style:
                      //                           TextStyle(color: Colors.black),
                      //                     ),
                      //                     onPressed: () {
                      //                       ShadToaster.of(context).hide();
                      //                     }),
                      //               ),
                      //             ),
                      //           );
                      //     }
                      //     _controller.clear();
                      //   },
                      //   gradient: const LinearGradient(colors: [
                      //     Colors.greenAccent,
                      //     Colors.cyan,
                      //   ]),
                      //   shadows: [
                      //     BoxShadow(
                      //       color: Colors.blue.withOpacity(.4),
                      //       spreadRadius: 4,
                      //       blurRadius: 10,
                      //       offset: const Offset(0, 2),
                      //     ),
                      //   ],
                      //   text: const Text('Submit'),
                      // ),
                      Row(
                        children: [
                          const Text('Send Anonymously'),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              // setState(
                              //       () {
                              //     isSwitched = value;
                              //   },
                              // );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Spacer(),
            ShadButton.destructive(
              text: const Text('Logout'),
              onPressed: () async {
                // await user.signOut();
                // Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: AppBarBottom(id: AccountInfo.id),
    );
  }
}
