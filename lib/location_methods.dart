import 'package:dart_geohash/dart_geohash.dart';
import 'package:location/location.dart';

class LocationMethods {
  static Future<String?> getGeoHash() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();

    GeoHasher geoHasher = GeoHasher();

    return geoHasher.encode(locationData.longitude!, locationData.latitude!, precision: 6);
  }
}