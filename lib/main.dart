import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/model/json/weather.dart';
import 'package:weather_app/service/geo.dart';

import 'view/forecast.dart';
import 'view/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Home(),
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Position> position;

  int _navigationTabIndex = 0;
  String _appBarTitle = '_appbarTitle';
  final tabAppBars = [
    '_appbarTitle1',
    '_appbarTitle2',
  ];

  tabs(int index, Position position) {
    switch (index) {
      case 0 : return HomePage(position: position);
      case 1 : return ForecastPage(position: position);
    }
  }


  @override
  void initState() {
    super.initState();
    position = currentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Should I add rainbow border?
        title: Center(
            child: Text(_appBarTitle)
        ),
        elevation: 1,
      ),
      body: FutureBuilder<Position>(
        future: position,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return tabs(_navigationTabIndex, snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationTabIndex,
        iconSize: 30,
        selectedItemColor: Colors.deepOrange,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              title: Text('Today')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.wb_cloudy),
              title: Text('Forecast')
          ),
        ],
        onTap: (index) {
          setState(() {
            _navigationTabIndex = index;
          });
        },
      ),
    );
  }
}

