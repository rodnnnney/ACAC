import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';

class Welcome extends StatelessWidget {
  DateTime now = DateTime.now();
  static const kWelcomeText = TextStyle(
      fontFamily: 'Comforts',
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: Color(0xFF588157));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            greetingText(now, 'English'),
            textStyle: kWelcomeText,
            speed: const Duration(milliseconds: 250),
          ),
          TypewriterAnimatedText(greetingText(now, 'Korean'),
              textStyle: kWelcomeText,
              speed: const Duration(milliseconds: 250)),
          TypewriterAnimatedText(greetingText(now, 'Vietnamese'),
              textStyle: kWelcomeText,
              speed: const Duration(milliseconds: 250)),
          TypewriterAnimatedText(greetingText(now, 'Mandarin'),
              textStyle: kWelcomeText,
              speed: const Duration(milliseconds: 250)),
        ],
        repeatForever: true,
      ),
    );
  }
}

String greetingText(time, language) {
  late String greeting;
  // Determine the part of the day
  if (time.hour >= 0 && time.hour < 12) {
    switch (language) {
      case 'Korean':
        greeting = '좋은 아침이에요🫰🏼,';
        break;
      case 'Vietnamese':
        greeting = 'chào buổi sáng,';
        break;
      case 'Mandarin':
        greeting = '早上好,';
        break;
      case 'English':
      default:
        greeting = 'good morning🤠,';
        break;
    }
  } else if (time.hour >= 12 && time.hour < 18) {
    switch (language) {
      case 'Korean':
        greeting = '좋은 오후예요🫰🏼,';
        break;
      case 'Vietnamese':
        greeting = 'chào buổi chiều,';
        break;
      case 'Mandarin':
        greeting = '下午好,';
        break;
      case 'English':
      default:
        greeting = 'good afternoon😎,';
        break;
    }
  } else {
    switch (language) {
      case 'Korean':
        greeting = '좋은 저녁이에요🫰🏼,';
      case 'Vietnamese':
        greeting = 'Chào buổi tối,';
        // Adjust if necessary for Vietnamese
        break;
      case 'Mandarin':
        greeting = '晚上好,';
        break;
      case 'English':
      default:
        greeting = 'good evening😴,';
        break;
    }
  }
  return greeting;
}
