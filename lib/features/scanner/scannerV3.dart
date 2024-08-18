import 'dart:async';

import 'package:ACAC/common/widgets/ui/loading.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/home/service/user_api_service.dart';
import 'package:ACAC/features/scanner/helper_widget/discount_card.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends ConsumerStatefulWidget {
  static String id = 'Scanner';

  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  ScanResult? scanResult;

  User? user;

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
    fetchUserInfo();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   safePrint("Attempting automatic scan after delay");
    //   _scan();
    // });
  }

//Future.delayed(Duration(seconds: 1)s
  Future<void> fetchUserInfo() async {
    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      User newUser =
          await ref.read(userAPIServiceProvider).getUser(currentUser.userId);

      setState(() {
        user = newUser;
      });
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  Future<void> sendData(RestaurantInfoCard scannedRestaurant) async {
    await ref
        .read(restaurantInfoCardListProvider.notifier)
        .updateRestInfo(scannedRestaurant);
    await ref.read(restaurantListControllerProvider.notifier).addRestaurant(
          restaurantName: scannedRestaurant.restaurantName,
          email: user?.email ?? '',
          userFirstName: user?.firstName ?? '',
          userLastName: user?.lastName ?? '',
        );
    if (mounted) {
      handleScan(
          scannedRestaurant, user?.firstName ?? '', user?.lastName ?? '');
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
    final scanResult = this.scanResult;
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async {
                      await _scan();
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.lightGreen),
                        child: const Text('Start Scan',
                            style: TextStyle(color: Colors.white)))),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.redAccent),
                    child: const Text(
                      'Exit Scan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scan() async {
    var test = ref.watch(restaurantInfoCardListProvider);
    try {
      final result = await BarcodeScanner.scan(
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
      if (scanResult != null) {
        test.when(
          data: (list) async {
            var matchingCard = list.firstWhere(
              (card) => card.scannerDataMatch == scanResult?.rawContent,
            );
            await sendData(matchingCard);
          },
          error: (error, stackTrace) {
            return Text('Error: ${error.toString()}');
          },
          loading: () {
            return const CircularProgressIndicator();
          },
        );
      }
      //safePrint("Raw content: ${scanResult?.rawContent}");
      //safePrint("Scan result to string: ${scanResult?.format.name}");
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
