//class Weather {
//  final List<HourlyWeather> list;
//
//  Weather({this.list});
//
//  factory Weather.fromJson(Map<String, dynamic> json) {
//    List<HourlyWeather> list = List();
//    for (var jsonMap in json['list']) {
//      list.add(HourlyWeather.fromJson(jsonMap));
//    }
//    return Weather(
//        list: list
//    );
//  }
//}

// TODO remove?
//class City {
//  final int id;
//  final String name;
//  final String country;
//  final double lat;
//  final double lon;
//  final double message;
//
//  City({this.id, this.name, this.country, this.lat, this.lon, this.message});
//
//  factory City.fromJson(Map<String, dynamic> json) {
//    return City(
//      id: json['id'],
//      name: json['name'],
//      country: json['country'],
//      lat: json['coord']['lat'],
//      lon: json['coord']['lon'],
//      message: json['message'],
//    );
//  }
//}


class Wind {
  final num degrees;
  final num speed;

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
  final num grndLevel;
  final num humidity;
  final num pressure;
  final num seaLevel;
  final num temp;
  final num tempKf;
  final num tempMax;
  final num tempMin;

  Stats({this.wind, this.grndLevel, this.humidity, this.pressure, this.seaLevel, this.temp, this.tempKf, this.tempMax, this.tempMin});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      wind: Wind.fromJson(json['wind']),
      grndLevel: json['main']['grnd_level'],
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      seaLevel: json['main']['sea_level'],
      temp: json['main']['temp'],
      tempKf: json['main']['temp_kf'],
      tempMax: json['main']['temp_max'],
      tempMin: json['main']['temp_min'],
    );
  }
}
