import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/routing/ui/app_bar.dart';
import 'package:ACAC/common/services/cachedRestaurantProvider.dart';
import 'package:ACAC/common/services/route_observer.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/common/widgets/helper_functions/markers.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/features/maps/helper_widgets/info_card.dart';
import 'package:ACAC/features/maps/helper_widgets/swipe_up_menu.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;

import 'service/polyline_info.dart';

class MapScreen extends ConsumerStatefulWidget {
  static String id = 'Map_Screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with RouteAware {
  Markers markerManager = Markers();
  bool isLocationLoaded = false;
  UserLocation location = UserLocation();
  late LatLng userPosition;
  LatLng? restPosition;
  GoogleMapController? _controller;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    ref.read(userPageCounter).setCounter(2);
  }

  Future<void> _initializeLocation() async {
    try {
      LatLng userLocation = await location.find();
      if (mounted) {
        setState(() {
          isLocationLoaded = true;
          userPosition = userLocation;
        });
      }
      await _initializeMarkers();
      print('Location and markers initialized');
    } catch (e) {
      print('Error initializing location: $e');
      // Handle the error appropriately
    }
  }

  Future<void> _initializeMarkers() async {
    final restaurantInfoAsync = ref.read(cachedRestaurantInfoCardListProvider);
    restaurantInfoAsync.when(
      data: (allInfoLoaded) async {
        Set<Marker> newMarkers = {};
        for (RestaurantInfoCard rest in allInfoLoaded) {
          final marker = Marker(
            infoWindow: InfoWindow(
                title: rest.restaurantName, snippet: rest.restaurantName),
            markerId: MarkerId(rest.restaurantName),
            position: LatLng(double.parse(rest.location.latitude),
                double.parse(rest.location.longitude)),
          );
          newMarkers.add(marker);
        }

        newMarkers.add(
          Marker(
            markerId: const MarkerId('User'),
            position: userPosition,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(
                title: 'Current location!',
                snippet: 'This is where you are right now!'),
          ),
        );

        setState(() {
          markers = newMarkers;
        });
      },
      loading: () => print('Loading restaurant info...'),
      error: (error, stack) => print('Error loading restaurant info: $error'),
    );
  }

  Future<void> setMapStyle() async {
    if (_controller != null) {
      String style = await rootBundle.loadString('assets/map_style_dark.json');
      _controller!.setMapStyle(ref.watch(darkLight).theme ? style : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLocationLoaded
          ? buildMap()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildMap() {
    const String id = 'Map_Screen';
    PolyInfo maps = legacy_provider.Provider.of<PolyInfo>(context);
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CenterNavWidget(
        ref: ref,
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              maps.onMapCreated(controller);
              _controller = controller;
              setMapStyle();
            },
            initialCameraPosition: CameraPosition(
              target: userPosition,
              zoom: 11,
            ),
            myLocationButtonEnabled: false,
            markers: markers,
            polylines: Set<Polyline>.of(maps.polylines.values),
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
          ),
          Positioned(
            top: screenSize.height * 0.70,
            left: screenSize.width * 0.05,
            right: screenSize.width * 0.05,
            child: const InfoCard(),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => SwipeUpMenu(
                  userLocation: userPosition,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ref.watch(darkLight).theme
                      ? const Color(0xff402C7D)
                      : Colors.orangeAccent,
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: AppBarBottom(id: id),
    );
  }
}
