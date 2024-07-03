import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/domain_layer/repository_interface/phone_call.dart';
import 'package:ACAC/presentation_layer/pages/scanner.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscountCard extends ConsumerStatefulWidget {
  static String id = 'discount_card';

  DiscountCard({required this.name, required this.restName});

  final String name;
  final String restName;

  LaunchLink launchLink = LaunchLink();

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends ConsumerState<DiscountCard> {
  bool _firstImage = true;

  void _switchImage() {
    setState(() {
      _firstImage = !_firstImage;
    });
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(place.restaurantName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  _switchImage();
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    key: ValueKey<bool>(_firstImage),
                    child: _firstImage
                        ? Image.asset("images/card.JPG")
                        : Image.asset("images/card1.JPG"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
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
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Questions or Concerns?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text('Reach out below(Tap) : '),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  widget.launchLink.launchURL(
                                      'https://www.instagram.com/asiancanadians_carleton/');
                                },
                                child: Image.asset(
                                  'images/ig2.png',
                                  width: 50,
                                ),
                              ),
                              const SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  widget.launchLink.launchEmail(
                                      'asiancanadianscarleton@gmail.com');
                                },
                                child: Image.asset(
                                  'images/gmail.png',
                                  width: 50,
                                ),
                              )
                            ])
                      ],
                    ),
                  )
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
