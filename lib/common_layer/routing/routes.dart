import 'package:ACAC/presentation_layer/pages/discount_card.dart';
import 'package:ACAC/presentation_layer/pages/history.dart';
import 'package:ACAC/presentation_layer/pages/home.dart';
import 'package:ACAC/presentation_layer/pages/maps.dart';
import 'package:ACAC/presentation_layer/pages/qr_code_gen.dart';
import 'package:ACAC/presentation_layer/pages/scanner.dart';
import 'package:ACAC/presentation_layer/pages/settings.dart';
import 'package:ACAC/presentation_layer/widgets/multi_card_view.dart';
import 'package:ACAC/presentation_layer/widgets/sort_by_rating.dart';
import 'package:flutter/cupertino.dart';

final appRoutes = <String, WidgetBuilder>{
  MapScreen.id: (context) => MapScreen(),
  HomePage.id: (context) => HomePage(),
  AccountInfo.id: (context) => AccountInfo(),
  CardViewerHomePage.id: (context) => CardViewerHomePage(
        cuisineType: ModalRoute.of(context)!.settings.arguments as String,
      ),
  // Scanner.id: (context) => Scanner(),
  SortedByRating.id: (context) => const SortedByRating(),
  QrCodeGen.id: (context) => const QrCodeGen(),
  DiscountCard.id: (context) {
    final name = ModalRoute.of(context)!.settings.arguments as String?;
    return DiscountCard(name: name!);
  },
  QRViewExample.id: (context) => QRViewExample(),
  History.id: (context) => History(),
};
