import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmTempAScreen extends StatelessWidget {
  ConfirmTempAScreen({super.key});

  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final controller = Get.find<TempAController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: homeController.getMenuTitle()),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildStepProcess(title: '5/5', desc: 'confirm_payment'),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      //! from - to account
                      buildAccountDetails(
                          context: context,
                          imageUrl: userController.userProfilemodel.value.profileImg ?? '',
                          type: 'from',
                          accName: userController.profileName.value,
                          accNo: userController.userProfilemodel.value.msisdn!),
                      buildDotLine(color: Theme.of(context).primaryColor),
                      buildAccountDetails(
                          context: context,
                          imageUrl: controller.tempAdetail.value.logo ?? '',
                          type: 'to',
                          accName: controller.rxaccname.value,
                          accNo: controller.rxaccnumber.value,
                          titleProvider: controller.tempAdetail.value.title!),
                    ],
                  ),
                ),
                //! detail
                const SizedBox(height: 16),
                TextFont(text: 'detail', color: color_7070),
                const SizedBox(height: 5),
                TextFont(
                  text: controller.rxNote.value?.isNotEmpty ?? false ? controller.rxNote.value : 'ບໍ່ມີການຈົດບັນທຶກ.',
                  noto: true,
                ),
                const SizedBox(height: 16),
                TextFont(text: 'fee', color: color_7070),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textBaseline: TextBaseline.alphabetic, // Ensures baseline alignment
                  children: [
                    TextFont(
                      text: fn.format(int.parse(controller.rxFee.value)),
                      poppin: true,
                    ),
                    TextFont(text: '.00 LAK', poppin: true),
                  ],
                ),
                const SizedBox(height: 5),
                TextFont(text: 'amount', color: color_7070),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textBaseline: TextBaseline.alphabetic, // Ensures baseline alignment
                  children: [
                    TextFont(
                      text: fn.format(int.parse(controller.rxPaymentAmount.value)),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color_primary_light,
                      poppin: true,
                    ),
                    TextFont(
                      text: '.00 LAK',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color_primary_light,
                      poppin: true,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BuildButtonBottom(
        title: 'confirm',
        isActive: true,
        func: () {
          var amount = controller.rxPaymentAmount.value.replaceAll(RegExp(r'[^\w\s]+'), '');
          controller.paymentprocess(amount);
        },
      ),
    );
  }

  Widget buildAccountDetails({
    required BuildContext context,
    required String imageUrl,
    required String type,
    required String accName,
    required String accNo,
    String titleProvider = '',
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50.sp,
                        height: 50.sp,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(imageUrl),
                          backgroundColor: Colors.transparent, // Optional: Set a background color
                        ),
                      ),
                      SizedBox(width: 8), // Optional spacing between image and column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            titleProvider == ''
                                ? const SizedBox.shrink()
                                : TextFont(
                                    text: titleProvider,
                                    noto: true,
                                    fontWeight: FontWeight.bold,
                                  ),
                            TextFont(
                              text: accName,
                              noto: true,
                              fontWeight: FontWeight.bold,
                              // fontSize: 14,
                              maxLines: 2,
                            ),
                            TextFont(
                              text: accNo,
                              poppin: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                decoration: BoxDecoration(
                  color: color_fff,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextFont(
                  textAlign: TextAlign.center,
                  text: type,
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
