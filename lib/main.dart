import 'package:flutter/material.dart';
import 'package:googlemaptest/presentation_layer/pages/home.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/user_info_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';

import 'common/routing/routes.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ref.watch(darkLight).theme ? AppTheme.darkTheme : AppTheme.lightTheme,
      //TODO Fix this dark/light theme
      initialRoute: HomePage.id,
      routes: appRoutes,
    );
  }
}
