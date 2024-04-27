import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googlemaptest/Providers/Restaurant_Provider.dart';
import 'package:provider/provider.dart';

class cardViewerHomePage extends StatelessWidget {
  static String id = 'card_viewer';
  const cardViewerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Restaurant data = Provider.of<Restaurant>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 150, right: 40, left: 0, bottom: 10),
        child: Text('Hello'),
      ),
    );
  }
}
