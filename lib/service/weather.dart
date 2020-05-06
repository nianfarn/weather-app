import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/view/weather.dart';
import '../model/json/weather.dart';
import '../service/db.dart' as db;

// TODO replace to configs
const String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
const String apiKey = '13c3e33f00d3cdd37c4d586f49527f4f';

Future<List<HourWeather>> weatherByLonLat(double lon, double lat) async {
  final response = await http.get('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey');
  List<HourWeather> weather = _weatherFrom(response);
  db.updateLastWeather(weather);
  return weather;
}

Future<List<HourWeather>> lastWeather() async {
  return await db.lastWeather();
}

List<HourWeather> _weatherFrom(http.Response response) {
  if (response.statusCode == 200) {
    var map = json.decode(response.body);
    var retVal = HourWeather.listFromMap(map);
    return retVal;
  } else {
    throw Exception('Failed to load weather');
  }
}
