import 'package:geolocator/geolocator.dart';

Future<Position> currentLocation() {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  return geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

Future<Position> lastKnownPosition() {
  return Geolocator().getLastKnownPosition();
}