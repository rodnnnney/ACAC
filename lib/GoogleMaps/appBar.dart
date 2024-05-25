import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/presentation_layer/pages/Account.dart';
import 'package:googlemaptest/presentation_layer/pages/Home.dart';
import 'package:googlemaptest/presentation_layer/pages/maps.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Polyline_Info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Restaurant_Provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/UserInfo_Provider.dart';
import 'package:provider/provider.dart';

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
    Restaurant location = Provider.of<Restaurant>(context);
    PolyInfo maps = Provider.of<PolyInfo>(context);

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () async {
              user.setNum(0);
              Navigator.pushNamed(context, HomePage.id);

              LatLng position = await location.getLocation();
              print(position);
              String url = await maps.createHttpUrl(position.latitude,
                  position.longitude, 45.36865077062187, -75.7027755746115);
              // print(url);
              var decodedJson = jsonDecode(url);

              String distance =
                  decodedJson['routes'][0]['legs'][0]['distance']['text'];
              print(distance);
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
