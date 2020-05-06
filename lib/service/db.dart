import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_app/model/view/weather.dart';

void updateLastWeather(List<HourWeather> weathers) async {
  var db = await _open('weather.db');
  db.transaction((txn) async {
    txn.delete('weather');

    for (var item in weathers) {
      txn.insert('weather', item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  });
}

Future<List<HourWeather>> lastWeather() async {
  var db = await _open('weather.db');
  return await db.transaction((txn) async {
    var response = await txn.query('weather', orderBy: 'time');
    var retList = response.map((elem) => HourWeather.fromMap(elem)).toList();
    return Future.value(retList);
  });
}

Future<Database> _open(String dbName) async {
  var path = join(await getDatabasesPath(), dbName);
  return openDatabase(path, onCreate: _onCreate, version: 1);
}

FutureOr<void> _onCreate(Database db, int version) {
  db.execute(
    'CREATE TABLE weather(id INTEGER PRIMARY KEY AUTOINCREMENT, day TEXT, time TEXT, iconCode TEXT, text TEXT, degrees TEXT)',
  );
}
