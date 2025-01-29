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
  unselectedWidgetColor: color_7070,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: cr_2929),
    bodySmall: TextStyle(color: cr_b692),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white54),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return color_toggle_dark;
      }
      return color_7070;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return color_primary_dark.withOpacity(0.3);
      }
      return color_7070.withOpacity(0.3);
    }),
    trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return color_primary_dark.withOpacity(0.3);
      }
      return color_7070.withOpacity(0.3);
    }),
  ),
);
