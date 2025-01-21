import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

// ignore: camel_case_types
class buildBottomAppbar extends StatelessWidget {
  const buildBottomAppbar({
    super.key,
    required this.func,
    required this.title,
    this.radius = 6,
    this.high = 4,
    this.bgColor = color_ed1,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.fontWeight = FontWeight.w500,
    this.noto = false,
    this.share = false,
    this.isEnabled = true,
  });
  final String title;
  final double radius;
  final double high;
  final Color bgColor;
  final Function() func;
  final EdgeInsetsGeometry margin;
  final bool? noto;
  final bool? share;
  final FontWeight fontWeight;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
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
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: isEnabled ? title : 'loading...',
                    color: color_fff,
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
          SizedBox(height: high.h)
        ],
      ),
    );
  }
}

class buildButtonWhite extends StatelessWidget {
  const buildButtonWhite(
      {super.key,
      required this.title,
      this.radius = 6,
      required this.func,
      this.bg = color_eee});
  final String title;
  final double radius;
  final Color bg;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.only(right: 30, left: 30, bottom: 35),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 5,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: TextFont(
          text: title,
          color: color_777,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class buildBottomAppbar1 extends StatelessWidget {
  const buildBottomAppbar1({
    super.key,
    required this.func,
    required this.title,
    this.radius = 6,
    this.high = 4,
    this.bgColor = color_ed1,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.fontWeight = FontWeight.w500,
    this.noto = false,
    this.share = false,
    this.isDisabled = false,
  });
  final String title;
  final double radius;
  final double high;
  final Color bgColor;
  final Function() func;
  final EdgeInsetsGeometry margin;
  final bool? noto;
  final bool? share;
  final FontWeight fontWeight;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isDisabled ? null : func,
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
                  TextFont(
                    text: isDisabled ? title : 'next',
                    color: color_fff,
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
          SizedBox(height: high.h)
        ],
      ),
    );
  }
}
