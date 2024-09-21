import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardRestInfoCard extends StatelessWidget {
  const CardRestInfoCard({
    super.key,
    required this.place,
  });

  final RestaurantInfoCard place;

  @override
  Widget build(BuildContext context) {
    bool descriptionText = place.discountDescription.isNotEmpty;
    bool isPercentage = place.discountPercent != '0';
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  minRadius: 18,
                  maxRadius: 24,
                  backgroundImage: CachedNetworkImageProvider(place.imageLogo),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Keep everything else aligned to the start
                  children: [
                    const Text(
                      'ACAC Discount',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text('Valid until 08/31/2025'),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Container(
                  width: 0.5,
                  height: 48,
                  color: Colors.black,
                ),
                isPercentage
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${place.discountPercent}%',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffE68437)),
                          ),
                          const Text(
                            'OFF',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xffE68437),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xffE68437),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            descriptionText
                ? Column(
                    children: [
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.center, // Center the discount text
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  0.8), // Set max width
                          child: Text(
                            place.discountDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // Handle overflow
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.withOpacity(0.9),
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
