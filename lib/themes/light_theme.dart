import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFFFBF7F6),
  primaryColor: const Color(0xFFEC1C29),
  appBarTheme: AppBarTheme(
    color: const Color(0xFFEC1C29),
    iconTheme: const IconThemeData(color: Colors.white),
  ),

  colorScheme: const ColorScheme.light(
    primary: Color(0xFFEC1C29), // Active color
  ),
  unselectedWidgetColor: Colors.grey, // Inactive color
);
