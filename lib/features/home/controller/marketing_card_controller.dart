import 'dart:async';
import 'package:ACAC/features/home/data/marketingcard_repository.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
part 'marketing_card_controller.g.dart';

@riverpod
class MarketingCardController extends _$MarketingCardController {
  final _logger = Logger('MarketingCardController');

  Future<List<MarketingCard>> _fetchMarketingCards() async {
    try {
      _logger.info('Fetching marketing cards');
      final marketingCardRepository = ref.read(marketingCardRepositoryProvider);
      final marketingCards = await marketingCardRepository.getMarketingCards();
      _logger.info('Fetched ${marketingCards.length} marketing cards');
      return marketingCards;
    } catch (e, stackTrace) {
      _logger.severe('Error fetching marketing cards', e, stackTrace);
      rethrow;
    }
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
