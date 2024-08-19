import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/features/chat/chat.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/features/maps/maps.dart';
import 'package:ACAC/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarBottom extends ConsumerWidget {
  AppBarBottom({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchCounter = ref.watch(userPageCounter);

    void updatePage(int index, String route) {
      Navigator.pushNamed(context, route);
      ref.read(userPageCounter).setCounter(index);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8), topLeft: Radius.circular(8)),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  onPressed: () async {
                    if (watchCounter.counter == 0) {
                    } else {
                      updatePage(0, HomePage.id);
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () async {
                    if (watchCounter.counter == 1) {
                    } else {
                      updatePage(1, Chat.id);
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.search_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      if (watchCounter.counter == 2) {
                      } else {
                        updatePage(2, MapScreen.id);
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.map,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (watchCounter.counter == 3) {
                      } else {
                        updatePage(3, AccountInfo.id);
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
