import 'package:acacmobile/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmQuit extends ConsumerWidget {
  final VoidCallback destination;
  final String title;
  final String subtitle;
  final String actionButton;

  const ConfirmQuit(
      {super.key,
      required this.destination,
      required this.title,
      required this.subtitle,
      required this.actionButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
      child: AlertDialog(
        backgroundColor:
            ref.watch(darkLight).theme ? Colors.grey : Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.warning,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        content: Text(subtitle),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    ref.watch(darkLight).theme ? Colors.grey : Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.black, width: 1)),
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
                backgroundColor:
                    ref.watch(darkLight).theme ? Colors.grey : Colors.white,
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1)),
            onPressed: () {
              destination();
            },
            child: Text(actionButton),
          ),
        ],
      ),
    );
  }
}
