import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantCardView extends ConsumerStatefulWidget {
  const RestaurantCardView({super.key});

  @override
  ConsumerState<RestaurantCardView> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<RestaurantCardView> {
  @override
  Widget build(BuildContext context) {
    var test = ref.watch(restaurantInfoCardListProvider);

    return test.when(
      data: (marketingCardList) {
        marketingCardList.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return a.createdAt!
              .getDateTimeInUtc()
              .compareTo(b.createdAt!.getDateTimeInUtc());
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('Marketing Cards'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 600,
                    child: ListView.builder(
                      itemCount: marketingCardList.length,
                      itemBuilder: (context, index) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    marketingCardList[index]
                                                        .imageLogo),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                marketingCardList[index]
                                                    .restaurantName,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child:
                                                const Icon(Icons.edit_outlined),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                            ),
                                          )
                                        ],
                                      )
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
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
