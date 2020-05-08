import 'package:flutter/material.dart';

class AppStyles {

  static TextStyle homeLargeTextStyle() {
    return TextStyle(
      fontSize: AppFontSizes.larger,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle forecastTimeTextStyle(BuildContext ctx) {
    return TextStyle(
      fontSize: AppFontSizes.large(ctx),
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle forecastTextTextStyle() {
    return TextStyle(
      fontSize: AppFontSizes.medium,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle forecastDegreesTextStyle(BuildContext ctx) {
    return TextStyle(
      fontSize: AppFontSizes.largest(ctx),
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w500,
      color: Colors.blueGrey
    );
  }

  static TextStyle forecastWeekDayTextStyle(BuildContext ctx) {
    return TextStyle(
        fontSize: AppFontSizes.largest(ctx),
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w700,
        color: Colors.blueGrey
    );
  }

  static TextStyle errorLargeTextStyle(BuildContext ctx) {
    return TextStyle(
      fontSize: AppFontSizes.largest(ctx),
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w400,
      color: Colors.redAccent
    );
  }
}

class AppFontSizes {
  static const smallest = 12.0;
  static const small = 14.0;
  static const medium = 16.0;
  static const _large = 20.0;
  static const larger = 24.0;
  static const _largest = 28.0;
  static const largestc = 28.0;
  static const _sslarge = 18.0;
  static const _sslargest = 22.0;

  static double largest(context) {
    return isSmallScreen(context) ? _sslargest : _largest;
  }

  static double large(context) {
    return isSmallScreen(context) ? _sslarge : _large;
  }

  static double smallText(context) {
    return isSmallScreen(context) ? smallest : small;
  }
}

bool isSmallScreen(BuildContext context) {
  return MediaQuery.of(context).size.height < 667;
}