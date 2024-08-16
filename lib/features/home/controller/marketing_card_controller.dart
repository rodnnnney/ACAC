import 'dart:async';

import 'package:ACAC/features/home/data/marketingcard_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marketing_card_controller.g.dart';

@riverpod
class MarketingCardController extends _$MarketingCardController {
  final _logger = Logger('MarketingCardController');

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
    _logger.info('Adding new marketing card');
    final marketingCard = MarketingCard(
      imageUrl: imageUrl,
      headerText: headerText,
      descriptionText: descriptionText,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
      await marketingCardRepository.addMarketingCard(marketingCard);
      _logger.info('Marketing card added successfully');
      return _fetchMarketingCards();
    });
  }
}
