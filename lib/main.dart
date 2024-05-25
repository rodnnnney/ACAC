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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'Login/Login.dart';
import 'Login/Welcome.dart';
import 'Models+Data/Color_theme.dart';
import 'Providers/riverpod_test.dart';

void main() => runApp(MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<Restaurant>(
            create: (context) => Restaurant()),
        provider.ChangeNotifierProvider<PolyInfo>(
            create: (context) => PolyInfo()),
        provider.ChangeNotifierProvider<NavInfo>(
            create: (context) => NavInfo()),
        provider.ChangeNotifierProvider<UserInfo>(
            create: (context) => UserInfo()),
      ],
      child: const ProviderScope(
        child: MyApp(),
      ),
    ));

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      theme:
          ref.watch(darkLight).theme ? AppTheme.darkTheme : AppTheme.lightTheme,
      initialRoute: LoginScreen.id,
      routes: appRoutes,
    );
  }
}

// Widget build(BuildContext context) {
