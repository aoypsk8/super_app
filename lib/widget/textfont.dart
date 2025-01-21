import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/utility/color.dart';

class TextFont extends StatelessWidget {
  final String text;
  final bool noto;
  final bool poppin;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final bool underline;
  final Color underlineColor;

  const TextFont({
    super.key,
    required this.text,
    this.noto = false,
    this.poppin = false,
    this.textAlign = TextAlign.start,
    this.color = Colors.black,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.maxLines = 1,
    this.underline = false,
    this.underlineColor = cr_7070,
  });

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    Get.find<ThemeService>();

    TextStyle textStyle;

    // 1. If `poppin` is true, prioritize Poppins.
    if (poppin) {
      textStyle = GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: underline ? TextDecorationStyle.dashed : null,
      );
    }
    // 2. If `noto` is true, prioritize Noto Sans Serif.
    else if (noto) {
      textStyle = GoogleFonts.notoSerifLao(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: underline ? TextDecorationStyle.dashed : null,
      );
    }
    // 3. Handle language-based fonts if neither `poppin` nor `noto` is true.
    else if (languageCode == 'en') {
      textStyle = GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    } else if (languageCode == 'lo') {
      textStyle = GoogleFonts.notoSerifLao(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: underline ? TextDecorationStyle.dashed : null,
      );
    } else if (languageCode == 'zh') {
      textStyle = GoogleFonts.notoSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: underline ? TextDecorationStyle.dashed : null,
      );
    } else if (languageCode == 'vi') {
      textStyle = GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: underline ? TextDecorationStyle.dashed : null,
      );
    } else {
      // Default to Poppins if no match.
      textStyle = GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    }

    // 4. Apply the theme's brightness for dynamic color handling.
    Color effectiveColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : color;

    return Text(
      text.tr, // Translate text using GetX.
      textAlign: textAlign,
      style: textStyle.copyWith(color: effectiveColor),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
