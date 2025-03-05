import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
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
  final bool args;
  final Map<String, String>? arguments;

  TextFont({
    super.key,
    required this.text,
    this.noto = false,
    this.poppin = false,
    this.textAlign = TextAlign.start,
    this.color = color_2929,
    this.fontSize = 12.5,
    this.fontWeight = FontWeight.normal,
    this.maxLines = 1,
    this.underline = false,
    this.underlineColor = cr_7070,
    this.args = false,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';

    TextStyle textStyle;

    // Determine the appropriate font style
    if (poppin) {
      textStyle = GoogleFonts.poppins(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: underline ? TextDecorationStyle.solid : null,
      );
    } else if (noto) {
      textStyle = GoogleFonts.notoSansLao(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : null,
        decorationColor: underline ? underlineColor : null,
        decorationStyle: TextDecorationStyle.solid,
      );
    } else {
      textStyle = _getLanguageSpecificFont(languageCode);
    }

    // Apply theme-based color for better visibility
    Color effectiveColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : color;

    // Render the text with translation and optional arguments
    String translatedText = args ? text.trParams(arguments ?? {}) : text.tr;

    return Text(
      translatedText,
      textAlign: textAlign,
      style: textStyle.copyWith(color: effectiveColor),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getLanguageSpecificFont(String languageCode) {
    switch (languageCode) {
      case 'lo':
        return GoogleFonts.notoSansLao(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: underline ? underlineColor : null,
          decorationStyle: TextDecorationStyle.solid,
        );
      case 'zh':
        return GoogleFonts.notoSansSc(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: underline ? underlineColor : null,
          decorationStyle: TextDecorationStyle.solid,
        );
      case 'vi':
        return GoogleFonts.notoSansTaiViet(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: underline ? underlineColor : null,
          decorationStyle: TextDecorationStyle.solid,
        );
      default:
        return GoogleFonts.poppins(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: underline ? underlineColor : null,
          decorationStyle: TextDecorationStyle.solid,
        );
    }
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    required this.text,
    this.maxLines = 1, // Default to 2 lines
    Key? key,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, color: color_2929),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded; // Toggle expand/collapse
            });
          },
          child: Text(
            isExpanded ? 'Show Less' : 'Show More',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
