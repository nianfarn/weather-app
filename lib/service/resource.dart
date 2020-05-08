import 'package:flutter/material.dart';

Image weatherIcon(String iconCode, [double height = 60, double width = 60]) {
  return Image(
    height: height,
    width: width,
    image: AssetImage('assets/icons/$iconCode.png'),
  );
}