import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
const String apiKey = '13c3e33f00d3cdd37c4d586f49527f4f';

Future<Weather> weatherByCityName(String q) async {
  final response = await http.get('$baseUrl?q=$q&appid=$apiKey');

  if (response.statusCode == 200) {
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load weather');
  }
}

class Weather {
  final City city;
  final List<HourlyWeather> list;

  Weather({this.city, this.list});

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<HourlyWeather> list = List();
    for (var jsonMap in json['list']) {
      list.add(HourlyWeather.fromJson(jsonMap));
    }
    return Weather(
      city: City.fromJson(json['city']),
      list: list
    );
  }
}

class City {
  final int id;
  final String name;
  final String country;
  final double lat;
  final double lon;
  final double message;

  City({this.id, this.name, this.country, this.lat, this.lon, this.message});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        id: json['id'],
        name: json['name'],
        country: json['country'],
        lat: json['coord']['lat'],
        lon: json['coord']['lon'],
        message: json['message'],
    );
  }
}

class HourlyWeather {
  final Stats stats;
  final DateTime time;
  final String description;
  final String icon;

  HourlyWeather({this.stats, this.time, this.description, this.icon});

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
        stats: Stats.fromJson(json),
        time: DateTime.parse(json['dt_txt']),
        description: json['weather'][0]['description'],
        icon: json['weather'][0]['icon']
    );
  }
}

class Wind {
  final double degrees;
  final double speed;

  Wind({this.degrees, this.speed});

  factory Wind .fromJson(Map<String, dynamic> json) {
    return Wind(
      degrees: json['degrees'],
      speed: json['speed']
    );
  }
}

class Stats {
  final Wind wind;
  final num grnd_level;
  final num humidity;
  final num pressure;
  final num sea_level;
  final num temp;
  final num temp_kf;
  final num temp_max;
  final num temp_min;

  Stats({this.wind, this.grnd_level, this.humidity, this.pressure, this.sea_level, this.temp, this.temp_kf, this.temp_max, this.temp_min});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      wind: Wind.fromJson(json['wind']),
      grnd_level: json['main']['grnd_level'],
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      sea_level: json['main']['sea_level'],
      temp: json['main']['temp'],
      temp_kf: json['main']['temp_kf'],
      temp_max: json['main']['temp_max'],
      temp_min: json['main']['temp_min'],
    );
  }
}

