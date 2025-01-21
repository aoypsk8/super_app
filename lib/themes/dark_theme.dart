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
    secondary: cr_2929,
    primary: color_primary_dark,
    onPrimary: cr_b692,
  ),

  unselectedWidgetColor: color_7070, // Inactive color

  // Define textTheme for text color customization
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: cr_2929),
    bodySmall: TextStyle(color: cr_b692),
  ),

  // Optional: You can adjust the input decoration style if necessary
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white54), // Hint text color
  ),
);
