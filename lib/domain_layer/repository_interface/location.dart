import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation {
  late bool servicePermission;
  late LocationPermission permission;

  UserLocation() {
    servicePermission = false;
    permission = LocationPermission.denied;
  }

  Future<LatLng> find() async {
    try {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('Location services are disabled.');
        return const LatLng(0, 0);
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LatLng(0, 0);
        }
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('An error occurred: $e');
      return const LatLng(0, 0);
    }
  }
}
