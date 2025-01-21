import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmTranferScreen extends StatefulWidget {
  const ConfirmTranferScreen({super.key});

  @override
  State<ConfirmTranferScreen> createState() => _ConfirmTranferScreenState();
}

class _ConfirmTranferScreenState extends State<ConfirmTranferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cr_fbf7,
      appBar: AppBar(
        backgroundColor: color_fff,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: cr_090a,
        ),
        elevation: 0,
        title: TextFont(
          // text: menulists.groupNameEN.toString(),
          text: "ໂອນເງິນ",
          color: cr_2929,
          fontSize: 11.5.sp,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: cr_ecec,
            thickness: 1,
            height: 0.8,
          ),
        ),
      ),
    );
  }
}
