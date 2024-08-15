import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'input_text/string_formatting.dart';

class Chat extends StatefulWidget {
  static String id = 'chat.id';

  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

final gemini = Gemini.instance;
ChatUser currentUser = ChatUser(id: "0", firstName: "");
ChatUser geminiUser = ChatUser(id: "1", firstName: "Owen");
bool userTurn = true;

ChatMessage geminiInitialMessage =
    ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: initText);

List<ChatMessage> messages = [];

class _ChatState extends State<Chat> {
  late List<Widget> optionList;
  bool _userTurn = true;

  @override
  void initState() {
    super.initState();
    initialMessage();
    _buildOptionList();
  }

  List<TextSpan> parseBoldText(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    int currentIndex = 0;

    for (final Match match in boldPattern.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: baseStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1)!, // Remove the asterisks
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ));
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ));
    }
    return spans;
  }

  void _buildOptionList() {
    optionList = [
      ClearBox(
        clear: clearChat,
        userTurn: _userTurn,
      ),
      PromptOption(
        sendMessage: sendMessage,
        prompt: 'Surprise',
        buttonDisplayText: 'Surprise😦',
        userTurn: _userTurn,
      ),
      PromptOption(
        sendMessage: sendMessage,
        prompt: 'Chinese',
        buttonDisplayText: 'Chinese🇨🇳',
        userTurn: _userTurn,
      ),
      PromptOption(
        sendMessage: sendMessage,
        prompt: 'Korean',
        buttonDisplayText: 'Korean🇰🇷',
        userTurn: _userTurn,
      ),
      PromptOption(
        sendMessage: sendMessage,
        prompt: 'Bubble Tea',
        buttonDisplayText: 'Bubble Tea🧋',
        userTurn: _userTurn,
      ),
      PromptOption(
        sendMessage: sendMessage,
        prompt: 'Desert',
        buttonDisplayText: 'Desert🍦',
        userTurn: _userTurn,
      ),
    ];
  }

  void initialMessage() {
    if (messages.isEmpty) {
      setState(() {
        messages = [geminiInitialMessage, ...messages];
      });
    }
  }

  void clearChat() async {
    setState(() {
      messages = [];
      messages = [geminiInitialMessage, ...messages];
      userTurn = true;
    });
  }

  void setUserTurnFalse() {
    setState(() {
      userTurn = false;
    });
  }

  void sendMessage(ChatMessage chatInputMessage) async {
    String question = chatInputMessage.text;
    setState(() {
      messages = [chatInputMessage, ...messages];
      _userTurn = false;
      _buildOptionList(); // Rebuild option list
    });
    try {
      getRestaurantData(question).then((restaurantData) {
        gemini
            .streamGenerateContent(questionFormat(question) +
                restaurantData.toString() +
                answerFormat)
            .listen(
          (event) {
            ChatMessage? lastMessage = messages.firstOrNull;
            if (lastMessage != null && lastMessage.user == geminiUser) {
              lastMessage = messages.removeAt(0);
              String geminiResponseFormat = event.content?.parts?.fold(
                      "", (previous, current) => "$previous${current.text}") ??
                  '';
              lastMessage.text += geminiResponseFormat;
              parseBoldText(geminiResponseFormat,
                  Theme.of(context).textTheme.bodyMedium!);
              setState(() {
                messages = [lastMessage!, ...messages];
              });
            } else {
              String geminiResponseFormat = event.content?.parts?.fold(
                      "", (previous, current) => "$previous${current.text}") ??
                  '';
              ChatMessage geminiResponseMessage = ChatMessage(
                  user: geminiUser,
                  createdAt: DateTime.now(),
                  text: geminiResponseFormat);
              setState(() {
                messages = [geminiResponseMessage, ...messages];
              });
            }
          },
          onError: (error) {
            safePrint('Error: $error');
            setState(() {
              _userTurn = true;
              _buildOptionList(); // Rebuild option list
            });
          },
          onDone: () {
            setState(() {
              _userTurn = true;
              _buildOptionList(); // Rebuild option list
            });
          },
        );
      });
    } catch (e) {
      safePrint(e);
      setState(() {
        _userTurn = true;
        _buildOptionList(); // Rebuild option list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget chatUi() {
      return DashChat(
        currentUser: currentUser,
        onSend: sendMessage,
        messages: messages,
        readOnly: true,
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: chatUi(),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: 40,
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return optionList[index];
                      },
                      itemCount: optionList.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClearBox extends StatelessWidget {
  final Function clear;
  final bool userTurn;

  const ClearBox({super.key, required this.clear, required this.userTurn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        userTurn ? clear() : () {};
      },
      child: Opacity(
        opacity: userTurn ? 1 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xffffa69e),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(color: const Color(0xffff686b), width: 1)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'clear',
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.close,
                color: Colors.white,
                size: 21,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PromptOption extends StatelessWidget {
  final Function(ChatMessage) sendMessage;
  final String buttonDisplayText;
  final String prompt;
  final bool userTurn;

  const PromptOption({
    super.key,
    required this.sendMessage,
    required this.prompt,
    required this.buttonDisplayText,
    required this.userTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          userTurn
              ? sendMessage(ChatMessage(
                  user: currentUser, createdAt: DateTime.now(), text: prompt))
              : () {};
        },
        child: Opacity(
          opacity: userTurn ? 1 : 0.5,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
                child: Text(
              buttonDisplayText,
              style: const TextStyle(color: Colors.black),
            )),
          ),
        ),
      ),
    );
  }
}
