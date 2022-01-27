import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/shared/styles/colors.dart';

ThemeData lightTheme=ThemeData(
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0, 
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
  ),
  /* scaffoldBackgroundColor: Colors.white, */
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  ),
  fontFamily: 'Jannah',
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0.0,
    unselectedItemColor: Colors.black,
    selectedItemColor: defaultColor,
  ),
);
ThemeData blackTheme=ThemeData(
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: Colors.black,
    elevation: 0.0, 
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  ),
  fontFamily: 'Jannah',
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    elevation: 0.0,
    unselectedItemColor: Colors.white,
    selectedItemColor: defaultColor,
  ),
);