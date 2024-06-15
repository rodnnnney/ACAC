// import 'package:ACAC/common_layer/widgets/app_bar.dart';
// import 'package:ACAC/domain_layer/controller/restaurant_list_controller.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// class Scanner extends ConsumerStatefulWidget {
//   static String id = 'scanner_screen';
//
//   Scanner({super.key});
//
//   @override
//   _ScannerState createState() => _ScannerState();
// }
//
// class _ScannerState extends ConsumerState<Scanner> {
//   String email = '';
//   String name = '';
//   late MobileScannerController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller =
//         MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
//     fetchUserInfo();
//   }
//
//   Future<void> fetchUserInfo() async {
//     try {
//       final result = await Amplify.Auth.fetchUserAttributes();
//       for (final element in result) {
//         if (element.userAttributeKey.toString() == 'email') {
//           setState(() {
//             email = element.value.toString();
//           });
//         } else if (element.userAttributeKey.toString() == 'name') {
//           setState(() {
//             name = element.value.toString();
//           });
//         }
//       }
//     } on AuthException catch (e) {
//       safePrint('Error fetching user attributes: ${e.message}');
//     }
//   }
//
//   Future<void> sendData(WidgetRef ref, String restaurantName) async {
//     try {
//       await ref.watch(restaurantListControllerProvider.notifier).addRestaurant(
//           user: name,
//           restaurantName: restaurantName,
//           email: email,
//           date: DateTime.now().toString());
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: email.isEmpty && name.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : buildScanner(context, ref),
//     );
//   }
//
// //TODO Scanner returns exclamation mark when opened and closed
//   Widget buildScanner(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Scanner Page'),
//       ),
//       body: MobileScanner(
//         controller: controller,
//         onDetect: (capture) async {
//           final List<Barcode> barcodes = capture.barcodes;
//           for (final barcode in barcodes) {
//             print(barcode.rawValue);
//             switch (barcode.rawValue) {
//               case 'kinton_ramen':
//                 await sendData(ref, 'kinton_ramen');
//                 break;
//               case 'Friends&KTV':
//                 await sendData(ref, 'Friends&KTV');
//                 break;
//               case 'Chatime':
//                 await sendData(ref, 'Chatime');
//                 break;
//               case 'Dakogi_Elgin':
//                 await sendData(ref, 'Dakogi_Elgin');
//                 break;
//               case 'Dakogi_Marketplace':
//                 await sendData(ref, 'Dakogi_Marketplace');
//                 break;
//               case 'Gongfu_Bao':
//                 await sendData(ref, 'Gongfu_Bao');
//                 break;
//               case 'Hot_Star_Chicken':
//                 await sendData(ref, 'Hot_Star_Chicken');
//                 break;
//               case 'La_Noodle':
//                 await sendData(ref, 'La_Noodle');
//                 break;
//               case 'Oriental_house':
//                 await sendData(ref, 'Oriental_house');
//                 break;
//               case 'Pho_Lady':
//                 await sendData(ref, 'Pho_Lady');
//                 break;
//               case 'Pomelo_Hat':
//                 await sendData(ref, 'Pomelo_Hat');
//                 break;
//               case 'Shuyi_Tealicious':
//                 await sendData(ref, 'Shuyi_Tealicious');
//                 break;
//               case 'Fuwa_Fuwa':
//                 await sendData(ref, 'Fuwa_Fuwa');
//                 break;
//             }
//           }
//         },
//       ),
//       bottomNavigationBar: AppBarBottom(
//         id: Scanner.id,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
import 'dart:io';
import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/presentation_layer/pages/discount_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  static const String id = 'qr_scanner';
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Scanner Page'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}\nData: ${result!.code}')
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBarBottom(
        id: QRViewExample.id,
      ),
    );
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

  void _handleQRCode(Barcode scanData) {
    // Example: Print the scanned data
    print('Scanned QR Code: ${scanData.code}');

    // Perform different actions based on the scanned data
    if (scanData.code != null) {
      switch (scanData.code) {
        case 'kinton_ramen':
          Navigator.push(
              context, DiscountCard(name: 'Rodney') as Route<Object?>);
          print('hello');
          break;
        default:
          // Handle other values or perform a default action
          _performDefaultAction();
          break;
      }
    } else {
      print('No data found');
    }
  }

  void _performSpecificAction() {
    // Perform a specific action, like navigating to another screen
    print('Performing specific action');
    // Navigator.pushNamed(context, '/specificRoute');
  }

  void _performDefaultAction() {
    // Perform a default action, like showing a dialog
    print('Performing default action');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Data'),
          content: Text('Data: ${result?.code}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
