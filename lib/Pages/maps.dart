import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/GoogleMaps/swipeUpCard.dart';
import 'package:provider/provider.dart';

import '../GoogleMaps/appBar.dart';
import '../GoogleMaps/infoCard.dart';
import '../Locations/location.dart';
import '../Models+Data/Markers.dart';
import '../Providers/Navigation_Info_Provider.dart';
import '../Providers/Polyline_Info.dart';
import '../Providers/Theme.dart';

class MapScreen extends StatefulWidget {
  static String id = 'Map_Screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  markers markerManager = markers();
  bool isLocationLoaded = false;
  UserLocation location = UserLocation();
  LatLng userPosition = LatLng(0, 0);
  LatLng? restPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
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
      body: Center(
        child:
            isLocationLoaded ? buildMap() : const CircularProgressIndicator(),
      ),
    );
  }

  Widget buildMap() {
    const String id = 'Map_Screen';
    PolyInfo maps = Provider.of<PolyInfo>(context);
    NavInfo nav = Provider.of<NavInfo>(context);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);

    Future<void> _setMapStyle() async {
      if (_controller != null) {
        String style =
            await rootBundle.loadString('assets/map_style_dark.json');
        _controller!.setMapStyle(theme.isDarkMode ? style : null);
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
              _setMapStyle();
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
