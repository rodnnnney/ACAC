// import 'dart:async';
// import 'package:ACAC/common/routing/ui/app_bar.dart';
// import 'package:ACAC/features/home/home.dart';
// import 'package:ACAC/features/scanner/test.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// class BarcodeScannerPageView extends StatefulWidget {
//   static const String id = 'id';
//
//   const BarcodeScannerPageView({super.key});
//
//   @override
//   State<BarcodeScannerPageView> createState() => _BarcodeScannerPageViewState();
// }
//
// class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView>
//     with WidgetsBindingObserver {
//   final PageController pageController = PageController();
//   StreamSubscription<Object?>? _subscription;
//   bool _isScannerRunning = false;
//
//   late MobileScannerController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeController();
//   }
//
//   Future<void> _initializeController() async {
//     controller = MobileScannerController(
//       detectionSpeed: DetectionSpeed.noDuplicates,
//       facing: CameraFacing.back,
//       torchEnabled: false,
//       formats: [BarcodeFormat.qrCode],
//     );
//     await _startScanner();
//   }
//
//   Future<void> _startScanner() async {
//     if (!_isScannerRunning) {
//       try {
//         await controller.start();
//         _isScannerRunning = true;
//         unawaited(controller.start());
//         _subscription = controller.barcodes.listen((barcode) {
//           // Handle barcode
//           print('Barcode found: ${barcode.barcodes.first}');
//         });
//       } catch (e) {
//         print('Error starting scanner: $e');
//       }
//     }
//   }
//
//   Future<void> _stopScanner() async {
//     if (_isScannerRunning) {
//       await _subscription?.cancel();
//       _subscription = null;
//       unawaited(controller.stop());
//       controller.stop();
//       _isScannerRunning = false;
//     }
//   }
//
//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //   routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
//   // }
//   //
//   // @override
//   // void didPopNext() {
//   //   ref.read(userPageCounter).setCounter(0);
//   // }
//   //
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (!controller.value.isInitialized) {
//       return;
//     }
//     switch (state) {
//       case AppLifecycleState.resumed:
//         unawaited(controller.start());
//         break;
//       case AppLifecycleState.paused:
//         // _stopScanner();
//         break;
//       case AppLifecycleState.detached:
//         // _stopScanner();
//         break;
//       // _startScanner();
//
//       case AppLifecycleState.inactive:
//         //_stopScanner();
//         unawaited(_subscription?.cancel());
//         _subscription = null;
//         unawaited(controller.stop());
//         break;
//
//       default:
//         _stopScanner();
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: PageView(
//         controller: pageController,
//         onPageChanged: (index) async {
//           await _stopScanner();
//
//           // When returning to the scanner page
//           if (index == 0) {
//             // Add a delay before starting the scanner
//             await Future.delayed(const Duration(milliseconds: 500));
//             if (mounted) {
//               await _startScanner();
//             }
//           }
//         },
//         children: [
//           _BarcodeScannerPage(
//             controller: controller,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Future<void> dispose() async {
//     WidgetsBinding.instance.removeObserver(this);
//     unawaited(_subscription?.cancel());
//     _subscription = null;
//     super.dispose();
//     await controller.dispose();
//   }
// }
//
// class _BarcodeScannerPage extends ConsumerStatefulWidget {
//   const _BarcodeScannerPage({required this.controller});
//
//   final MobileScannerController controller;
//
//   @override
//   ConsumerState<_BarcodeScannerPage> createState() =>
//       _BarcodeScannerPageState();
// }
//
// class _BarcodeScannerPageState extends ConsumerState<_BarcodeScannerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: CenterNavWidget(
//         ref: ref,
//       ),
//       appBar: AppBar(
//         title: const Text('Scanner'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: widget.controller,
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, child) {
//               return ScannerErrorWidget(error: error);
//              },
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               alignment: Alignment.bottomCenter,
//               height: 100,
//               color: Colors.black.withOpacity(0.4),
//               child: Center(
//                 child:
//                 ScannedBarcodeLabel(barcodes: widget.controller.barcodes),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: AppBarBottom(
//         id: BarcodeScannerPageView.id,
//       ),
//     );
//   }
// }
