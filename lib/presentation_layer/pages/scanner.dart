import 'package:acacmobile/presentation_layer/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatelessWidget {
  static String id = 'scanner_screen';

  const Scanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Page'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          var data = capture.raw;
          for (final barcode in barcodes) {
            if (barcode.rawValue == 'ISB5K3X1ZOHNSREWQVPEVSUABC6HGAGOGWDI') {
              Navigator.pushNamed(context, HomePage.id);
            } // TODO design some qr codes for each restaurant
          } // TODO pass in user's name and other info about restaurant.
        }, // TODO should not be too hard to implement
      ),
    );
  }
}
