import 'package:flutter/material.dart';
import 'package:googlemaptest/Pages/Account.dart';
import 'package:googlemaptest/Pages/Home.dart';
import 'package:googlemaptest/Pages/Maps.dart';
import 'package:googlemaptest/Providers/riverpod_test.dart';
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
            onPressed: () {
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
              updatePage(1, MapScreen.id);
            },
            icon: Container(
              decoration: watchCounter.counter == 1 ? selected : null,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.map,
                color: watchCounter.counter == 1 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              updatePage(2, AccountInfo.id);
            },
            icon: Container(
              decoration: watchCounter.counter == 2 ? selected : null,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.account_circle,
                color: watchCounter.counter == 2 ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
