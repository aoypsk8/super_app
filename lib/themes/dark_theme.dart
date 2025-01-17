import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.light().copyWith(
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(
    color: const Color(0xFFFBD021),
    iconTheme: const IconThemeData(color: Colors.black),
  ),

  colorScheme: const ColorScheme.light(
    primary: Colors.black, // Active color
  ),
  unselectedWidgetColor: Colors.grey, // Inactive color

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFFFBD021),
    selectedItemColor: Colors.teal,
    unselectedItemColor: Colors.grey,
  ),
);
