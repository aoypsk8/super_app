import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_app/services/theme_service.dart';

class TextFont extends StatelessWidget {
  final String text;
  final bool noto;
  final bool poppin;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;

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
  });

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    Get.find<ThemeService>();
    TextStyle textStyle = GoogleFonts.poppins(); // Default to Poppins

    if (languageCode == 'en') {
      textStyle = GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    } else if (languageCode == 'lo') {
      textStyle = GoogleFonts.notoSerifLao(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    } else if (languageCode == 'zh') {
      textStyle = GoogleFonts.notoSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    } else if (languageCode == 'vi') {
      textStyle = GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    }

    Color effectiveColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : color;

    return Text(
      text.tr,
      textAlign: textAlign,
      style: textStyle.copyWith(color: effectiveColor),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
