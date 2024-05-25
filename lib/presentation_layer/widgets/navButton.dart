import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPress; // Corrected the callback type
  final Text displayText; // Keeping it as Text widget

  NavButton(this.color, this.displayText, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: displayText, // Directly using the Text widget
        ),
      ),
    );
  }
}
