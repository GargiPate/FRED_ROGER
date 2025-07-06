import 'package:location/location.dart';

class LocationService {
  static Future<String> getCoordinates() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return 'Location not available';
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return 'Permission denied';
      }
    }

    final userLocation = await location.getLocation();
    return 'Latitude: ${userLocation.latitude}, Longitude: ${userLocation.longitude}';
  }
}
