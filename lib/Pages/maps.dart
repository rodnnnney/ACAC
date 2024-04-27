import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/Pages/Account.dart';
import 'package:googlemaptest/Pages/Home.dart';
import 'package:googlemaptest/Providers/UserInfo_Provider.dart';
import '../GoogleMaps/appBar.dart';
import '../Models+Data/Markers.dart';
import 'package:googlemaptest/GoogleMaps/swipeUpCard.dart';
import 'package:provider/provider.dart';
import '../Providers/Navigation_Info_Provider.dart';
import '../Providers/Polyline_Info.dart';
import '../Providers/Restaurant_Provider.dart';
import '../Locations/location.dart';
import '../GoogleMaps/infoCard.dart';

class MapScreen extends StatefulWidget {
  static String id = 'Map_Screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //GoogleMapController? controller;
  markers markerManager = markers();
  bool isLocationLoaded = false;
  Location location = Location();
  late LatLng userPosition;

  @override
  void initState() {
    super.initState();
    getLocation();
    markerManager.initializeMarkers(context);
  }

  void getLocation() async {
    LatLng userLocation = await location.find();
    setState(() {
      isLocationLoaded = true;
      userPosition = userLocation;
    });
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
    //Restaurant data = Provider.of(context);
    PolyInfo maps = Provider.of<PolyInfo>(context);
    NavInfo nav = Provider.of<NavInfo>(context);
    // UserInfo user = Provider.of<UserInfo>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GoogleMap(
            onMapCreated: maps.onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(45.36855573032455, -75.70277367823537),
              zoom: 13,
            ),
            myLocationButtonEnabled: false,
            markers: markerManager.marker,
            polylines: Set<Polyline>.of(maps.polylines.values),
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
