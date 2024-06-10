import 'dart:ui' as ui;

import 'package:acacmobile/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:acacmobile/presentation_layer/state_management/riverpod/riverpod_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as old;

import 'location.dart';

class Markers {
  late final LatLng userLocation = const LatLng(0, 0);
  late GoogleMapController controller;
  UserLocation location = UserLocation();
  final container = ProviderContainer();
  final Set<Marker> markerList = {};
  Set<Marker> get marker => markerList;
  void getUserLocation() {}

  void initializeUserLocation(LatLng userLocation) {
    markerList.add(
      Marker(markerId: const MarkerId('User'), position: userLocation),
    );
  }

  void initializeMarkers(BuildContext context) {
    final restaurantInfo = container.read(restaurant);
    for (var rest in restaurantInfo) {
      markerList.add(
        Marker(
          infoWindow: InfoWindow(
              title: rest.restaurantName, snippet: rest.restaurantName),
          markerId: MarkerId(rest.restaurantName),
          position: rest.location,
          // icon: await getBitmapDescriptorFromIcon(
          //     await getMarkerFromIcon(Icons.location_on)),
        ),
      );
    }
  }

  void goTo(BuildContext context, LatLng location) {
    old.Provider.of<PolyInfo>(context, listen: false).goToNewLatLng(location);
  }

  // List<Cards> getList(BuildContext context) {
  //   return Provider.of<Restaurant>(context).restaurantInfo;
  // }

  Future<ui.Image> getMarkerFromIcon(IconData iconData,
      {Color color = Colors.black, double size = 100}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    //final Paint paint = Paint()..color = color;
    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
          fontSize: size,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: color),
    );
    textPainter.layout();

    textPainter.paint(canvas, Offset.zero);
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image markerAsImage = await picture.toImage(
        textPainter.width.toInt(), textPainter.height.toInt());
    return markerAsImage;
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromIcon(ui.Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(pngBytes);
  }
}
