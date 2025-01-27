import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class XJaidee extends StatefulWidget {
  const XJaidee({super.key});

  @override
  State<XJaidee> createState() => _XJaideeState();
}

class _XJaideeState extends State<XJaidee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            child: Container(
              height: 30.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 2),
                  colors: [Color(0xffF14D58), Color(0xFFED1C29)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: SvgPicture.asset(
                      MyIcon.bg_gradient2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // appbar
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: color_fff,
                          size: 15.sp,
                        ),
                        onPressed: () {
                          Get.back(); // Navigate back
                        },
                      ),
                      TextFont(
                        fontSize: 13.sp,
                        text: 'ເອັກໃຈດີ',
                        color: color_fff,
                        noto: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // GridView
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: color_fff,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildButton(
                            icon: MyIcon.ic_load_xjaidee,
                            ontap: () {
                              print("object");
                            },
                            title: 'ຢືມສິນເຊື່ອ',
                          ),
                          buildButton(
                            icon: MyIcon.ic_load_approve,
                            ontap: () {
                              print("object");
                            },
                            title: 'ອານຸມັດສິນເຊື່ອ',
                          ),
                          buildButton(
                            icon: MyIcon.ic_load_cancel,
                            ontap: () {
                              print("object");
                            },
                            title: 'ປິດສິນເຊື່ອ',
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFont(
                    text: 'history_load',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: buildHistoryLoad(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class buildHistoryLoad extends StatelessWidget {
  const buildHistoryLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: color_fff,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color_fff,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      MyIcon.ic_load_xjaidee,
                      color: cr_7070,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextFont(
                          text: '3.000.000',
                          fontSize: 13,
                        ),
                        const SizedBox(width: 5),
                        TextFont(
                          text: 'kip',
                          fontSize: 12,
                        ),
                      ],
                    ),
                    TextFont(
                      text: DateFormat('dd MMM, yyyy HH:mm').format(
                        DateTime.parse("2023-01-01 12:00:00"),
                      ),
                      fontSize: 10,
                    ),
                  ],
                ),
              ],
            ),
            TextFont(
              text: 'ຊຳລະຄົບແລ້ວ',
              fontSize: 12,
              color: color_3086,
            ),
          ],
        ),
      ),
    );
  }
}

class buildButton extends StatelessWidget {
  final String title;
  final String icon;
  final Function ontap;

  const buildButton({
    super.key,
    required this.title,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color_fff,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                icon,
                color: cr_red,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFont(
            text: title,
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}
