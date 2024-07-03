import 'dart:io';

import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/common_layer/widgets/response_pop_up.dart';
import 'package:ACAC/domain_layer/controller/restaurant_list_controller.dart';
import 'package:ACAC/presentation_layer/pages/discount_card.dart';
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

class _QRViewExampleState extends ConsumerState<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String email = '';
  String name = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  Future<void> fetchUserInfo() async {
    try {
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

  Future<void> sendData(WidgetRef ref, String restaurantName) async {
    handleScan(restaurantName);
    try {
      await ref.watch(restaurantListControllerProvider.notifier).addRestaurant(
          user: name,
          restaurantName: restaurantName,
          email: email,
          date: DateTime.now().toString());
    } catch (e) {}
  }

  void handleScan(String restName) {
    controller?.dispose();
    HapticFeedback.heavyImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountCard(
          name: email,
          restName: restName,
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
      setState(() {
        result = scanData;
      });
      _handleQRCode(scanData);
    });
  }

  Future<void> _handleQRCode(Barcode scanData) async {
    debugPrint('Scanned QR Code: ${scanData.code}');
    if (scanData.code != null) {
      switch (scanData.code) {
        case 'kinton_ramen':
          await sendData(ref, 'Kinton_Ramen');
          break;
        case 'Friends&KTV':
          await sendData(ref, 'Friends&KTV');
          break;
        case 'Chatime':
          await sendData(ref, 'Chatime');
          break;
        case 'Dakogi_Elgin':
          await sendData(ref, 'Dakogi_Elgin');
          break;
        case 'Dakogi_Marketplace':
          await sendData(ref, 'Dakogi_Marketplace');
          break;
        case 'Gongfu_Bao':
          await sendData(ref, 'Gongfu_Bao');
          break;
        case 'Hot_Star_Chicken':
          await sendData(ref, 'Hot_Star_Chicken');
          break;
        case 'La_Noodle':
          await sendData(ref, 'La_Noodle');
          break;
        case 'Oriental_house':
          await sendData(ref, 'Oriental_house');
          break;
        case 'Pho_Lady':
          await sendData(ref, 'Pho_Lady');
          break;
        case 'Pomelo_Hat':
          await sendData(ref, 'Pomelo_Hat');
          break;
        case 'Shuyi_Tealicious':
          await sendData(ref, 'Shuyi_Tealicious');
          break;
        case 'Fuwa_Fuwa':
          await sendData(ref, 'Fuwa_Fuwa');
          break;
        default:
          print('idk');
          controller?.dispose();
          setState(() {
            const ResponsePopUp(
              response: 'Hmm, idk that one',
              location: DelightSnackbarPosition.top,
              icon: Icons.error_outline,
              color: Colors.red,
            ).showToast(context);
          });
          break;
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
    super.dispose();
  }
}
