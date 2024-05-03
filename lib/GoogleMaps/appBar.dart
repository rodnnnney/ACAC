import 'package:flutter/material.dart';
import 'package:googlemaptest/Providers/UserInfo_Provider.dart';
import 'package:provider/provider.dart';

import '../Pages/Account.dart';
import '../Pages/Home.dart';
import '../Pages/maps.dart';

class AppBarBottom extends StatefulWidget {
  final String id;
  AppBarBottom({
    super.key,
    required this.id,
  });

  @override
  State<AppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends State<AppBarBottom> {
  BoxDecoration selected = BoxDecoration(
      borderRadius: BorderRadius.circular(20), color: Colors.lightGreen);

  @override
  Widget build(BuildContext context) {
    UserInfo user = Provider.of<UserInfo>(context);
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () {
              user.setNum(0);
              Navigator.pushNamed(context, HomePage.id);
              // print(user.name);
              // print(user.signInAcc);
              // print(user.signInAuth2);
              // print(user.email);
              // print(user.password);
              print(user.signInAuth2);
              print(user.signInAcc);
              (user.getInfo());
            },
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: user.selected == 0 ? selected : null,
              child: Icon(
                Icons.home,
                color: user.selected == 0 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              user.setNum(1);
              Navigator.pushNamed(context, MapScreen.id);
            },
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: user.selected == 1 ? selected : null,
              child: Icon(Icons.map,
                  color: user.selected == 1 ? Colors.white : Colors.grey),
            ),
          ),
          IconButton(
            onPressed: () {
              user.setNum(2);
              Navigator.pushNamed(context, AccountInfo.id);
            },
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: user.selected == 2 ? selected : null,
              child: Icon(Icons.account_circle,
                  color: user.selected == 2 ? Colors.white : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
