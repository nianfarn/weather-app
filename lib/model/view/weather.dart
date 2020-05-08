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
  final num wind;
  final num rain;
  final int pressure;
  final int humidity;
  final num feelsLike;
  final int clouds;

  HourWeather({this.date, this.iconCode, this.text, this.degrees, this.wind,
    this.rain, this.pressure, this.humidity, this.feelsLike, this.clouds});

  factory HourWeather.fromDB(Map<String, dynamic> map) {
    return HourWeather(
      date: DateTime.parse(map['dt_txt']),
      text: map['text'],
      iconCode: map['iconCode'],
      degrees: map['degrees'],
      wind: map['wind'],
      rain: map['rain'],
      pressure: map['pressure'],
      humidity: map['humidity'],
      feelsLike: map['feelsLike'],
      clouds: map['clouds'],
    );
  }

  factory HourWeather.fromJsonMap(Map<String, dynamic> map) {
    return HourWeather(
      date: DateTime.parse(map['dt_txt']),
      text: map['weather'][0]['main'],
      iconCode: map['weather'][0]['icon'],
      degrees: map['main']['temp'],
      wind: map['wind']['speed'],
      rain: map['rain'] != null ? map['rain']['3h'] : 0,
      pressure: map['main']['pressure'],
      humidity: map['main']['humidity'],
      feelsLike: map['main']['feels_like'],
      clouds: map['clouds']['all'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': date.toUtc().toIso8601String(),
      'iconCode': iconCode,
      'text': text,
      'degrees': degrees,
      'wind': wind,
      'rain': rain,
      'pressure': pressure,
      'humidity': humidity,
      'feelsLike': feelsLike,
      'clouds': clouds,
    };
  }

  static List<HourWeather> listFromMap(Map<String, dynamic> map) {
    List<dynamic> list = map['list'];
    var retVal = list
        .map((elem) => HourWeather.fromJsonMap(elem))
        .toList();
    return retVal;
  }
}
