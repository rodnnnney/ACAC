import 'dart:async';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/ui/loading.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/scanner/helper_widget/discount_card.dart';
import 'package:ACAC/features/user_auth/data/cache_user.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class App extends ConsumerStatefulWidget {
  static String id = 'Scanner';

  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  Loading loading = Loading();

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  Future<void> sendData(RestaurantInfoCard scannedRestaurant, User user) async {
    await ref
        .read(restaurantInfoCardListProvider.notifier)
        .updateRestInfo(scannedRestaurant);
    await ref.read(restaurantListControllerProvider.notifier).addRestaurant(
          restaurantName: scannedRestaurant.restaurantName,
          email: user.email,
          userFirstName: user.firstName,
          userLastName: user.lastName,
        );
    if (mounted) {
      handleScan(scannedRestaurant, user.firstName, user.lastName);
    }
  }

  void handleScan(
      RestaurantInfoCard restName, String firstName, String lastName) {
    HapticFeedback.heavyImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountCard(
          firstName: firstName,
          lastName: lastName,
          restaurantInfoCard: restName,
        ),
      ),
    );
    const ResponsePopUp(
      response: 'QR scanned successfully',
      location: DelightSnackbarPosition.top,
      icon: Icons.check_circle,
      color: Colors.green,
    ).showToast(context);
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<RestaurantInfoCard>> cardList =
        ref.watch(restaurantInfoCardListProvider);
    final userObject = ref.watch(currentUserProvider);
    ;
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.redAccent),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Exit Scan',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                userObject.when(
                  data: (user) {
                    return GestureDetector(
                      onTap: () async {
                        await _scanWithExceptionHandling(cardList, user);
                      },
                      child: const OptionCard(
                        displayText: 'Start Scan',
                        displayIconData: Icons.qr_code_scanner,
                        cardColor: AppTheme.kGreen3,
                      ),
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    safePrint('An error occurred: $error');
                    return Text('An error occurred: $error');
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget?> _scanWithExceptionHandling(
      AsyncValue<List<RestaurantInfoCard>> cardList, User user) async {
    try {
      await _scan(cardList, user);
      return null;
    } on PlatformException catch (e) {
      safePrint(e.code);
      if (e.code == "PERMISSION_NOT_GRANTED") {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const NoCameraAccess();
            },
          );
        }
      } else {
        return Text('Error: ${e.message}');
      }
    }
    return null;
  }

  Future<void> _scan(
      AsyncValue<List<RestaurantInfoCard>> cardList, User user) async {
    var test = await BarcodeScanner.scan(
      options: ScanOptions(
        strings: {
          'cancel': _cancelController.text,
          'flash_on': _flashOnController.text,
          'flash_off': _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      ),
    );

    if (test.rawContent.isNotEmpty) {
      cardList.when(
        data: (list) async {
          safePrint('scanning');
          var matchingCard = list.firstWhere(
            (card) => card.scannerDataMatch == test.rawContent,
          );
          safePrint(matchingCard);
          await sendData(matchingCard, user);
        },
        error: (error, stackTrace) {
          // Handle error
        },
        loading: () {
          // Handle loading
        },
      );
    }
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.displayText,
    required this.displayIconData,
    required this.cardColor,
  });
  final String displayText;
  final IconData displayIconData;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: cardColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayText,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            displayIconData,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class NoCameraAccess extends StatelessWidget {
  const NoCameraAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Camera Permission Required 📷😳'),
      content: const Text(
          'We need camera access to scan the QR codes... Hope that\'s okay with you 😗'),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppTheme.kGreen2)),
              child: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
