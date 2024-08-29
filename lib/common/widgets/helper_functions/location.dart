import 'package:ACAC/common/consts/globals.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation {
  Future<LocationStatus> checkLocationStatus() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.serviceDisabled;
    }

    permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationStatus.permissionDenied;
      }
    }
    if (permission == LocationPermission.whileInUse) {
      return LocationStatus.other;
    }

    if (permission == LocationPermission.deniedForever) {
      safePrint(LocationStatus.values[1]);
      return LocationStatus.values[1];
    }

    return LocationStatus.enabled;
  }

  Future<LatLng> find() async {
    try {
      LocationStatus status = await checkLocationStatus();
      // Use user's location or AppTheme.backUpLocation (Carleton University)
      switch (status) {
        case LocationStatus.enabled:
          safePrint('Location services are good to go!(pog).');
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium);
          return LatLng(position.latitude, position.longitude);
        case LocationStatus.serviceDisabled:
          safePrint('Location services are disabled.');
          return AppTheme.backUpLocation;
        case LocationStatus.permissionDenied:
          safePrint('Location permissions are denied.');
          return AppTheme.backUpLocation;
        case LocationStatus.permissionDeniedForever:
          safePrint('Location permissions are permanently denied.');
          return AppTheme.backUpLocation;
        default:
          //Odd edge case when you set simulator location to none, it says
          // while in use instead of none
          safePrint('Location permissions are permanently denied.');
          try {
            Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium)
                .timeout(const Duration(seconds: 5));
            return LatLng(position.latitude, position.longitude);
          } catch (e) {
            safePrint(e);
            return AppTheme.backUpLocation;
          }
      }
    } catch (e) {
      safePrint('An error occurred: $e');
      return AppTheme.backUpLocation;
    }
  }
}

enum LocationStatus {
  enabled,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  other
}
