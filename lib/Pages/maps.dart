import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/GoogleMaps/appBar.dart';
import 'package:googlemaptest/GoogleMaps/infoCard.dart';
import 'package:googlemaptest/GoogleMaps/swipeUpCard.dart';
import 'package:googlemaptest/Locations/location.dart';
import 'package:googlemaptest/Models+Data/Markers.dart';
import 'package:googlemaptest/Providers/Navigation_Info_Provider.dart';
import 'package:googlemaptest/Providers/Polyline_Info.dart';
import 'package:googlemaptest/Providers/riverpod_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;

class MapScreen extends ConsumerStatefulWidget {
  static String id = 'Map_Screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  markers markerManager = markers();
  bool isLocationLoaded = false;
  UserLocation location = UserLocation();
  LatLng userPosition = const LatLng(0, 0);
  LatLng? restPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
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
      body: FutureBuilder<void>(
        future: getLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else {
            return buildMap();
          }
        },
      ),
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

//Use GoogleMap.style instead.
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
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AddTask(
                  userLocation: userPosition,
                )),
        child: const Icon(Icons.menu),
      ),
      bottomNavigationBar: AppBarBottom(id: id),
    );
  }
}
