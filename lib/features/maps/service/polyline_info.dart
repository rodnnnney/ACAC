import 'dart:convert';

import 'package:ACAC/common/widgets/helper_functions/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PolyInfo extends ChangeNotifier {
  Markers markerManager = Markers();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController? _controller;

  Future<String> createHttpUrl(double originLat, double originLng,
      double destinationLat, double destinationLng) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    String origin = '$originLat,$originLng';
    String destination = '$destinationLat,$destinationLng';
    String url =
        '$baseUrl?origin=$origin&destination=$destination&key=AIzaSyCw23kDf2jJs7sUILVm2vk6oIki8n8zymY';
    print(url);

    try {
      final parsedURL = Uri.parse(url);
      http.Response response = await http.get(parsedURL);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Http error: ${response.statusCode}');
      }
    } catch (e) {
      print('General error:$e');
    }
    return 'ERROR';
  }

  void processPolylineData(String jsonData) {
    var data = jsonDecode(jsonData);
    if (data['routes'] != null && data['routes'].isNotEmpty) {
      String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
      List<LatLng> polylineCoordinates = decodePolyline(encodedPolyline);
      generatePolyline(polylineCoordinates);
    } else {
      print("No routes available.");
    }
  }

  void generatePolyline(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.lightBlue,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  //Camera positioning
  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    markerManager.controller = controller;
  }

  void updateCameraBounds(List<LatLng> points) {
    if (_controller == null || points.isEmpty) return;
    LatLngBounds bounds = _boundsFromLatLngList(points);
    CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 170);
    _controller!.animateCamera(update);
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  List<LatLng> decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encoded);
    return decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  void goToNewLatLng(LatLng newLatLng) {
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 15.5));
    notifyListeners();
  }

  void addPolyLine(dynamic data) {
    if (data.containsKey('routes') && data['routes'].isNotEmpty) {
      Map<String, dynamic> firstRoute = data['routes'][0];

      String polylineData = firstRoute['overview_polyline']['points'];
      List<PointLatLng> decodedPoints =
          polylinePoints.decodePolyline(polylineData);

      print(decodedPoints.toString());
    }
  }

  void clearPoly() {
    polylines = {};
    notifyListeners();
  }
}
