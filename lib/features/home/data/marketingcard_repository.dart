import 'package:ACAC/features/home/service/marketing_api_service.dart';
import 'package:ACAC/models/MarketingCard.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final marketingCardRepositoryProvider =
    Provider<MarketingCardRepository>((ref) {
  final marketingCardAPIService = ref.read(marketingAPIServiceProvider);
  return MarketingCardRepository(marketingCardAPIService);
});

class MarketingCardRepository {
  MarketingCardRepository(this.restaurantAPIService);

  final MarketingApiService restaurantAPIService;

  Future<List<MarketingCard>> getMarketingCards() {
    return restaurantAPIService.getMarketingCards();
  }

  Future<void> addMarketingCard(MarketingCard marketingCard) async {
    return restaurantAPIService.addMarketingCard(marketingCard);
  }

  Future<void> deleteMarketingCard(MarketingCard marketingCard) async {
    return restaurantAPIService.deleteMarketingCard(marketingCard);
  }
}
