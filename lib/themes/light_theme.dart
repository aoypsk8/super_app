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
      secondary: color_fff,
      primary: color_primary_light, // Active color
      onPrimary: cr_ef33),
  unselectedWidgetColor: color_7070, // Inactive color

  // Define textTheme for text color customization
  textTheme: const TextTheme(
      bodyMedium: TextStyle(color: color_fff),
      bodySmall: TextStyle(color: cr_bf29)),
);
