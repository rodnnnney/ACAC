import 'package:ACAC/common/consts/globals.dart';
import 'package:flutter/cupertino.dart';

class CustomCheckBox extends StatelessWidget {
  final Color color;
  final IconData iconData;

  const CustomCheckBox({
    super.key,
    required this.color,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Icon(
        iconData,
        color: AppTheme.kWhite,
      ),
    );
  }
}
