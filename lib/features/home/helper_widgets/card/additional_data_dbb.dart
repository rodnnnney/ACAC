import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/common/widgets/helper_functions/phone_call.dart';
import 'package:ACAC/common/widgets/helper_functions/time_formatter.dart';
import 'package:ACAC/common/widgets/restaurant_related_ui/card_rest_info_card.dart';
import 'package:ACAC/common/widgets/ui/star_builder.dart';
import 'package:ACAC/features/maps/maps.dart';
import 'package:ACAC/features/maps/service/navigation_info_provider.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/features/user_auth/data/user_list_controller.dart';
import 'package:ACAC/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class AdditionalDataDbb extends ConsumerStatefulWidget {
  const AdditionalDataDbb(
      {super.key, required this.restaurant, required this.distance});

  final RestaurantInfoCard restaurant;
  final String distance;

  @override
  ConsumerState<AdditionalDataDbb> createState() =>
      _RestaurantAdditionalInfoState();
}

class _RestaurantAdditionalInfoState extends ConsumerState<AdditionalDataDbb> {
  LaunchLink phoneCall = LaunchLink();

  List<PropertyTag> tags = [];
  bool includedInFavourites = false;

  @override
  void initState() {
    super.initState();
    if (widget.restaurant.cuisineType != null ||
        widget.restaurant.cuisineType.isNotEmpty) {
      filterTagSetup(widget.restaurant.cuisineType);

      //isFavourite(widget.restaurant.cuisineType);
    }
  }

  void filterTagSetup(List<String> infoTag) {
    for (String filterTag in infoTag) {
      switch (filterTag.toLowerCase()) {
        case 'chinese':
          tags.add(const PropertyTag(
            tagDescription: 'Chinese 🇨🇳',
            cardColor: Colors.red,
            textColor: Colors.white,
          ));
          break;
        case 'vietnamese':
          tags.add(const PropertyTag(
            tagDescription: 'Vietnamese 🇻🇳',
            cardColor: Color(0xff7BAE7F),
            textColor: Colors.white,
          ));
          break;
        case 'japanese':
          tags.add(const PropertyTag(
            tagDescription: 'Japanese 🇯🇵',
            cardColor: Colors.transparent,
            textColor: Colors.black87,
          ));
          break;
        case 'korean':
          tags.add(const PropertyTag(
            tagDescription: 'Korean 🇰🇷',
            cardColor: Color(0xffB8E1FF),
            textColor: Colors.white,
          ));
          break;
        case 'desert':
          tags.add(const PropertyTag(
            tagDescription: 'Desert 🍦',
            cardColor: Color(0xffE5D4ED),
            textColor: Colors.white,
          ));
          break;
        case 'fried chicken':
          tags.add(const PropertyTag(
            tagDescription: 'Fried Chicken 🍗',
            cardColor: Color(0xffE3D888),
            textColor: Colors.white,
          ));
          break;
        case 'bubble tea':
          tags.add(const PropertyTag(
            tagDescription: 'Bubble Tea 🧋',
            cardColor: Color(0xff95D7AE),
            textColor: Colors.white,
          ));
          break;
        case 'noodle':
          tags.add(const PropertyTag(
            tagDescription: 'Noodles 🍜',
            cardColor: Color(0xffE2F1AF),
            textColor: Colors.black87,
          ));
          break;
        case '10':
          tags.insert(
              0,
              const PropertyTag(
                tagDescription: '\$~10💵',
                cardColor: Color(0xff7BAE7F),
                textColor: Colors.white,
              ));
          break;
        case '15':
          tags.insert(
              0,
              const PropertyTag(
                tagDescription: '\$~15💵',
                cardColor: Color(0xff7BAE7F),
                textColor: Colors.white,
              ));
          break;
        case '20':
          tags.insert(
              0,
              const PropertyTag(
                tagDescription: '\$~20💵',
                cardColor: Color(0xff7BAE7F),
                textColor: Colors.white,
              ));
          break;
        case '25':
          tags.insert(
              0,
              const PropertyTag(
                tagDescription: '\$~25💵',
                cardColor: Color(0xff7BAE7F),
                textColor: Colors.white,
              ));
      }
    }
  }

