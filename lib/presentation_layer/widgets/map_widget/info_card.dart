import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InfoCard extends StatelessWidget {
  final double? travelTime;

  const InfoCard(this.travelTime, {super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //PolyInfo maps = Provider.of<PolyInfo>(context);
    return Padding(
      padding: EdgeInsets.only(
          top: screenSize.height * 0.70, left: screenSize.width * 0.05),
      child: Consumer3<RestaurantInfo, PolyInfo, NavInfo>(
        builder: (context, data, maps, nav, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: travelTime == null
                ? null
                : Card(
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
                                '${travelTime?.toStringAsFixed(0)} mins',
                                style: const TextStyle(
                                    fontSize: 22, color: Colors.green),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  nav.closeNav();
                                  maps.clearPoly();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      color: Color(0xffA7A6A6)), //
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                nav.eta.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
