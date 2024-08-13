import 'package:ACAC/common/widgets/ui/loading.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/features/home/controller/restaurant_list_controller.dart';
import 'package:ACAC/features/home/service/user_api_service.dart';
import 'package:ACAC/features/scanner/helper_widget/discount_card.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends ConsumerStatefulWidget {
  const ScannedBarcodeLabel({
    Key? key,
    required this.barcodes,
  }) : super(key: key);

  final Stream<BarcodeCapture> barcodes;

  @override
  ConsumerState<ScannedBarcodeLabel> createState() =>
      _ScannedBarcodeLabelState();
}

class _ScannedBarcodeLabelState extends ConsumerState<ScannedBarcodeLabel> {
  Loading loading = Loading();
  User? user;
  List<RestaurantInfoCard> allInfoCards = [];
  Set<String> processedBarcodes = {};

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      User newUser =
          await ref.read(userAPIServiceProvider).getUser(currentUser.userId);

      setState(() {
        user = newUser;
      });
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  Future<void> sendData(RestaurantInfoCard scannedRestaurant) async {
    await ref
        .read(restaurantInfoCardListProvider.notifier)
        .updateRestInfo(scannedRestaurant);
    await ref.read(restaurantListControllerProvider.notifier).addRestaurant(
          restaurantName: scannedRestaurant.restaurantName,
          email: user?.email ?? '',
          userFirstName: user?.firstName ?? '',
          userLastName: user?.lastName ?? '',
        );
    if (mounted) {
      // Check if the widget is still in the tree
      handleScan(
          scannedRestaurant, user?.firstName ?? '', user?.lastName ?? '');
    }
  }

  void handleScan(
      RestaurantInfoCard restName, String firstName, String lastName) {
    HapticFeedback.heavyImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountCard(
          firstName: firstName,
          lastName: lastName,
          restaurantInfoCard: restName,
        ),
      ),
    );
    const ResponsePopUp(
      response: 'QR scanned successfully',
      location: DelightSnackbarPosition.top,
      icon: Icons.check_circle,
      color: Colors.green,
    ).showToast(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.barcodes,
      builder: (context, AsyncSnapshot<BarcodeCapture> snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];
        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        final currentBarcode = scannedBarcodes.first.displayValue ?? '';
        if (!processedBarcodes.contains(currentBarcode)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            processBarcodeAfterBuild(currentBarcode);
          });
        }

        return const Text(
          'Processing scan...',
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  Future<void> processBarcodeAfterBuild(String currentBarcode) async {
    if (processedBarcodes.contains(currentBarcode)) return;

    setState(() {
      processedBarcodes.add(currentBarcode);
    });
    var test = ref.watch(restaurantInfoCardListProvider);
    switch (test) {
      case AsyncData(value: final allInfoLoaded):
        setState(() {
          allInfoCards = allInfoLoaded;
        });
    }

    var matchingCard = allInfoCards.firstWhere(
      (card) => card.scannerDataMatch == currentBarcode,
    );

    if (matchingCard != null) {
      await sendData(matchingCard);
    }
  }
}
