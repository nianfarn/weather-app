import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  static String title = 'Today';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Weather status as icon.
          SizedBox(
              height: 300,
              width: 300,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(Icons.wb_sunny, color: Colors.amber,)
              )
          ),
          // Location.
          Center(
              child: Text('London, UK')
          ),
          // Temperature and weather as text.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: _borderSide(),
                  bottom: _borderSide()
                )
              ),
              child: Row(
                children: <Widget>[
                  WeatherParam(Icons.battery_full, '57%'),
                  WeatherParam(Icons.settings_power, '74%')
                ],
              ),
            ),
          ),
          ShareButton()
        ],
      ),
    );
  }

  BorderSide _borderSide() {
    return const BorderSide(
        color: Colors.black12,
        width: 3
    );
  }
}

class WeatherParam extends StatelessWidget {
  final IconData icon;
  final String text;

  WeatherParam(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Icon(icon, color: Colors.amber),
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
      child: Text('Share',
        style: TextStyle(
          fontSize: 30,
          color: Colors.orange
        ),
      ),
    );
  }
}

