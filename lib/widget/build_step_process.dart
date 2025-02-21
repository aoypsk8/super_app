import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class buildStepProcess extends StatelessWidget {
  final String title;
  final String desc;
  const buildStepProcess({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextFont(
          text: title,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          poppin: true,
        ),
        SizedBox(width: 5),
        TextFont(
          text: desc,
          fontWeight: FontWeight.w500,
          noto: true,
        ),
      ],
    );
  }
}
