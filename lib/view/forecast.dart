import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../service/weather.dart';
import '../model/view/weather.dart';

class ForecastPage extends StatefulWidget {
  final Position position;

  ForecastPage({this.position});

  factory ForecastPage.forPosition(Position position) {
    return ForecastPage(
      position: position,
    );
  }

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  Future<List<HourWeather>> _weatherFuture;
  List<ForecastWeatherView> viewList;

  @override
  void initState() {
    super.initState();
    _weatherFuture = weatherByLonLat(widget.position.longitude, widget.position.altitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<HourWeather>>(
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

  List<ForecastWeatherView> _parseToView(List<HourWeather> weathers) {
    weathers.sort((a, b) => a.date.compareTo(b.date));
    var map = groupBy(weathers, (elem) => DateFormat('EEEE').format(elem.date));

    List<ForecastWeatherView> list = [];
    map.forEach((k, v) => list.add(ForecastWeatherView(day: k, list: v)));
    return list;
  }
}

class DailyHourWeather extends StatelessWidget {
  final String dayTitle;
  final List<HourWeather> list;

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

class HourWeatherRow extends StatelessWidget {
  final HourWeather _data;

  HourWeatherRow(this._data);

  @override
  Widget build(BuildContext context) {
    var degrees = _data.degrees;
    var iconCode = _data.iconCode;
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image(
              image: AssetImage('assets/icons/$iconCode.png'),
              height: 60,
              width: 60,
            ),
          ),
          Column(
            children: <Widget>[Text(DateFormat('kk:mm').format(_data.date)), Text(_data.text)],
          ),
          Expanded(child: Container()),
          Text('$degrees°')
        ],
      ),
    );
  }
}
