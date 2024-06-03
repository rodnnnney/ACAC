import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeGen extends StatelessWidget {
  static String id = 'qr_code_gen';

  const QrCodeGen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: PrettyQrView.data(
              data: 'Fuwa_Fuwa',
              errorCorrectLevel: QrErrorCorrectLevel.H,
              decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                      image: AssetImage('images/acac.png'), scale: 0.25)),
            ),
          ),
        ),
      ),
    );
  }
}
