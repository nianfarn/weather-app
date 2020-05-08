import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const lastCityKey = 'last_city';

Future<String> currentCity() async {
  var city;

  try {
    final position = await currentLocation();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    city = addresses.first.locality;
  } catch (e) {
    return savedCity();
  }

  _saveLastCity(city);
  return city;
}

Future<String> savedCity() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(lastCityKey) ?? '';
}

_saveLastCity(String city) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(lastCityKey, city);
}

Future<Position> currentLocation() {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  return geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

Future<Position> lastKnownPosition() {
  return Geolocator().getLastKnownPosition();
}