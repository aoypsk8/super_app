// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildAppbarHeader.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import '../../utility/myIcon.dart';
import '../../utility/myconstant.dart';

class OtpTransferEmailScreen extends StatefulWidget {
  const OtpTransferEmailScreen({super.key});

  @override
  State<OtpTransferEmailScreen> createState() => _OtpTransferEmailScreenState();
}

class _OtpTransferEmailScreenState extends State<OtpTransferEmailScreen> {
  final UserController userController = Get.find();

  final storage = GetStorage();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    userController.increasepage();
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_grey_background,
      // backgroundColor: color_redLight_background,
      extendBodyBehindAppBar: true,
      appBar: BuildAppBar(title: "otp by email"),
      body: Column(
        children: [
          const buildAppbarHeader(title: '', desc: ''),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: 'verification',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          TextFont(
                            text: 'otp_sendEmail',
                            color: color_777,
                            fontSize: 10,
                            maxLines: 2,
                          ),
                          // TextFont(text: userController.rxMsisdnReg.value),
                        ],
                      ),
                    ),
                    Image.asset(
                      MyIcon.logo_ok,
                      width: 14.w,
                    )
                  ],
                ),
                SizedBox(height: 20),
                buildOTP(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFont(text: 'send_otp_desc'),
                    const SizedBox(width: 5),
                  ],
                ),
                TextButton(
                  onPressed: () => userController.resendotpforemail(),
                  child: TextFont(
                    text: 'send_otp_again',
                    fontWeight: FontWeight.w700,
                    color: color_red_background,
                  ),
                ),
                Obx(() => TextFont(
                      text: 'Ref Code : ${userController.refcode}',
                      fontSize: 10,
                      poppin: true,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOTP(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Pinput(
        length: 6,
        pinAnimationType: PinAnimationType.slide,
        controller: pinController,
        onCompleted: (pin) {
          Future.delayed(MyConstant.delayTime).then((_) {
            _otpProcess(pin);
          });
        },
        focusNode: focusNode,
        defaultPinTheme: PinTheme(
            width: 80,
            height: 80,
            textStyle: GoogleFonts.poppins(
                fontSize: 22.sp,
                color: color_red_background,
                fontWeight: FontWeight.w500),
            decoration: const BoxDecoration()),
        showCursor: true,
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 2,
              decoration: BoxDecoration(
                  color: color_red_background,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
        preFilledWidget: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 2,
              decoration: BoxDecoration(
                  color: color_grey5e5,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }

  Future _otpProcess(String otp) async {
    userController.otpprocessTransfer(otp);
  }
}
