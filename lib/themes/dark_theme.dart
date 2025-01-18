import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFFFBF7F6),
  primaryColor: const Color(0xFFFBD021),
  appBarTheme: AppBarTheme(
    color: const Color(0xFFFBD021),
    iconTheme: const IconThemeData(color: Colors.black),
  ),

  colorScheme: const ColorScheme.light(
    primary: Colors.black,
  ),
  unselectedWidgetColor: Colors.grey.shade600, // Inactive color

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFFFBD021),
    selectedItemColor: Colors.teal,
    unselectedItemColor: Colors.grey,
  ),
);
