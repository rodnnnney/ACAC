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
    return Card(
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
              backgroundImage: CachedNetworkImageProvider(place.imageLogo),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACAC Discount',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('Valid until 08/31/2025')
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
    );
  }
}
