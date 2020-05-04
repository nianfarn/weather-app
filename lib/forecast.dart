import 'package:flutter/material.dart';
import 'package:weather_app/service/weather_service.dart';

class ForecastPage extends StatefulWidget {
  final String q;

  ForecastPage({this.q});

  factory ForecastPage.forCity(String q) {
    return ForecastPage(
      q: q,
    );
  }

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  Future<Weather> _weatherFuture;
  List<ForecastWeatherView> viewList;

  @override
  void initState() {
    super.initState();
    _weatherFuture = weatherByCityName(widget.q);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              viewList = _parseToView(snapshot.data);
              return ListView.builder(itemBuilder: (context, index) {
                if (index >= viewList.length) return null;
                return DailyHourWeather(
                  dayTitle: viewList[index].day,
                  list: viewList[index].list,
                );
              });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<ForecastWeatherView> _parseToView(Weather weather) {
    // TODO parse
    List<ForecastWeatherView> retList = List();
    int lastParsedDay;
    ForecastWeatherView lastParsedView;
    for (HourlyWeather hourlyWeather in weather.list) {
      if (lastParsedDay != hourlyWeather.time.day) {
        // FIXME
        var view = ForecastWeatherView(hourlyWeather.time.day.toString());
        lastParsedView = view;
        lastParsedDay = hourlyWeather.time.day;
        view.addHourWeatherData(HourWeatherView(
            degrees: hourlyWeather.stats.temp,
            icon: Icons.wb_sunny,
            text: hourlyWeather.description,
            time: hourlyWeather.time.toString()));
        retList.add(view);
      } else {
        lastParsedView.addHourWeatherData(HourWeatherView(
            degrees: hourlyWeather.stats.temp,
            icon: Icons.wb_sunny,
            text: hourlyWeather.description,
            time: hourlyWeather.time.toString()));
      }
    }
    return retList;
  }
}

class DailyHourWeather extends StatelessWidget {
  final String dayTitle;
  final List<HourWeatherView> list;

  const DailyHourWeather({this.dayTitle, this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dayTitle),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(top: _borderSide(), bottom: _borderSide())),
          child: Column(
            children: <Widget>[
              for (var item in list) HourWeatherRow(item)
            ],
          ),
        )
      ],
    );
  }

  BorderSide _borderSide() {
    return const BorderSide(color: Colors.black12, width: 1);
  }
}

class HourWeatherView {
  final String time;
  final IconData icon;
  final String text;
  final double degrees;

  HourWeatherView({this.time, this.icon, this.text, this.degrees});
}

class HourWeatherRow extends StatelessWidget {
  final HourWeatherView _data;

  HourWeatherRow(this._data);

  @override
  Widget build(BuildContext context) {
    var degrees = _data.degrees;
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              _data.icon,
              size: 60,
              color: Colors.orange,
            ),
          ),
          Column(
            children: <Widget>[Text(_data.time), Text(_data.text)],
          ),
          Expanded(child: Container()),
          Text('$degrees°')
        ],
      ),
    );
  }
}

class ForecastWeatherView {
  final String day;
  final List<HourWeatherView> list;

  ForecastWeatherView(this.day) : this.list = List();

  void addHourWeatherData(HourWeatherView data) {
    list.add(data);
  }
}
