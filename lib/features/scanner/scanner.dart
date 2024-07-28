import 'dart:io';

import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/services/route_observer.dart';
import 'package:ACAC/common/widgets/ui/app_bar.dart';
import 'package:ACAC/common/widgets/ui/loading.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/home/service/user_api_service.dart';
import 'package:ACAC/features/scanner/helper_widget/discount_card.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends ConsumerStatefulWidget {
  static const String id = 'qr_scanner';
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends ConsumerState<QRViewExample> with RouteAware {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String email = '';
  String name = '';
  Loading loading = Loading();
  late User user;
  List<RestaurantInfoCard> allInfoCards = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    controller?.dispose();
  }

  @override
  void didPopNext() {
    ref.read(userPageCounter).setCounter(1);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
      ref.read(userPageCounter).setCounter(1);
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userPageCounter).setCounter(1);
    });
    super.initState();
  }

  Future<void> fetchUserInfo() async {
    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      User newUser =
          await ref.read(userAPIServiceProvider).getUser(currentUser.userId);
      setState(() {
        user = newUser;
      });
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        if (element.userAttributeKey.toString() == 'email') {
          setState(() {
            email = element.value.toString();
          });
        } else if (element.userAttributeKey.toString() == 'name') {
          setState(() {
            name = element.value.toString();
          });
        }
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  Future<void> sendData(
      WidgetRef ref, RestaurantInfoCard scannedRestaurant) async {
    controller?.dispose();
    loading.showLoadingDialog(context);
    try {
      await ref
          .read(restaurantInfoCardListProvider.notifier)
          .updateRestInfo(scannedRestaurant);
      await ref.read(restaurantListControllerProvider.notifier).addRestaurant(
          restaurantName: scannedRestaurant.restaurantName,
          email: email,
          userFirstName: user.firstName,
          userLastName: user.lastName);
      handleScan(scannedRestaurant, user.firstName, user.lastName);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handleScan(
      RestaurantInfoCard restName, String firstName, String lastName) {
    controller?.dispose();
    HapticFeedback.heavyImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountCard(
          firstName: firstName,
          lastName: lastName,
          restaurantInfoCard: restName,
        ),
      ),
    );
    setState(() {
      const ResponsePopUp(
        response: 'QR scanned successfully',
        location: DelightSnackbarPosition.top,
        icon: Icons.check_circle,
        color: Colors.green,
      ).showToast(context);
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _handleQRCode(scanData);
      controller.dispose();
    });
  }

  Future<void> _handleQRCode(Barcode scanData) async {
    debugPrint('Scanned QR Code: ${scanData.code}');
    if (scanData.code != null) {
      // Find matching RestaurantInfoCard
      final matchingCard = allInfoCards.firstWhere(
        (card) => card.scannerDataMatch == scanData.code,
      );
      if (matchingCard.scannerDataMatch.isNotEmpty) {
        await sendData(ref, matchingCard);
      } else {
        setState(() {
          const ResponsePopUp(
            response: 'Hmm, idk that one',
            location: DelightSnackbarPosition.top,
            icon: Icons.error_outline,
            color: Colors.red,
          ).showToast(context);
        });
      }
    } else {
      setState(() {
        const ResponsePopUp(
          response: 'Hmm, idk that one',
          location: DelightSnackbarPosition.top,
          icon: Icons.error_outline,
          color: Colors.red,
        ).showToast(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var test = ref.watch(restaurantInfoCardListProvider);

    switch (test) {
      case AsyncData(value: final allInfoLoaded):
        for (var data in allInfoLoaded) {
          allInfoCards.add(data);
        }
    }
    return Scaffold(
      body: email.isEmpty && name.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : buildScanner(context),
    );
  }

  Widget buildScanner(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBarBottom(
        id: QRViewExample.id,
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
