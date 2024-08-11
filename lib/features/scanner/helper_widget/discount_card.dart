import 'dart:async';

import 'package:ACAC/common/services/route_observer.dart';
import 'package:ACAC/common/widgets/common/card_rest_info_card.dart';
import 'package:ACAC/common/widgets/ui/app_bar.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

class DiscountCard extends ConsumerStatefulWidget {
  static String id = 'discount_card';

  const DiscountCard({
    super.key,
    required this.restaurantInfoCard,
    required this.firstName,
    required this.lastName,
  });

  final RestaurantInfoCard restaurantInfoCard;
  final String firstName;
  final String lastName;

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends ConsumerState<DiscountCard> with RouteAware {
  Future<void> preventSS() async {
    await ScreenProtector.preventScreenshotOn();
  }

  Future<void> allowSS() async {
    await ScreenProtector.preventScreenshotOff();
  }

  //Disable screenshots
  @override
  void initState() {
    super.initState();
    preventSS();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Allow screenshots to resume
  @override
  void didPushNext() {
    allowSS();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurantInfoCard.restaurantName),
          automaticallyImplyLeading:
              false, // Optional: Prevents showing the back button
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('images/acac2.png',
                        repeat: ImageRepeat.repeat, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  CardRestInfoCard(place: widget.restaurantInfoCard),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Card Holder:',
                              style: TextStyle(fontSize: 18),
                              textAlign:
                                  TextAlign.left, // Aligns the text to the left
                            ),
                            Text(
                              "${widget.firstName} ${widget.lastName}",
                              style: const TextStyle(fontSize: 32),
                              textAlign:
                                  TextAlign.left, // Aligns the text to the left
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBarBottom(
          id: '',
          // id: QRViewExample.id,
        ),
      ),
    );
  }
}
