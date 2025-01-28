import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Add a title parameter.

  const BuildAppBar({
    super.key,
    required this.title, // Make the title required.
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color_fff,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: cr_090a,
      ),
      elevation: 0,
      title: TextFont(
        text: title,
        color: cr_2929,
        fontSize: 11.5.sp,
        noto: true,
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          color: cr_ecec,
          thickness: 1,
          height: 0.8,
        ),
      ),
    );
  }
}
