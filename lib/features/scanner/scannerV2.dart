import 'dart:async';

import 'package:ACAC/common/widgets/ui/app_bar.dart';
import 'package:ACAC/features/scanner/test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'helper.dart';

class BarcodeScannerPageView extends StatefulWidget {
  static const String id = 'id';

  const BarcodeScannerPageView({super.key});

  @override
  State<BarcodeScannerPageView> createState() => _BarcodeScannerPageViewState();
}

class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
  );

  final PageController pageController = PageController();
  StreamSubscription<Object?>? _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleScannedBarcode);
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  void _handleScannedBarcode(BarcodeCapture barcode) {
    // Do something with the scanned barcode
    print('Scanned barcode: ${barcode.barcodes}');
    // You might want to navigate to a new screen, update state, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) async {
          // Stop the camera view for the current page,
          // and then restart the camera for the new page.
          await controller.stop();

          // When switching pages, add a delay to the next start call.
          // Otherwise the camera will start before the next page is displayed.
          await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

          if (!mounted) {
            return;
          }

          unawaited(controller.start());
        },
        children: [
          _BarcodeScannerPage(controller: controller),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    pageController.dispose();
    super.dispose();
    await controller.dispose();
  }
}

class _BarcodeScannerPage extends StatelessWidget {
  const _BarcodeScannerPage({required this.controller});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.contain,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: ScannedBarcodeLabel(barcodes: controller.barcodes),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBarBottom(
        id: BarcodeScannerPageView.id,
      ),
    );
  }
}
