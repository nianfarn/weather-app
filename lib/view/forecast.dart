import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/geo.dart';
import '../service/resource.dart';
import '../service/weather.dart';
import '../model/view/weather.dart';
import '../styles.dart';

class ForecastPage extends StatefulWidget {
  final Future<List<HourWeather>> initialWeather;

  const ForecastPage({Key key, this.initialWeather}) : super(key: key);

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  List<ForecastWeatherView> viewList;
  Future<List<HourWeather>> _weather;

  @override
  void initState() {
    super.initState();
    _weather = widget.initialWeather;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<HourWeather>>(
          future: _weather,
          builder: (context, snapshot) {
            if (snapshot.error is DataException) {
              DataException error = snapshot.error;
              return Text(error.message, style: AppStyles.errorLargeTextStyle(context));
            }
            if (snapshot.hasData) {
              viewList = _parseToView(snapshot.data);
              return RefreshIndicator(
                child: ListView.builder(
                    itemCount: viewList.length,
                    itemBuilder: (context, index) {
                      return DailyHourWeather(
                        dayTitle: viewList[index].day,
                        list: viewList[index].list,
                      );
                    }),
                  onRefresh: () {
                    setState(() {
                      _weather = localWeather(currentLocation());
                    });
                    return Future.value(null);
                  },
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Row(
                      children: <Widget>[
                        Icon(Icons.error),
                        Text("${snapshot.error}"),
                      ]
                  )
              );
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
          child: Text(dayTitle,
              style: AppStyles.forecastWeekDayTextStyle(context)),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(top: _borderSide(), bottom: _borderSide())),
          child: Column(
            children: <Widget>[for (var item in list) HourWeatherRow(item)],
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
            child: weatherIcon(iconCode, 80, 80),
          ),
          Column(
            children: <Widget>[
              Text(DateFormat('kk:mm').format(_data.date),
                  style: AppStyles.forecastTimeTextStyle(context)),
              Text(_data.text, style: AppStyles.forecastTimeTextStyle(context))
            ],
          ),
          Expanded(child: Container()),
          Container(
              alignment: Alignment.centerRight,
              child: Text('${degrees.toDouble().toStringAsFixed(1)}°',
                  style: AppStyles.forecastDegreesTextStyle(context)))
        ],
      ),
    );
  }
}
