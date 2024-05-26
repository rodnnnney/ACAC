import 'package:flutter/material.dart';
import 'package:googlemaptest/presentation_layer/pages/account.dart';
import 'package:googlemaptest/presentation_layer/pages/home.dart';
import 'package:googlemaptest/presentation_layer/pages/maps.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/user_info_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/riverpod/riverpod_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart' as provider;

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

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
    UserInfo user = provider.Provider.of<UserInfo>(context);

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
              print(pb.authStore.token);
              print(MediaQuery.sizeOf(context).height);
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
