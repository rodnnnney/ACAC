import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/presentation_layer/pages/scanner.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscountCard extends ConsumerStatefulWidget {
  static String id = 'discount_card';

  DiscountCard(
      {required this.firstName,
      required this.lastName,
      required this.restName});

  final String firstName;
  final String lastName;
  final String restName;

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends ConsumerState<DiscountCard> {
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.65,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                      imageUrl:
                          "https://acacpicturesgenerealbucket.s3.amazonaws"
                          ".com/acac.gif",
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.fitWidth),
                ),
              ),
              Row(
                children: [
                  const Text('Card Holder:'),
                  Text(" ${widget.firstName} ${widget.lastName}")
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            minRadius: 18,
                            maxRadius: 24,
                            backgroundImage:
                                CachedNetworkImageProvider(place.imageLogo),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACAC Discount',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text('Valid until 12/12/2024')
                            ],
                          ),
                          Container(
                            width: 0.5,
                            height: 48,
                            color: Colors.black,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '10%',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffE68437)),
                              ),
                              Text(
                                'OFF',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xffE68437),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBarBottom(
        id: QRViewExample.id,
      ),
    );
  }
}
