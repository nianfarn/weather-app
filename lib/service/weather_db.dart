import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/view/weather.dart';

void updateLastWeather(List<HourWeather> weathers) async {
  var db = await _open('last_weather.db');
  db.transaction((txn) async {
    txn.delete('last_weather');

    for (var item in weathers) {
      txn.insert('last_weather', item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  });
}

Future<List<HourWeather>> lastWeather() async {
  var db = await _open('last_weather.db');
  return await db.transaction((txn) async {
    var response = await txn.query('last_weather', orderBy: 'time');
    var retList = response.map((elem) => HourWeather.fromDB(elem)).toList();
    return Future.value(retList);
  });
}

Future<Database> _open(String dbName) async {
  var path = join(await getDatabasesPath(), dbName);
  return openDatabase(path, onCreate: _onCreate, version: 1);
}

FutureOr<void> _onCreate(Database db, int version) {
  db.execute(
    'CREATE TABLE last_weather('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'city TEXT, time TEXT, iconCode TEXT, text TEXT, degrees REAL, '
        'wind REAL, rain REAL, pressure INTEGER, humidity INTEGER, feelsLike REAL, clouds INTEGER)',
  );
}
