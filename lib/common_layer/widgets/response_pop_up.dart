import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class ResponsePopUp extends StatelessWidget {
  final String issue;
  final DelightSnackbarPosition location;
  final IconData icon;
  final Color color;

  const ResponsePopUp(
      {Key? key,
      required this.issue,
      required this.location,
      required this.icon,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showToast(BuildContext context) {
    DelightToastBar(
      position: location,
      builder: (context) {
        return ToastCard(
          leading: Icon(icon, color: Colors.white),
          color: color,
          title: Text(
            issue,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        );
      },
      snackbarDuration: const Duration(seconds: 2),
      autoDismiss: true,
    ).show(context);
  }
}
