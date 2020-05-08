import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/view/weather.dart';
import '../service/weather_db.dart' as db;

const String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
const String apiKey = '13c3e33f00d3cdd37c4d586f49527f4f';

Future<List<HourWeather>> weatherByLonLat(double lon, double lat) async {
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
