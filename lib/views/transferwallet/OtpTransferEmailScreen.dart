// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
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
                                    TextFont(
                                      text: 'otp_send',
                                      color: color_777,
                                      fontSize: 10,
                                      maxLines: 2,
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
                            onPressed: () => userController.resendotpforemail(),
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
                          Get.back();
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
          textStyle: TextStyle(
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
          textStyle: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(30, 60, 87, 1),
            fontWeight: FontWeight.w500,
          ),
          decoration: BoxDecoration(
            border:
                Border.all(color: cr_ef33), // Focus color change when typing
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future _otpProcess(String otp) async {
    userController.otpprocessTransfer(otp);
  }
}
