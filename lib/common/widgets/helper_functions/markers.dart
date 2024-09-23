import 'dart:ui' as ui;

import 'package:ACAC/common/services/cachedRestaurantProvider.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as old;

class Markers {
  late final LatLng userLocation = const LatLng(0, 0);
  late GoogleMapController controller;
  UserLocation location = UserLocation();
  final container = ProviderContainer();
  final Set<Marker> markerList = {};
  Set<Marker> get marker => markerList;
  void getUserLocation() {}

  void initializeUserLocation(LatLng userLocation) async {
    markerList.add(
      Marker(
        markerId: const MarkerId('User'),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
            title: 'Current location!',
            snippet: 'This is where you are right now!'),
      ),
    );
  }

  Future<void> initializeMarkers(BuildContext context) async {
    final restaurantInfoAsync =
        container.read(cachedRestaurantInfoCardListProvider);

    restaurantInfoAsync.when(
      data: (allInfoLoaded) async {
        for (RestaurantInfoCard rest in allInfoLoaded) {
          final marker = Marker(
            infoWindow: InfoWindow(
                title: rest.restaurantName, snippet: rest.restaurantName),
            markerId: MarkerId(rest.restaurantName),
            position: LatLng(double.parse(rest.location.latitude),
                double.parse(rest.location.longitude)),
          );
          markerList.add(marker);
        }
      },
      loading: () => safePrint('Loading restaurant info...'),
      error: (error, stack) =>
          safePrint('Error loading restaurant info: $error'),
    );
  }

  void goTo(BuildContext context, LatLng location) {
    old.Provider.of<PolyInfo>(context, listen: false).goToNewLatLng(location);
  }

  Future<ui.Image> getMarkerFromIcon(IconData iconData,
      {Color color = Colors.black, double size = 100}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
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
