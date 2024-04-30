import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaptest/Models+Data/Cards.dart';
import 'package:googlemaptest/Providers/Polyline_Info.dart';
import 'package:googlemaptest/Providers/Restaurant_Provider.dart';
import 'package:provider/provider.dart';

import '../Locations/location.dart';

class markers {
  late final LatLng userLocation = LatLng(0, 0);
  late GoogleMapController controller;
  Location location = Location();

  final Set<Marker> markerList = {};
  Set<Marker> get marker => markerList;
  void getUserLocation() {}

  void initializeUserLocation(LatLng userLocation) {
    markerList.add(
      Marker(markerId: MarkerId('User'), position: userLocation),
    );
  }

  void initializeMarkers(BuildContext context) {
    markerList.add(
      Marker(
        markerId: const MarkerId('Kinton'),
        position: const LatLng(45.41913804744197, -75.6914954746089),
        onTap: () {
          goTo(context, const LatLng(45.41913804744197, -75.6914954746089));
        },
      ),
    );
    markerList.add(
      Marker(
        markerId: const MarkerId('KTV'),
        position: const LatLng(45.36855573032455, -75.70277367823537),
        onTap: () {
          goTo(context, const LatLng(45.36855573032455, -75.70277367823537));
        },
      ),
    );
    markerList.add(
      Marker(
        markerId: const MarkerId('PapaSpicy'),
        position: const LatLng(45.4278039812124, -75.69032978995092),
        onTap: () {
          goTo(context, const LatLng(45.4278039812124, -75.69032978995092));
        },
      ),
    );
    markerList.add(
      Marker(
        infoWindow: const InfoWindow(title: 'ChaTime', snippet: 'Bubble Tea'),
        markerId: const MarkerId('ChaTime(Somerset)'),
        position: const LatLng(45.411220513918316, -75.70696356085315),
        // icon: await getBitmapDescriptorFromIcon(
        //     await getMarkerFromIcon(Icons.location_on)),
        onTap: () {
          goTo(context, const LatLng(45.411220513918316, -75.70696356085315));
          const Positioned(
            top: 100,
            left: 50,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('HELLO'),
              ),
            ),
          );
        },
      ),
    );
  }

  void goTo(BuildContext context, LatLng location) {
    Provider.of<PolyInfo>(context, listen: false).goToNewLatLng(location);
  }

  List<Cards> getList(BuildContext context) {
    return Provider.of<Restaurant>(context).restaurantInfo;
  }

  Future<ui.Image> getMarkerFromIcon(IconData iconData,
      {Color color = Colors.black, double size = 100}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
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
    final Picture picture = pictureRecorder.endRecording();
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
