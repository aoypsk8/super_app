import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasIcon;
  final Widget? customIcon;
  final VoidCallback? onIconTap;

  const BuildAppBar({
    super.key,
    required this.title,
    this.hasIcon = false,
    this.customIcon,
    this.onIconTap,
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
      actions: hasIcon
          ? [
              InkWell(
                onTap: onIconTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: customIcon ??
                      const Icon(Icons.notifications, color: cr_090a),
                ),
              )
            ]
          : null,
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
