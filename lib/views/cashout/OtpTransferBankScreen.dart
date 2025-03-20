// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class OtpTransferBankScreen extends StatefulWidget {
  const OtpTransferBankScreen({super.key});

  @override
  State<OtpTransferBankScreen> createState() => _OtpTransferBankScreenState();
}

class _OtpTransferBankScreenState extends State<OtpTransferBankScreen> {
  // final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  // final paymentController = Get.find<PaymentController>();
  final cashOutController = Get.put(CashOutController());

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      MyIcon.otpAnimation,
                    ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextFont(
                                      text: 'verification',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: cr_2929,
                                    ),
                                    Wrap(
                                      children: [
                                        TextFont(
                                          text: 'otp_send',
                                          color: color_777,
                                          fontSize: 10,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(width: 5),
                                        TextFont(
                                          text: userController
                                              .userProfilemodel.value.msisdn
                                              .toString(),
                                          color: color_777,
                                          fontSize: 10,
                                          maxLines: 2,
                                          poppin: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          buildOTP(context),
                          SizedBox(height: 30),
                          TextButton(
                            onPressed: () => userController.resendotp(),
                            child: TextFont(
                              text: 'send_otp_again',
                              fontWeight: FontWeight.w400,
                              underline: true,
                              underlineColor: cr_ef33,
                              color: cr_ef33,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      buildBottomAppbar(
                        bgColor: Theme.of(context).primaryColor,
                        title: 'next',
                        high: 0,
                        func: () {
                          Future.delayed(MyConstant.delayTime).then((_) {
                            _otpProcess(pinController.text);
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Get.close(userController.pageclose.value);
                        },
                        child: TextFont(
                          text: 'cancel',
                          fontWeight: FontWeight.w400,
                          underline: true,
                          underlineColor: cr_7070,
                          color: cr_7070,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
          width: 56,
          height: 56,
          textStyle: GoogleFonts.poppins(
              fontSize: 20,
              color: Color.fromRGBO(30, 60, 87, 1),
              fontWeight: FontWeight.w500),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        showCursor: true,
        focusedPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: GoogleFonts.poppins(
            fontSize: 20,
            color: Color.fromRGBO(30, 60, 87, 1),
            fontWeight: FontWeight.w500,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: cr_ef33),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future _otpProcess(String otp) async {
    cashOutController.confirmOtpPayment(pinController.text);
  }
}
