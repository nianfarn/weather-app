import 'package:collection/collection.dart';

class ForecastWeatherView {
  final String day;
  final List<HourWeather> list;

  ForecastWeatherView({this.day, this.list});

  void addHourWeatherData(HourWeather data) {
    list.add(data);
  }
}

class HourWeather {
  final DateTime date;
  final String iconCode;
  final String text;
  final num degrees;

  HourWeather({this.date, this.iconCode, this.text, this.degrees});

  factory HourWeather.fromMap(Map<String, dynamic> map) {
    return HourWeather(
      date: DateTime.parse(map['dt_txt']),
      text: map['text'],
      iconCode: map['iconCode'],
      degrees: map['degrees'],
    );
  }

  factory HourWeather.fromJsonMap(Map<String, dynamic> map) {
    return HourWeather(
      date: DateTime.parse(map['dt_txt']),
      text: map['weather'][0]['main'],
      iconCode: map['weather'][0]['icon'],
      degrees: map['main']['temp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': date.toUtc().toIso8601String(),
      'iconCode': iconCode,
      'text': text,
      'degrees': degrees,
    };
  }

  static List<HourWeather> listFromMap(Map<String, dynamic> map) {
    List<dynamic> list = map['list'];
    var retVal = list.map((elem) {
      return HourWeather.fromJsonMap(elem);
    }).toList();
    return retVal;
  }
}
