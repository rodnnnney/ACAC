import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/common_layer/widgets/app_bar.dart';
import 'package:googlemaptest/domain_layer/repository_interface/location.dart';
import 'package:googlemaptest/domain_layer/repository_interface/markers.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:googlemaptest/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:googlemaptest/presentation_layer/state_management/riverpod/riverpod_test.dart';
import 'package:googlemaptest/presentation_layer/widgets/info_card.dart';
import 'package:googlemaptest/presentation_layer/widgets/swipe_up_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;

class MapScreen extends ConsumerStatefulWidget {
  static String id = 'Map_Screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  Markers markerManager = Markers();
  bool isLocationLoaded = false;
  UserLocation location = UserLocation();
  LatLng userPosition = const LatLng(0, 0);
  LatLng? restPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    LatLng userLocation = await location.find();
    setState(() {
      isLocationLoaded = true;
      userPosition = userLocation;
    });
    markerManager.initializeUserLocation(userPosition);
    markerManager.initializeMarkers(context);
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

    Future<void> setMapStyle() async {
      if (_controller != null) {
        String style =
            await rootBundle.loadString('assets/map_style_dark.json');
        _controller!.setMapStyle(ref.watch(darkLight).theme ? style : null);
      }
    }

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
            markers: markerManager.marker,
            polylines: Set<Polyline>.of(maps.polylines.values),
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
          ),
          infoCard(nav.travelTime),
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
                )),
        child: const Icon(Icons.menu),
      ),
      bottomNavigationBar: AppBarBottom(id: id),
    );
  }
}
