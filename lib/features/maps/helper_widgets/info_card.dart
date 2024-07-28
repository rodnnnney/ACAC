import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/features/maps/service/navigation_info_provider.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Positioned(
      top: screenSize.height * 0.70,
      left: screenSize.width * 0.05,
      right: screenSize.width * 0.05,
      child: Consumer3<RestaurantInfo, PolyInfo, NavInfo>(
        builder: (context, data, maps, nav, child) {
          if (nav.travelTime == null) {
            return const SizedBox.shrink();
          }
          return Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${nav.travelTime?.toStringAsFixed(0)} mins',
                        style:
                            const TextStyle(fontSize: 22, color: Colors.green),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          print('Closing navigation');
                          HapticFeedback.heavyImpact();
                          nav.closeNav();
                          maps.clearPoly();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: Color(0xffA7A6A6),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Color(0xffEEEEEE),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nav.travelKm != null
                            ? '${nav.travelKm?.toStringAsFixed(1)}km'
                            : '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        nav.eta ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
