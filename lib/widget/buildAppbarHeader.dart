// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class buildAppbarHeader extends StatelessWidget {
  const buildAppbarHeader({
    super.key,
    required this.title,
    this.desc = "",
  });
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xffF14D58), Color(0xFFED1C29)],
        ),
      ),
      width: Get.width,
      height: Get.width / 3,
      child: Stack(
        children: [
          Positioned(
            bottom: 10,
            left: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                TextFont(
                  text: title,
                  // fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: color_fff,
                  // poppin: true,
                ),
                SizedBox(width: 3),
                // TextFont(
                //   text: 'to your M Money',
                //   // fontWeight: FontWeight.bold,
                //   // fontSize: 18,
                //   color: color_fff,
                //   poppin: true,
                // )
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              MyIcon.bg_gradient1,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
