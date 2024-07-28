import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_rating.dart';
import 'package:ACAC/features/home/history.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/features/maps/maps.dart';
import 'package:ACAC/features/scanner/helper_widget/qr_code_gen.dart';
import 'package:ACAC/features/scanner/scanner.dart';
import 'package:ACAC/features/settings/settings.dart';
import 'package:flutter/cupertino.dart';

final appRoutes = <String, WidgetBuilder>{
  MapScreen.id: (context) => MapScreen(),
  HomePage.id: (context) => HomePage(),
  AccountInfo.id: (context) => AccountInfo(),
  QrCodeGen.id: (context) => const QrCodeGen(),
  QRViewExample.id: (context) => QRViewExample(),
  History.id: (context) => History(),
  SortedByRating.id: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return SortedByRating(type: args);
  },
};
