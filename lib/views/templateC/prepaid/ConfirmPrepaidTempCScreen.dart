import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmPrepaidTempCScreen extends StatefulWidget {
  const ConfirmPrepaidTempCScreen({super.key});

  @override
  State<ConfirmPrepaidTempCScreen> createState() =>
      _ConfirmPrepaidTempCScreenState();
}

class _ConfirmPrepaidTempCScreenState extends State<ConfirmPrepaidTempCScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempCcontroler = Get.put(TempCController());

  final storage = GetStorage();
  int? selectedOption = 1;

  void sumTotalAmount() {
    var coupon = tempCcontroler.rxCouponAmount.value;
    var payment = tempCcontroler.rxPaymentAmount.value;
    tempCcontroler.rxPaymentAmount.value = payment - coupon;
  }

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
        appBar: BuildAppBar(title: 'confirm_payment'),
        bottomNavigationBar: buildBottomAppbar(
          bgColor: Theme.of(context).primaryColor,
          title: 'confirm',
          func: () {
            tempCcontroler.paymentPrepaid(homeController.menudetail.value);
          },
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                detailPackage(),
                SizedBox(height: 10),
                detailAccount(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailAccount() {
    return Column(
      children: [
        Row(
          children: [
            TextFont(text: 'detail', fontWeight: FontWeight.bold),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: color_fff,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    TextFont(
                      text: 'msisdn',
                      fontWeight: FontWeight.bold,
                      color: color_999,
                    ),
                  ],
                ),
                SizedBox(height: 5.sp),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: color_999,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: TextFont(
                          text: tempCcontroler.rxAccNo.value,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget detailPackage() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color_fff, color_999.withOpacity(0.2)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.sp),
                  child: TextFont(
                    text: fn.format(double.parse(
                        tempCcontroler.rxPaymentAmount.value.toString())),
                    maxLines: 2,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.sp),
                TextFont(text: 'ກີບ', fontSize: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectPayment(mmoney, val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.25, color: Color(0xFFF15244)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: RadioListTile(
        title: Row(
          children: [
            mmoney == true
                ? Image.asset(
                    MyIcon.ic_logo_x,
                    width: 10.w,
                  )
                : SvgPicture.asset(
                    MyIcon.ic_creditcard,
                    height: 20.sp,
                  ),
            const SizedBox(width: 14),
            Expanded(
                child: mmoney == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: userController.profileName.value,
                            noto: true,
                            maxLines: 2,
                          ),
                          TextFont(
                            text: storage.read('msisdn'),
                            poppin: true,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      )
                    : SizedBox()),
          ],
        ),
        value: val,
        activeColor: color_ed1,
        groupValue: selectedOption,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (val) {
          setState(() {
            selectedOption = val;
            // print("Selected Option: $selectedOption");
          });
        },
      ),
    );
  }
}
