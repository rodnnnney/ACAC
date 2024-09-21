import 'dart:async';

import 'package:ACAC/features/home/data/marketingcard_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marketing_card_controller.g.dart';

@riverpod
class MarketingCardController extends _$MarketingCardController {
  Future<List<MarketingCard>> _fetchMarketingCards() async {
    final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
    final marketingCards = await marketingCardRepository.getMarketingCards();
    return marketingCards;
  }

  @override
  FutureOr<List<MarketingCard>> build() async {
    state = const AsyncValue.loading();
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
      descriptionText: descriptionText,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
      await marketingCardRepository.addMarketingCard(marketingCard);
      return _fetchMarketingCards();
    });
  }

  Future<void> delete(MarketingCard card) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
      await marketingCardRepository.deleteMarketingCard(card);
      return _fetchMarketingCards();
    });
  }

  Future<void> edit(MarketingCard updatedCard) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
      await marketingCardRepository.editMarketingCard(updatedCard);
      return _fetchMarketingCards();
    });
  }
}
