import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/features/home/controller/marketing_card_controller.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'new_marketing_card.dart';

class MarketingCardsView extends ConsumerStatefulWidget {
  const MarketingCardsView({super.key});

  @override
  ConsumerState<MarketingCardsView> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<MarketingCardsView> {
  @override
  Widget build(BuildContext context) {
    var test = ref.watch(marketingCardControllerProvider);
    final marketing = ref.read(marketingCardControllerProvider.notifier);

    return test.when(
      data: (marketingCardList) {
        marketingCardList.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return a.createdAt!
              .getDateTimeInUtc()
              .compareTo(b.createdAt!.getDateTimeInUtc());
        });
        return Scaffold(
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewMarketingCard(),
                ),
              );
            },
            child: SizedBox(
              height: 60,
              width: 60,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppTheme.kGreen2,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
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
                                                        .imageUrl),
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
                                                            .headerText
                                                            .length >
                                                        15
                                                    ? '${marketingCardList[index].headerText.substring(0, 20)}...' // Cap at 15 characters
                                                    : marketingCardList[index]
                                                        .headerText,
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
                                          GestureDetector(
                                            onTap: () async {
                                              safePrint(
                                                  marketingCardList[index]);
                                              await marketing.delete(
                                                  marketingCardList[index]);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.redAccent,
                                              ),
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
