import 'package:flutter/material.dart';

import 'forecast.dart';
import 'home.dart';

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

  static String london = 'London';

  int _navigationTabIndex = 0;
  String _appBarTitle = HomePage.title;
  final tabAppBars = [
    HomePage.title,
    london
  ];
  final tabs = [
    HomePage(),
    ForecastPage.forCity(london)
  ];

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
      body: tabs[_navigationTabIndex],
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
            _appBarTitle = london;
          });
        },
      ),

    );
  }
}

