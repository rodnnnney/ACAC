import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/features/admin/helper_ui/utils.dart';
import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:ACAC/models/Restaurant.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class CostBreakdown extends ConsumerStatefulWidget {
  const CostBreakdown(
      {super.key,
      required this.restList,
      required this.timePeriod,
      required this.type});

  final List<Restaurant> restList;
  final TimePeriod timePeriod;
  final String type;

  @override
  ConsumerState<CostBreakdown> createState() => _HistoryState();
}

late String distance;
UserLocation location = UserLocation();
List<RestaurantInfoCard> allInfoCards = [];
final formatCurrency = NumberFormat("#,##0.00", "en_US");

class _HistoryState extends ConsumerState<CostBreakdown> {
  late List<Restaurant> filteredRestList;
  late Map<String, double> revenueMap;

  @override
  void initState() {
    super.initState();
    filteredRestList =
        filterRestaurantsByTimePeriod(widget.restList, widget.timePeriod);
    if (widget.type == "REST") {
      revenueMap = calculateRevenueMap(filteredRestList);
    } else {
      revenueMap = calculateUserSavings(filteredRestList);
    }
  }

  @override
  Widget build(BuildContext context) {
    var test = ref.watch(restaurantInfoCardListProvider);

    switch (test) {
      case AsyncData(value: final allInfoLoaded):
        for (var data in allInfoLoaded) {
          allInfoCards.add(data);
        }
    }

    filteredRestList.sort((a, b) => (revenueMap[b.restaurant] ?? 0)
        .compareTo(revenueMap[a.restaurant] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakdown'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filteredRestList.length,
                itemBuilder: (context, index) {
                  Restaurant restaurant = filteredRestList[index];
                  RestaurantInfoCard card =
                      getInfo(allInfoCards, restaurant.restaurant);
                  final timesVisited = filteredRestList
                      .where((r) => r.restaurant == restaurant.restaurant)
                      .length;
                  final revGenerated = revenueMap[restaurant.restaurant];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              card.imageLogo),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card.restaurantName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Times Visited: ${timesVisited.toString()}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "+ \$${revGenerated?.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: AppTheme.kGreen2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}
