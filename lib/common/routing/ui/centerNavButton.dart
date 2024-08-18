import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/features/scanner/scannerV3.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CenterNavWidget extends StatelessWidget {
  const CenterNavWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ref.watch(userPageCounter).counter != 1) {
          ref.read(userPageCounter).setCounter(1);
          Navigator.pushNamed(context, App.id);
        }
      },
      child: SizedBox(
        width: 65,
        height: 65,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff8CC084),
            borderRadius: BorderRadius.circular(35),
          ),
          child: const FittedBox(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
