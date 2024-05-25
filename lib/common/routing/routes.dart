import 'package:flutter/cupertino.dart';
import 'package:googlemaptest/domain_layer/use_cases/Login.dart';
import 'package:googlemaptest/domain_layer/use_cases/Sign_Up.dart';
import 'package:googlemaptest/domain_layer/use_cases/Welcome.dart';
import 'package:googlemaptest/presentation_layer/pages/Account.dart';
import 'package:googlemaptest/presentation_layer/pages/Home.dart';
import 'package:googlemaptest/presentation_layer/pages/maps.dart';
import 'package:googlemaptest/presentation_layer/pages/multiCardView.dart';

final appRoutes = <String, WidgetBuilder>{
  WelcomeScreen.id: (context) => WelcomeScreen(),
  LoginScreen.id: (context) => LoginScreen(),
  RegistrationScreen.id: (context) => RegistrationScreen(),
  MapScreen.id: (context) => MapScreen(),
  HomePage.id: (context) => HomePage(),
  AccountInfo.id: (context) => AccountInfo(),
  cardViewerHomePage.id: (context) => cardViewerHomePage(
        cuisineType: ModalRoute.of(context)!.settings.arguments as String,
      ),
};
