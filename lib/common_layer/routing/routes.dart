import 'package:acacmobile/domain_layer/use_cases/Login.dart';
import 'package:acacmobile/domain_layer/use_cases/sign_up.dart';
import 'package:acacmobile/domain_layer/use_cases/welcome.dart';
import 'package:acacmobile/presentation_layer/pages/account.dart';
import 'package:acacmobile/presentation_layer/pages/home.dart';
import 'package:acacmobile/presentation_layer/pages/maps.dart';
import 'package:acacmobile/presentation_layer/widgets/multi_card_view.dart';
import 'package:flutter/cupertino.dart';

final appRoutes = <String, WidgetBuilder>{
  WelcomeScreen.id: (context) => const WelcomeScreen(),
  LoginScreen.id: (context) => const LoginScreen(),
  RegistrationScreen.id: (context) => RegistrationScreen(),
  MapScreen.id: (context) => MapScreen(),
  HomePage.id: (context) => HomePage(),
  AccountInfo.id: (context) => AccountInfo(),
  CardViewerHomePage.id: (context) => CardViewerHomePage(
        cuisineType: ModalRoute.of(context)!.settings.arguments as String,
      ),
};
