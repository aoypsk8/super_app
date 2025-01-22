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
    required this.money,
  });
  final String title;
  final String detail;
  final bool money;
  final int maxlines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
          color: cr_7070,
        ),
        Wrap(
          children: [
            TextFont(
              text: detail,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: cr_2929,
              maxLines: maxlines,
            ),
            money
                ? TextFont(
                    text: '.00 LAK',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: cr_2929,
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
