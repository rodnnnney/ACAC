import 'package:ACAC/common_layer/cachedRestaurantProvider.dart';
import 'package:ACAC/common_layer/services/route_observer.dart';
import 'package:ACAC/common_layer/widgets/app_bar.dart';
import 'package:ACAC/domain_layer/repository_interface/location.dart';
import 'package:ACAC/domain_layer/repository_interface/markers.dart';
import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/riverpod/riverpod_light_dark.dart';
import 'package:ACAC/presentation_layer/widgets/map_widget/info_card.dart';
import 'package:ACAC/presentation_layer/widgets/map_widget/swipe_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;

import '../../models/RestaurantInfoCard.dart';

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
    NavInfo nav = legacy_provider.Provider.of<NavInfo>(context);

    return Scaffold(
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
          InfoCard(nav.travelTime),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ref.watch(darkLight).theme
            ? const Color(0xff402C7D)
            : const Color(0xffE2F1D6),
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => SwipeUpMenu(
            userLocation: userPosition,
          ),
        ),
        child: const Icon(Icons.menu),
      ),
      bottomNavigationBar: AppBarBottom(id: id),
    );
  }
}
