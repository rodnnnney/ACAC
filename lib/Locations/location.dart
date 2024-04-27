import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  late bool servicePermission = false;
  late LocationPermission permission;

  Future<LatLng> find() async {
    try {
      if (servicePermission = true) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        return LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      // Ask for permission if denied
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('Service disabled');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }
    return LatLng(0, 0);
  }
}
