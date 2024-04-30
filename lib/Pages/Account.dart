import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:googlemaptest/Login/Login.dart';
import 'package:googlemaptest/Providers/UserInfo_Provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../GoogleMaps/appBar.dart';

class AccountInfo extends StatefulWidget {
  static String id = 'Account_screen';
  AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  bool isSwitched = false;
  String feedbackText = '';
  final TextEditingController _controller = TextEditingController();

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
  Widget build(BuildContext context) {
    UserInfo user = Provider.of<UserInfo>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(),
                  ShadInputFormField(
                    label: const Text('Feedback'),
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
                      ShadButton(
                        onPressed: () {
                          if (feedbackText.isEmpty) {
                            ShadToaster.of(context).show(
                              const ShadToast.destructive(
                                title: Text('Uh oh, somethings not right'),
                                description: Text(
                                    'Please enter something in feedback box'),
                              ),
                            );
                          } else if (user.email == '') {
                            user.o2AthSendFeedBack(
                                feedbackText,
                                user.getUserEmailAuthData(),
                                user.getO2AuthID());
                            _controller.clear();
                          } else
                            user.sendFeedBack(feedbackText, user.email);
                          _controller.clear();
                        },
                        gradient: const LinearGradient(colors: [
                          Colors.greenAccent,
                          Colors.cyan,
                        ]),
                        shadows: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(.4),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        text: const Text('Submit'),
                      ),
                      Row(
                        children: [
                          const Text('Send Anonymously'),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(
                                () {
                                  isSwitched = value;
                                },
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Spacer(),
            ShadButton.destructive(
              text: Text('Logout'),
              onPressed: () async {
                await user.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
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
