import 'package:flutter/material.dart';
import 'package:weather_app/model/view/weather.dart';
import 'package:weather_app/service/resource.dart';

import '../styles.dart';

class HomePage extends StatelessWidget {

  final Future<List<HourWeather>> weather;

  final String city;

  const HomePage({Key key, this.weather, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder(
        future: weather,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Weather status as icon.
                SizedBox(
                    height: 300,
                    width: 300,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: snapshot.hasData
                            ? _currentWeatherIcon(snapshot.data)
                            : Container(),
                    )
                ),
                // Location.
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: snapshot.hasData
                          ? Text('$city | ${currentDegrees(snapshot.data)}°',
                            style: AppStyles.homeLargeTextStyle()
                      )
                          : Container()
                  ),
                ),
                // Temperature and weather as text.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: _borderSide(),
                            bottom: _borderSide()
                        )
                    ),
                    child: snapshot.hasData
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: currentStats(snapshot.data)
                    )
                        : Container(),
                    ),
                  ),
                ShareButton()
              ],
            );
          }
      ),
    );
  }

  BorderSide _borderSide() {
    return const BorderSide(
        color: Colors.black12,
        width: 3
    );
  }

  Widget _currentWeatherIcon(List<HourWeather> hourList) {
    return weatherIcon(hourList[0].iconCode);
  }

  List<Widget> currentStats(List<HourWeather> hourList) {
    var current = hourList[0];
    return [
      WeatherParam(weatherIcon('humidity'), '${current.humidity}%'),
      WeatherParam(weatherIcon('clouds'), '${current.clouds}%'),
      WeatherParam(weatherIcon('rain'), '${current.rain} mm'),
      WeatherParam(weatherIcon('wind'), '${current.wind} km/h'),
      WeatherParam(weatherIcon('pressure'), '${current.pressure} hPa'),
    ];
  }

  String currentDegrees(List<HourWeather> hourList) {
    return hourList[0].degrees.toStringAsFixed(1);
  }
}

class WeatherParam extends StatelessWidget {
  final Image icon;
  final String text;

  WeatherParam(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: icon,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Share', style: AppStyles.homeLargeTextStyle().copyWith(color: Colors.orange)),
    );
  }
}

