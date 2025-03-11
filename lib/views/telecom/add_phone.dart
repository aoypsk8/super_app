import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class AddPhonePage extends StatefulWidget {
  const AddPhonePage({super.key});

  @override
  State<AddPhonePage> createState() => _AddPhonePageState();
}

class _AddPhonePageState extends State<AddPhonePage> {
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Stack(
            children: [
              appBarTitle(),
              appBarBackBtn(),
              body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          TextFont(text: 'ປ້ອນໝາຍເລກໂທລະສັບ'),
        ],
      ),
    );
  }

  Widget appBarTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: TextFont(
        text: 'ເພິ່ມໝາຍເລກໂທລະສັບ',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget appBarBackBtn() {
    return Positioned(
        right: 0,
        child: InkWell(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              MyIcon.deleteX_round,
              width: 10.w,
              height: 10.w,
            )));
  }
}
