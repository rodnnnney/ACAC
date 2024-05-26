import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  HomeCard(
      {super.key,
      required this.screenHeight,
      required this.displayIMG,
      required this.text,
      required this.flag,
      required this.routeName});

  final double screenHeight;
  final String displayIMG;
  final String text;
  final String flag;
  final Function(BuildContext, String) routeName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          routeName(context, text);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    displayIMG,
                    height: screenHeight * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  children: [
                    Text(text),
                    Text(flag),
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
