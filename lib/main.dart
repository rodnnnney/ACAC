import 'package:acacmobile/presentation_layer/pages/home.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/user_info_provider.dart';
import 'package:acacmobile/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';

import 'amplifyconfiguration.dart';
import 'common_layer/routing/routes.dart';
import 'common_layer/theme/color_theme.dart';
import 'models/ModelProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }
  runApp(
    MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<RestaurantInfo>(
            create: (context) => RestaurantInfo()),
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
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = ColorTheme(context);
    return Authenticator(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        theme: ref.watch(darkLight).theme
            ? colorTheme.themeDataDark()
            : colorTheme.themeDataLight(),
        initialRoute: HomePage.id,
        routes: appRoutes,
      ),
    );
  }
}

Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyAuthCognito(),
    AmplifyAPI(
      options: APIPluginOptions(modelProvider: ModelProvider.instance),
    ),
    AmplifyStorageS3()
  ]);
  await Amplify.configure(amplifyconfig);
}