  isFavourite(List<String> infoTag) {
    if (infoTag.contains('fav')) {
      tags.insert(
          0,
          const PropertyTag(
            tagDescription: 'ACAC\'s pick ✅',
            cardColor: Color(0xff7BAE7F),
            textColor: Colors.white,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    final itemsRepository = ref.read(userRepositoryProvider);

    Future<User> getUserInfo() async {
      AuthUser userID = await Amplify.Auth.getCurrentUser();
      return await itemsRepository.getUser(userID.userId);
    }

    Widget buildLoadingWidget() {
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.white),
            Text('Add to favourite', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    void handleFavoriteToggle(bool isFavorite) async {
      HapticFeedback.heavyImpact();
      final provider = ref.read(userListControllerProvider.notifier);
      if (isFavorite) {
        await provider.removeFromFavourite(widget.restaurant.restaurantName);
      } else {
        await provider.addToFavourite(widget.restaurant.restaurantName);
      }
      setState(() {});
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24, // Size of the icon
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.restaurant.imageSrc,
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    widget.distance,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: FutureBuilder<User>(
                  future: getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildLoadingWidget();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final user = snapshot.data;
                      final isFavorite = user?.favouriteRestaurants
                              .contains(widget.restaurant.restaurantName) ??
                          false;
                      return GestureDetector(
                        onTap: () => handleFavoriteToggle(isFavorite),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.redAccent : null),
                              if (!isFavorite) ...[
                                const SizedBox(width: 5),
                                const Text('Add to favourite'),
                              ],
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.restaurantName,
                              style: const TextStyle(
                                fontFamily: 'helveticanowtext',
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(widget.restaurant.address),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                    getHoursSingle(widget.restaurant, weekday)),
                                const SizedBox(width: 7),
                                FutureBuilder<Map<String, dynamic>>(
                                  future: getCurrentStatusWithColor(
                                      getOpeningTimeSingle(
                                          weekday, widget.restaurant),
                                      getClosingTimeSingle(
                                          weekday, widget.restaurant)),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      var status = snapshot.data?['status'] ??
                                          'Unknown status';
                                      var color = snapshot.data?['color'] ??
                                          Colors.black;
                                      return Text(
                                        status,
                                        style: TextStyle(color: color),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE8E8E8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.restaurant.rating.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                buildStarRating(widget.restaurant.rating),
                                const SizedBox(
                                  width: 3,
                                ),
                              ],
                            ),
                            GestureDetector(
                              // onTap: () async {
                              //   final url =
                              //       Uri.parse(widget.restaurant.gMapsLink);
                              //   try {
                              //     if (await canLaunchUrl(url)) {
                              //       await launchUrl(url);
                              //     } else {}
                              //   } catch (e) {
                              //     //print(e);
                              //   }
                              // },
                              child: Text(
                                '${phoneCall.formatNumber(widget.restaurant.reviewNum)} + ratings',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        itemCount: tags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return tags[index];
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    CardRestInfoCard(place: widget.restaurant),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text('Most Popular'),
                      ],
                    ),
                    widget.restaurant.topRatedItemsName.isEmpty
                        ? SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: const Text('Nothing Found')),
                                        const Text(
                                          'Nothing found',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    widget.restaurant.topRatedItemsName.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(
                                                                12)),
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.restaurant
                                                          .topRatedItemsImgSrc[
                                                      index],
                                                  height: 120,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  widget.restaurant
                                                      .topRatedItemsName[index],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 14,
                                        left: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                              color: Color(0xff68ba7b),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  topRight:
                                                      Radius.circular(12))),
                                          child: Text(
                                            ' ${index + 1}# Most Popular!',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 12)),
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.green),
                              foregroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async {
                              HapticFeedback.heavyImpact();
                              if (context.mounted) {
                                Navigator.pushNamed(context, MapScreen.id);
                              }
                              ref.read(userPageCounter).setCounter(2);
                              try {
                                LatLng user = await data.getLocation();
                                String url = await maps.createHttpUrl(
                                  user.latitude,
                                  user.longitude,
                                  double.parse(
                                      widget.restaurant.location.latitude),
                                  double.parse(
                                      widget.restaurant.location.longitude),
                                );
                                nav.updateRouteDetails(url);
                                maps.processPolylineData(url);
                                maps.updateCameraBounds([
                                  user,
                                  (widget.restaurant.location as LatLng)
                                ]);
                              } catch (e) {
                                //  print(e);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Find on Map'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.location_on)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextButton(
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 12)),
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.black),
                              foregroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async {
                              phoneCall
                                  .makePhoneCall(widget.restaurant.phoneNumber);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Reserve'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.phone)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyTag extends StatelessWidget {
  const PropertyTag(
      {super.key,
      required this.tagDescription,
      required this.cardColor,
      required this.textColor});

  final String tagDescription;
  final Color cardColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Text(
            tagDescription,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          )),
    );
  }
}
