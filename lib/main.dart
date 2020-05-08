import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/service/geo.dart';

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

  Future<Position> position;
  Future<String> city;

  int _navigationTabIndex = 0;

  tabs(int index, Position position, String city) {
    var weather = weatherByLonLat(position.longitude, position.latitude);
    switch (index) {
      case 0 : return HomePage(weather: weather, city: city);
      case 1 : return ForecastPage(weather: weather);
    }
  }


  @override
  void initState() {
    super.initState();
    position = currentLocation();
    city = currentCity();
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
        future: Future.wait([position, city]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return tabs(_navigationTabIndex, snapshot.data[0], snapshot.data[1]);
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

