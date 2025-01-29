import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class buildTextDetail extends StatelessWidget {
  const buildTextDetail({
    super.key,
    required this.title,
    required this.detail,
    this.maxlines = 7,
    this.money = false,
    this.noto = false,
  });
  final String title;
  final String detail;
  final bool money;
  final bool noto;
  final int maxlines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: cr_7070,
        ),
        Wrap(
          children: [
            TextFont(
              text: detail,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: cr_2929,
              maxLines: maxlines,
              poppin: noto ? false : true, // Set poppin to true if money is true
              noto: noto ? true : false, // Set noto to true if money is false
            ),
            money
                ? TextFont(
                    text: '.00 LAK',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: cr_2929,
                    poppin: true,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
