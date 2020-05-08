import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

Future<String> currentCity() async {
  final position = await currentLocation();
  final coordinates = new Coordinates(position.latitude, position.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  return addresses.first.locality;
}

Future<Position> currentLocation() {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  return geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

Future<Position> lastKnownPosition() {
  return Geolocator().getLastKnownPosition();
}