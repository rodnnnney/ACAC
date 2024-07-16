import 'package:ACAC/domain_layer/service/restaurant_info_card.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final restaurantInfoCardRepositoryProvider =
    Provider<RestaurantInfoCardRepository>((ref) {
  final restaurantInfoCardAPIService =
      ref.read(restaurantInfoCardAPIServiceProvider);
  return RestaurantInfoCardRepository(restaurantInfoCardAPIService);
});

class RestaurantInfoCardRepository {
  RestaurantInfoCardRepository(this.restaurantInfoCardAPIService);

  final RestaurantInfoCardAPIService restaurantInfoCardAPIService;

  Future<List<RestaurantInfoCard>> getRestaurants() {
    return restaurantInfoCardAPIService.getRestaurants();
  }

  Future<RestaurantInfoCard> getRestaurant(String restaurantId) {
    return restaurantInfoCardAPIService.getRestaurantInfoCard(restaurantId);
  }

  Future<void> add(RestaurantInfoCard restaurant) async {
    return restaurantInfoCardAPIService.addRestaurantInfoCard(restaurant);
  }

// Future<void> delete(Restaurant deletedRestaurant) async {
//   return restaurantInfoCardAPIService.deleteRestaurant(deletedRestaurant);
// }
}
