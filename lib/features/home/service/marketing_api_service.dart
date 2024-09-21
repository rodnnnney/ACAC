import 'package:ACAC/models/MarketingCard.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final marketingAPIServiceProvider = Provider<MarketingApiService>((ref) {
  final marketingService = MarketingApiService();
  return marketingService;
});

class MarketingApiService {
  MarketingApiService();

  Future<List<MarketingCard>> getMarketingCards() async {
    try {
      final request = ModelQueries.list(MarketingCard.classType,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API.query(request: request).response;

      final marketingCardList = response.data?.items;
      if (marketingCardList == null) {
        safePrint('getSpaces errors: ${response.errors}');
        return const [];
      }

      return marketingCardList.map((e) => e as MarketingCard).toList();
    } on Exception catch (error) {
      safePrint('getSpaces failed: $error');

      return const [];
    }
  }

  Future<void> deleteMarketingCard(MarketingCard marketingCard) async {
    try {
      var result = await Amplify.API
          .mutate(
            request: ModelMutations.delete(marketingCard,
                authorizationMode: APIAuthorizationType.apiKey),
          )
          .response;
      safePrint(result);
    } on Exception catch (error) {
      safePrint('Delete marketing card failed: $error');
    }
  }

  Future<void> addMarketingCard(MarketingCard marketingCard) async {
    try {
      final request = ModelMutations.create(marketingCard);
      final response = await Amplify.API.mutate(request: request).response;

      final createRestaurantPing = response.data;
      if (createRestaurantPing == null) {
        safePrint('Add Marketing Card errors: ${response.errors}');
        return;
      }
    } on Exception catch (error) {
      safePrint('Add Marketing Card failed: $error');
    }
  }

  Future<void> editMarketingCard(MarketingCard updatedMarketingCard) async {
    try {
      final request = ModelMutations.update(updatedMarketingCard,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API.mutate(request: request).response;

      final updatedCard = response.data;
      if (updatedCard == null) {
        safePrint('Edit Marketing Card errors: ${response.errors}');
        return;
      }
      safePrint('Successfully updated Marketing Card: ${updatedCard.id}');
    } on ApiException catch (e) {
      safePrint('Edit Marketing Card failed: $e');
    }
  }
}
