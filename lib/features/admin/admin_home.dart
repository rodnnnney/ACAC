import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminHome extends ConsumerWidget {
  static const String id = '/Admin_home';

  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantInfoCardsAsync = ref.watch(restaurantInfoCardListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
      ),
      body: SafeArea(
        child: restaurantInfoCardsAsync.when(
          data: (restaurantInfoCards) {
            // Sort the restaurantInfoCards by timesVisited
            restaurantInfoCards
                .sort((a, b) => b.timesVisited.compareTo(a.timesVisited));

            // Calculate total visits
            final totalVisits = restaurantInfoCards.fold(
              0,
              (sum, card) => sum + card.timesVisited,
            );

            // Calculate total savings
            final totalSavings = restaurantInfoCards.fold(
              0.0,
              (sum, card) {
                final cuisineValue = int.parse(card.cuisineType.firstWhere(
                  (element) => int.tryParse(element) != null,
                ));
                return sum +
                    (card.timesVisited *
                        (cuisineValue *
                            double.parse(card.discountPercent) /
                            100));
              },
            );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '👀',
                              style: TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Total Restaurant Visits',
                              maxLines: 1,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              totalVisits.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '💸',
                              style: TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Total Estimated Savings',
                              maxLines: 1,
                              style: TextStyle(fontSize: 11),
                            ),
                            Text(
                              '\$${totalSavings.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Add any additional cards or widgets you need here
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
