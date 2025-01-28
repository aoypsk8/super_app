import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
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
    return Obx(
      () => Scaffold(
          backgroundColor: color_fff,
          appBar: BuildAppBar(title: "confirm_payment"),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
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
                            ],
                          ),
                        ),
                        Image.asset(
                          MyIcon.logo_ok,
                          width: 14.w,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildOTP(),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFont(text: 'send_otp_desc'),
                              const SizedBox(width: 5),
                            ],
                          ),
                          TextFont(
                            text:
                                'Ref Code : ${cashOutController.reqcashout.value.data!.otpRefCode!}',
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: color_fff,
              border: Border.all(color: color_ddd),
            ),
            child: buildBottomAppbar(
              bgColor: Theme.of(context).primaryColor,
              title: 'confirm',
              func: () {
                cashOutController.loading.value = true;
                // cashOutController.confirmOtpPayment(pinController.text);
                Get.toNamed('/resultCashOut');
                // cashOutController.confirmOtpPayment(pinController.text);
              },
            ),
          )),
    );
  }

  Container buildOTP() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Pinput(
        length: 6,
        pinAnimationType: PinAnimationType.slide,
        controller: pinController,
        onCompleted: (pin) {
          cashOutController.loading.value = true;
          cashOutController.confirmOtpPayment(pin);
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
}
