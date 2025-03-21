import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

// ignore: camel_case_types
class buildBottomAppbar extends StatelessWidget {
  buildBottomAppbar(
      {super.key,
      required this.func,
      required this.title,
      this.radius = 6,
      this.high = 4,
      this.bgColor = cr_ef33,
      this.margin = const EdgeInsets.symmetric(horizontal: 20),
      this.fontWeight = FontWeight.w500,
      this.noto = false,
      this.share = false,
      this.isEnabled = true,
      this.paddingbottom = 0,
      this.textColor = color_fff,
      this.borderColor = cr_ef33});
  final String title;
  final double radius;
  final double high;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final Function() func;
  final EdgeInsetsGeometry margin;
  final bool? noto;
  final bool? share;
  final FontWeight fontWeight;
  final bool isEnabled;
  double? paddingbottom;

  @override
  Widget build(BuildContext context) {
    paddingbottom = high.h;
    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isEnabled ? func : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                  side: BorderSide(width: 1, color: borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: isEnabled ? title : 'loading...',
                    color: textColor,
                    fontWeight: fontWeight,
                    noto: noto ?? true,
                  ),
                  share == true ? const SizedBox(width: 10) : const SizedBox(),
                  share == true
                      ? SvgPicture.asset(
                          MyIcon.ic_share,
                          fit: BoxFit.cover,
                          color: color_fff,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          SizedBox(height: paddingbottom)
        ],
      ),
    );
  }
}

class buildBottomBill extends StatelessWidget {
  const buildBottomBill({
    super.key,
    required this.func,
    required this.title,
    this.radius = 6,
    this.high = 4,
    this.bgColor = color_ed1,
    this.textColor = color_ed1,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.fontWeight = FontWeight.w500,
    this.noto = false,
    this.share = false,
    this.isEnabled = true,
    this.fontSize = 12,
  });
  final String title;
  final double radius;
  final double high;
  final Color bgColor;
  final Color textColor;
  final Function() func;
  final EdgeInsetsGeometry margin;
  final bool? noto;
  final bool? share;
  final FontWeight fontWeight;
  final bool isEnabled;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: ElevatedButton(
              onPressed: isEnabled ? func : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  share == true ? const SizedBox(width: 10) : const SizedBox(),
                  share == true
                      ? SvgPicture.asset(
                          MyIcon.ic_share,
                          fit: BoxFit.cover,
                          color: textColor,
                        )
                      : const SizedBox(),
                  const SizedBox(width: 5),
                  TextFont(
                    text: isEnabled ? title : 'loading...',
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: high.h)
        ],
      ),
    );
  }
}
