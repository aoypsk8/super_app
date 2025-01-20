import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';

final ThemeData darkTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFFFBF7F6),
  primaryColor: color_primary_dark,
  appBarTheme: AppBarTheme(
    color: color_primary_dark,
    iconTheme: const IconThemeData(color: Colors.black),
  ),

  colorScheme: const ColorScheme.light(
    primary: color_primary_dark,
  ),
  unselectedWidgetColor: color_7070, // Inactive color

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: color_primary_dark,
      foregroundColor: color_fff,
    ),
  ),
  // bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //   backgroundColor: const Color(0xFFFBD021),
  //   selectedItemColor: Colors.teal,
  //   unselectedItemColor: Colors.grey,
  // ),
);
