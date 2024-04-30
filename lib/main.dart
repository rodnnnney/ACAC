import 'package:flutter/material.dart';
import 'package:googlemaptest/Login/Sign_Up.dart';
import 'package:googlemaptest/Pages/Account.dart';
import 'package:googlemaptest/Pages/Home.dart';
import 'package:googlemaptest/Pages/Maps.dart';
import 'package:googlemaptest/Pages/multiCardView.dart';
import 'package:googlemaptest/Providers/Navigation_Info_Provider.dart';
import 'package:googlemaptest/Providers/Polyline_Info.dart';
import 'package:googlemaptest/Providers/Restaurant_Provider.dart';
import 'package:googlemaptest/Providers/UserInfo_Provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'Login/Login.dart';
import 'Login/Welcome.dart';

void main() {
  runApp(const MyApp());
}

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

class CardViewerHomePage {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Restaurant>(create: (context) => Restaurant()),
        ChangeNotifierProvider<PolyInfo>(create: (context) => PolyInfo()),
        ChangeNotifierProvider<NavInfo>(create: (context) => NavInfo()),
        ChangeNotifierProvider<UserInfo>(create: (context) => UserInfo()),
      ],
      child: ShadApp.material(
        debugShowCheckedModeBanner: false,
        theme: ShadThemeData(
          brightness: Brightness.light,
          colorScheme: ShadZincColorScheme.light(),
        ),
        darkTheme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadZincColorScheme.dark(),
        ),
        initialRoute: LoginScreen.id,
        routes: appRoutes,
      ),
    );
  }
}
