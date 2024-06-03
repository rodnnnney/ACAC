import 'package:acacmobile/domain_layer/controller/restaurant_list_controller.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends ConsumerWidget {
  static String id = 'scanner_screen';

  Scanner({super.key});

  String email = '';
  String name = '';

  Future<void> fetchUserInfo() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        if (element.userAttributeKey.toString() == 'email') {
          email = element.value.toString();
        } else if (element.userAttributeKey.toString() == 'name') {
          name = element.value.toString();
        }
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  Future<void> sendData(WidgetRef ref, String restaurantName) async {
    try {
      await ref.watch(restaurantListControllerProvider.notifier).addRestaurant(
          user: name,
          restaurantName: restaurantName,
          email: email,
          date: DateTime.now().toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return buildScanner(context, ref);
            }
          }
        },
      ),
    );
  }

  Widget buildScanner(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Page'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates),
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            print(barcode.rawValue);
            switch (barcode.rawValue) {
              case 'kinton_ramen':
                await sendData(ref, 'kinton_ramen');
                break; //TODO Add the rest from Notion doc
            }
          }
        },
      ),
    );
  }
}
