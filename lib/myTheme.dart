import 'package:flutter/material.dart';

class MyThemeData{
  static Color lightprimary = const Color(0xFFDCCDA8);
  static Color BlackColor = const Color(0xFF000000);
  static final ThemeData Lighttheme = ThemeData(
  primaryColor: lightprimary,
    textTheme: TextTheme(
        headline1:   TextStyle(
          color: BlackColor,fontSize: 30,fontWeight: FontWeight.bold,
        )



    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromRGBO(220, 205, 168, 1),
      unselectedItemColor: Colors.blueGrey
    )

  );
}