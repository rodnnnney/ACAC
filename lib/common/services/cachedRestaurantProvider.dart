import 'dart:async';

import 'package:ACAC/features/home/controller/restaurant_info_card_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../consts/globals.dart';

final cachedRestaurantInfoCardListProvider =
    FutureProvider.autoDispose((ref) async {
  // Cancel the auto-dispose behavior
  final link = ref.keepAlive();

  // Read the original provider
  final data = await ref.watch(restaurantInfoCardListProvider.future);

  // Set up a timer to invalidate the cache after the specified duration
  final timer = Timer(GlobalTheme.cacheDuration, () {
    link.close();
  });

  // Cancel the timer if the provider is manually disposed
  ref.onDispose(() => timer.cancel());

  return data;
});
