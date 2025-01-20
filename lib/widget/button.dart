import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final String svgPath;
  final double borderRadius;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.title,
    this.svgPath = '',
    this.borderRadius = 10,
    this.width = 150.0,
    this.height = 50.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      // Observe the reactive theme changes inside Obx
      final isDarkMode = themeService.isDarkMode;
      final borderColor = isDarkMode ? color_primary_dark : color_primary_light;
      final backgroundColor = isDarkMode ? color_primary_dark : color_primary_light;

      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(backgroundColor),
            side: WidgetStateProperty.all(
              BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextFont(
                  text: title,
                  color: color_fff,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              if (svgPath.isNotEmpty) const SizedBox(width: 10),
              if (svgPath.isNotEmpty)
                SvgPicture.asset(
                  svgPath,
                  width: 24.0,
                  height: 24.0,
                  color: color_fff,
                ),
            ],
          ),
        ),
      );
    });
  }
}

class SecondaryButton extends StatelessWidget {
  final String title;
  final String svgPath;
  final double borderRadius;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.title,
    this.svgPath = '',
    this.borderRadius = 10,
    this.width = 150.0,
    this.height = 50.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      // Reactive state handling with themeService
      final isDarkMode = themeService.isDarkMode;
      final borderColor = isDarkMode ? color_primary_dark : color_primary_light;
      final textColor = isDarkMode ? color_primary_dark : color_primary_light;
      final backgroundColor = isDarkMode ? color_fff : color_fff; // Set background color as needed

      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(backgroundColor),
            side: WidgetStateProperty.all(
              BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextFont(
                  text: title,
                  color: textColor,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              if (svgPath.isNotEmpty) const SizedBox(width: 10),
              if (svgPath.isNotEmpty)
                SvgPicture.asset(
                  svgPath,
                  width: 24.0,
                  height: 24.0,
                  color: borderColor,
                ),
            ],
          ),
        ),
      );
    });
  }
}
