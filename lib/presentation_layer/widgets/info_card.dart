import 'package:acacmobile/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:acacmobile/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class infoCard extends StatelessWidget {
  double? travelTime;

  infoCard(this.travelTime, {super.key});

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
                          Text(
                            '${travelTime?.toStringAsFixed(0)} mins',
                            style: const TextStyle(
                                fontSize: 22, color: Colors.green),
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
                          TextButton(
                            onPressed: () {
                              nav.closeNav();
                              maps.clearPoly();
                            },
                            child: const Text('End Navigation'),
                          )
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
