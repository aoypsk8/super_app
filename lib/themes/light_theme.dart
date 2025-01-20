import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFFFBF7F6),
  primaryColor: color_primary_light,
  appBarTheme: AppBarTheme(
    color: color_primary_light,
    iconTheme: const IconThemeData(color: Colors.white),
  ),

  colorScheme: const ColorScheme.light(
    primary: color_primary_light, // Active color
  ),
  unselectedWidgetColor: color_7070, // Inactive color

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: color_primary_light,
      foregroundColor: color_fff,
      side: BorderSide(color: color_primary_light, width: 1),
    ),
  ),
);
