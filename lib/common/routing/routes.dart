import 'package:flutter/cupertino.dart';
import 'package:googlemaptest/domain_layer/use_cases/Login.dart';
import 'package:googlemaptest/domain_layer/use_cases/sign_up.dart';
import 'package:googlemaptest/domain_layer/use_cases/welcome.dart';
import 'package:googlemaptest/presentation_layer/pages/account.dart';
import 'package:googlemaptest/presentation_layer/pages/home.dart';
import 'package:googlemaptest/presentation_layer/pages/maps.dart';
import 'package:googlemaptest/presentation_layer/pages/multi_card_view.dart';

final appRoutes = <String, WidgetBuilder>{
  WelcomeScreen.id: (context) => const WelcomeScreen(),
  LoginScreen.id: (context) => const LoginScreen(),
  RegistrationScreen.id: (context) => RegistrationScreen(),
  MapScreen.id: (context) => MapScreen(),
  HomePage.id: (context) => HomePage(),
  AccountInfo.id: (context) => AccountInfo(),
  cardViewerHomePage.id: (context) => cardViewerHomePage(
        cuisineType: ModalRoute.of(context)!.settings.arguments as String,
      ),
};
