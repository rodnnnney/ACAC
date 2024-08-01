import 'dart:async';

import 'package:ACAC/features/home/data/marketingcard_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marketing_card_controller.g.dart';

@riverpod
class MarketingCardController extends _$MarketingCardController {
  Future<List<MarketingCard>> _fetchMarketingCards() async {
    final MarketingCardController = ref.read(marketingCardRepositoryProvider);
    final marketingCard = await MarketingCardController.getMarketingCards();
    return marketingCard;
  }

  @override
  FutureOr<List<MarketingCard>> build() async {
    return _fetchMarketingCards();
  }

  Future<void> addMarketingCard({
    required String imageUrl,
    required String headerText,
    required String descriptionText,
  }) async {
    final marketingCard = MarketingCard(
        imageUrl: imageUrl,
        headerText: headerText,
        descriptionText: descriptionText);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
      await marketingCardRepository.addMarketingCard(marketingCard);
      return _fetchMarketingCards();
    });
  }
}
