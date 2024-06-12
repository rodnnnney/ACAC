import 'package:acacmobile/presentation_layer/pages/home.dart';
import 'package:acacmobile/presentation_layer/pages/maps.dart';
import 'package:acacmobile/presentation_layer/pages/scanner.dart';
import 'package:acacmobile/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarBottom extends ConsumerWidget {
  final String id;
  AppBarBottom({
    super.key,
    required this.id,
  });

  BoxDecoration selected = BoxDecoration(
      borderRadius: BorderRadius.circular(20), color: Colors.lightGreen);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchCounter = ref.watch(userPageCounter);

    void updatePage(int index, String route) {
      Navigator.pushNamed(context, route);
      ref.read(userPageCounter).setCounter(index);
    }

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () async {
              updatePage(0, HomePage.id);
            },
            icon: Container(
              decoration: watchCounter.counter == 0 ? selected : null,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.home,
                color: watchCounter.counter == 0 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              updatePage(1, Scanner.id);
            },
            icon: Container(
              decoration: watchCounter.counter == 1 ? selected : null,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: watchCounter.counter == 1 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              updatePage(2, MapScreen.id);
            },
            icon: Container(
              decoration: watchCounter.counter == 2 ? selected : null,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.map,
                color: watchCounter.counter == 2 ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}