// import 'dart:io';
//
// import 'package:ACAC/restaurant_related_ui/providers/riverpod_light_dark.dart';
// import 'package:ACAC/restaurant_related_ui/services/route_observer.dart';
// import 'package:ACAC/restaurant_related_ui/widgets/ui/app_bar.dart';
// import 'package:ACAC/restaurant_related_ui/widgets/ui/loading.dart';
// import 'package:ACAC/restaurant_related_ui/widgets/ui/response_pop_up.dart';
// import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
// import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
// import 'package:ACAC/features/home/service/user_api_service.dart';
// import 'package:ACAC/features/scanner/helper_widget/discount_card.dart';
// import 'package:ACAC/models/RestaurantInfoCard.dart';
// import 'package:ACAC/models/User.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:delightful_toast/toast/utils/enums.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class QRViewExample extends ConsumerStatefulWidget {
//   static const String id = 'qr_scanner';
//   @override
//   _QRViewExampleState createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends ConsumerState<QRViewExample> with RouteAware {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
//     controller?.dispose();
//   }
//
//   @override
//   void didPopNext() {
//     ref.read(userPageCounter).setCounter(1);
//   }
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller?.resumeCamera();
//       ref.read(userPageCounter).setCounter(1);
//     }
//   }
//
//   @override
//   void initState() {
//     fetchUserInfo();

//

//

//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       _handleQRCode(scanData);
//       controller.dispose();
//     });
//   }
//

//
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: email.isEmpty && name.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : buildScanner(context),
//     );
//   }
//
//   Widget buildScanner(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Scanner'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: AppBarBottom(
//         id: QRViewExample.id,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }
// }
