import 'package:ACAC/common/consts/globals.dart';
import 'package:flutter/material.dart';

class TimeFilter extends StatelessWidget {
  const TimeFilter({
    super.key,
    required this.uiText,
    required this.hovered,
    required this.uiNum,
    required this.onHover,
  });

  final String uiText;
  final int hovered;
  final int uiNum;
  final Function(int) onHover;

  @override
  Widget build(BuildContext context) {
    bool show = (hovered == uiNum);
    return GestureDetector(
      onTap: () {
        onHover(uiNum); // Call the parent’s function to update state
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: show ? AppTheme.kGreen2 : Colors.black.withOpacity(0.5),
        ),
        child: Text(uiText, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
