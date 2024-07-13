import 'dart:async';

import 'package:ACAC/common_layer/services/route_observer.dart';
import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/common_layer/widgets/discount_card.dart';
import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/presentation_layer/pages/scanner.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

class DiscountCard extends ConsumerStatefulWidget {
  static String id = 'discount_card';

  const DiscountCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.restName,
  });

  final String firstName;
  final String lastName;
  final String restName;

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
    final restaurantProvider = ref.read(restaurant);

    restaurantCard getInfo(List<restaurantCard> infoList, String checkName) {
      for (var info in infoList) {
        if (info.awsMatch == checkName) {
          return info;
        }
      }
      throw Error();
    }

    var place = getInfo(restaurantProvider, widget.restName);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(place.restaurantName),
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
                    child: CachedNetworkImage(
                        imageUrl:
                            "https://acacpicturesgenerealbucket.s3.amazonaws"
                            ".com/acac1.gif",
                        repeat: ImageRepeat.repeat,
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Discount(place: place),
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
          id: QRViewExample.id,
        ),
      ),
    );
  }
}
