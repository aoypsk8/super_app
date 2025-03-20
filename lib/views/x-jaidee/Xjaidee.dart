import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/x-jaidee/input_amountScreen.dart';
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
                          Get.back();
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
                              DialogHelper.showDialogPolicy(
                                title: "Policy",
                                description:
                                    "1. Registration is required to register through the mobile phone number of the customer who registered in accordance with the rules to open an M-Money wallet account, which has to be active and reachable. Users can register to use:\n • Register and fill in the information, KYC manually according to the methods and procedures set by the company in this service.\n2. After the registration is completed, the user must set a secure personal password according to the company's instructions, which is a 6-digit number, then wait for confirmation from the system to start using the service.Using M-Money Wallet Services\n 1. Top Up Wallet\n Users of M-Money Wallet can top-up their wallet at: (1) the LTC Service Center, (2) the participating Banks, (3) the Agent Stores that the Company has periodically listed (4) Direct Sale staff. Minimum top up is 10,000 Kip (ten thousand kip).",
                                onClose: () {
                                  Get.to(() => InputAmountXJaideeScreen());
                                },
                              );
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
  final VoidCallback ontap;

  const buildButton({
    super.key,
    required this.title,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
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
