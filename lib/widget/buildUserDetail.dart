import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class buildUserDetail extends StatelessWidget {
  const buildUserDetail({
    super.key,
    required this.from,
    required this.name,
    required this.msisdn,
    required this.profile,
  });

  final bool from;
  final String name;
  final String msisdn;
  final String profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: color_fff,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFont(
            text: from ? "from_acc" : "to_acc",
            color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.black,
            poppin: true,
            fontSize: 9.sp,
          ),
        ),
        Row(
          children: [
            Container(
              width: 12.5.w,
              height: 12.5.w,
              padding: const EdgeInsets.all(1.5),
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: color_fff,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  profile,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  text: name,
                  color: cr_2929,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                TextFont(
                  text: msisdn,
                  color: cr_2929,
                  fontSize: 14.sp,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
