import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/domain_layer/controller/restaurant_list_controller.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends ConsumerStatefulWidget {
  static String id = 'scanner_screen';

  Scanner({super.key});

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends ConsumerState<Scanner> {
  String email = '';
  String name = '';
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller =
        MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
    fetchUserInfo();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: email.isEmpty && name.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : buildScanner(context, ref),
    );
  }

//TODO Scanner returns exclamation mark when opened and closed
  Widget buildScanner(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Scanner Page'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            print(barcode.rawValue);
            switch (barcode.rawValue) {
              case 'kinton_ramen':
                await sendData(ref, 'kinton_ramen');
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
            }
          }
        },
      ),
      bottomNavigationBar: AppBarBottom(
        id: Scanner.id,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
