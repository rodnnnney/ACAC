import 'package:ACAC/domain_layer/use_cases/Login.dart';
import 'package:ACAC/domain_layer/use_cases/sign_up.dart';
import 'package:ACAC/domain_layer/use_cases/welcome.dart';
import 'package:ACAC/presentation_layer/pages/discount_card.dart';
import 'package:ACAC/presentation_layer/pages/home.dart';
import 'package:ACAC/presentation_layer/pages/maps.dart';
import 'package:ACAC/presentation_layer/pages/qr_code_gen.dart';
import 'package:ACAC/presentation_layer/pages/scanner.dart';
import 'package:ACAC/presentation_layer/pages/settings.dart';
import 'package:ACAC/presentation_layer/widgets/multi_card_view.dart';
import 'package:ACAC/presentation_layer/widgets/sort_by_rating.dart';
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
  // Scanner.id: (context) => Scanner(),
  SortedByRating.id: (context) => SortedByRating(),
  QrCodeGen.id: (context) => const QrCodeGen(),
  DiscountCard.id: (context) => DiscountCard(
        name: '',
      ),
  QRViewExample.id: (context) => QRViewExample()
};
