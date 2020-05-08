import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/service/geo.dart';

import 'model/view/weather.dart';
import 'service/weather.dart';
import 'view/forecast.dart';
import 'view/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  Future<List<HourWeather>> weather;
  Future<String> city;
  var connection;

  int _navigationTabIndex = 0;

  tabs(int index, String city) {
    switch (index) {
      case 0 : return HomePage(weather: weather, city: city);
      case 1 : return ForecastPage(initialWeather: weather);
    }
  }


  @override
  void initState() {
    super.initState();
    weather = localWeather();
    city = currentCity();

    connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        setState(() {
          weather = localWeather();
        });
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    connection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: city,
          builder: (context, snapshot) {
            return snapshot.hasData ? Text(snapshot.data) : Container();
          },
        ),
        elevation: 1,
      ),
      body: FutureBuilder(
        future: city,
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
              icon: Icon(Icons.home),
              title: Text('Today')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
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

