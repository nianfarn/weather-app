import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../model/view/weather.dart';
import '../service/weather_db.dart' as db;

const String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
const String apiKey = '13c3e33f00d3cdd37c4d586f49527f4f';

Future<List<HourWeather>> localWeather(Future<Position> currentLocation) async {
  var location = await currentLocation;
  return _weatherByLonLat(location.longitude, location.latitude);
}

Future<List<HourWeather>> _weatherByLonLat(double lon, double lat) async {
  var response;

  try {
     response = await http.get('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
  } catch (e) {
    return lastWeather();
  }

  var weather = _weatherFrom(response);
  db.updateLastWeather(weather);
  return weather;
}

Future<List<HourWeather>> lastWeather() async {
  var list = await db.lastWeather();
  if (list.isEmpty) {
     throw DataException.noInitialWeather();
  }
  return await db.lastWeather();
}

List<HourWeather> _weatherFrom(http.Response response) {
  if (response.statusCode == 200) {
    var map = json.decode(response.body);
    return HourWeather.listFromMap(map);
  } else {
    throw Exception('Failed to load weather');
  }
}

class DataException implements Exception {

  final String message;

  DataException(this.message);

  factory DataException.noInitialWeather() {
    return DataException('Missing any past results. Enable internet connection');
  }
}
