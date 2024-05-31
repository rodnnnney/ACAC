import 'package:acacmobile/domain_layer/repository_interface/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userLocationProvider = FutureProvider<LatLng>(
  (ref) async {
    try {
      bool servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('Location services are disabled.');
        return const LatLng(0, 0);
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LatLng(0, 0);
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('An error occurred: $e');
      return const LatLng(0, 0);
    }
  },
);

final userLocationProvider1 = FutureProvider<LatLng>((ref) async {
  UserLocation location = UserLocation();
  return await location.find();
});
