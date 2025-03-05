import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/login/create_password.dart';
import 'package:super_app/views/reusable_template/reusable_otp.dart';
import 'package:super_app/views/x-jaidee/Xjaidee.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/textfont.dart';

class OptScreen extends StatefulWidget {
  OptScreen({super.key});

  @override
  State<OptScreen> createState() => _OptScreenState();
}

class _OptScreenState extends State<OptScreen> {
  final pinController = TextEditingController();

  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      // appBar: BuildAppBar(title: 'otp'),
      // body: SingleChildScrollView(
      //   child: GestureDetector(
      //     onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      //     behavior: HitTestBehavior.opaque,
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 20),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Align(
      //             alignment: Alignment.center,
      //             child: SizedBox(
      //               height: 60.w,
      //               width: 60.w,
      //               child: Image.asset('assets/images/otp.png', fit: BoxFit.cover),
      //             ),
      //           ),
      //           Row(
      //             children: [
      //               Expanded(
      //                 child: Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       TextFont(
      //                         text: 'verification',
      //                         fontWeight: FontWeight.w500,
      //                         fontSize: 18,
      //                         color: cr_2929,
      //                       ),
      //                       Wrap(
      //                         children: [
      //                           TextFont(
      //                             text: 'otp_send',
      //                             color: color_777,
      //                             fontSize: 10,
      //                             maxLines: 2,
      //                           ),
      //                           const SizedBox(width: 5),
      //                           TextFont(
      //                             text: '2052555999',
      //                             color: color_777,
      //                             fontSize: 10,
      //                             maxLines: 2,
      //                             poppin: true,
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 10),
      //           buildOTP(context),
      //           SizedBox(height: 30),
      //           TextButton(
      //             onPressed: () {}, //userController.resendotp(),
      //             child: TextFont(
      //               text: 'send_otp_again',
      //               fontWeight: FontWeight.w400,
      //               underline: true,
      //               underlineColor: cr_ef33,
      //               color: cr_ef33,
      //               fontSize: 11.5,
      //             ),
      //           ),
      //           SizedBox(height: 30),
      //           buildBottomAppbar(func: () {}, title: 'next'),
      //           InkWell(
      //             onTap: () => Get.to(CreatePassword()),
      //             child: TextFont(text: 'create_password'),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      // body: ReusableOtpScreen(
      //   title: 'verify',
      //   desc1: 'otp_verification',
      //   desc2: 'otp_send',
      //   phoneNumber: '2055559999',
      //   buttonText: 'Next',
      //   onOtpCompleted: (otp) {
      //     print('OTP Entered: $otp');
      //     // Add your OTP verification logic here
      //     Get.to(() => CreatePassword());
      //   },
      //   onResendPressed: () {
      //     print('Resend OTP button pressed');
      //     // Add your resend OTP logic here
      //   },
      // ),
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
            // _otpProcess(pin);
          });
        },
        focusNode: focusNode,
        defaultPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: GoogleFonts.poppins(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w500),
          decoration: BoxDecoration(
            color: color_f4f4,
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
            border: Border.all(color: cr_ef33), // Focus color change when typing
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
