import 'package:flutter/material.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Navigation_Info_Provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Polyline_Info.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/Restaurant_Provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/UserInfo_Provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/riverpod/riverpod_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'common/routing/routes.dart';
import 'common/theme/Color_theme.dart';
import 'domain_layer/use_cases/Login.dart';

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
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      theme:
          ref.watch(darkLight).theme ? AppTheme.darkTheme : AppTheme.lightTheme,
      initialRoute: LoginScreen.id,
      routes: appRoutes,
    );
  }
}
