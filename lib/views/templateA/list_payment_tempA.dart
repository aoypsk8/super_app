import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/views/templateA/confirm_tempA.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class ListsPaymentTempAScreen extends StatelessWidget {
  ListsPaymentTempAScreen({super.key});
  final homeController = Get.find<HomeController>();
  final paymentController = Get.put(PaymentController());
  final controller = Get.put(TempAController());

  @override
  Widget build(BuildContext context) {
    var data = [
      {
        'payment_type': 'mmoney',
        'status': true,
        'order': 1,
        'logo': '',
        'title': 'M moneyX',
        'description': '2052555999',
      },
      {
        'payment_type': 'master_card',
        'status': true,
        'order': 2,
        'logo': '',
        'title': 'Credit/Debit card',
        'description': '525234324352345235',
      },
      {
        'payment_type': 'union_pay',
        'status': true,
        'order': 3,
        'logo': '',
        'title': 'Credit/Debit card',
        'description': '525234324352345235',
      },
      {
        'payment_type': 'other',
        'status': true,
        'order': 3,
        'logo': 'https://mmoney.la/AppLite/PartnerIcon/electricLogo.png',
        'title': 'image_from_url',
        'description': '525234324352345235',
      },
    ];
    return Scaffold(
      appBar: BuildAppBar(title: homeController.getMenuTitle()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            buildStepProcess(title: '4/5', desc: 'select_payment'),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: data.length, // Use the data length
                  itemBuilder: (context, index) {
                    final account =
                        data[index]; // Access the current item in data

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              // Add your onTap logic here
                              paymentController
                                  .reqCashOut(
                                      transID: controller.rxtransid.value,
                                      amount: controller.rxPaymentAmount.value,
                                      toAcc: controller.rxaccnumber.value,
                                      chanel: homeController
                                          .menudetail.value.groupNameEN,
                                      provider:
                                          controller.tempAdetail.value.code,
                                      remark: controller.rxNote.value)
                                  .then((value) => {
                                        if (value)
                                          {Get.to(() => ConfirmTempAScreen())}
                                      });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey
                                    .shade200, // Change background color if selected
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1, // Change border width if selected
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 27.sp,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: account['logo'] != ''
                                        ? CachedNetworkImageProvider(
                                            account['logo'].toString())
                                        : account['payment_type'] == 'mmoney'
                                            ? AssetImage(MyIconOld.logox_jpg)
                                            : account['payment_type'] ==
                                                    'master_card'
                                                ? AssetImage(
                                                    MyIconOld.master_card)
                                                : account['payment_type'] ==
                                                        'union_pay'
                                                    ? AssetImage(
                                                        MyIconOld.union_pay)
                                                    : AssetImage(
                                                        MyIconOld.logox_jpg),
                                    child: (account['logo'] == '') &&
                                            account['payment_type'] !=
                                                'mmoney' &&
                                            account['payment_type'] !=
                                                'master_card'
                                        ? Icon(Icons.error,
                                            color: color_primary_light)
                                        : null,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        account['order'] == 1
                                            ? TextFont(
                                                text:
                                                    'Primary', // Use data title
                                                poppin: true,
                                                color: color_primary_light,
                                                fontSize: 10,
                                              )
                                            : SizedBox.shrink(),
                                        TextFont(
                                          text: account['title'].toString() ??
                                              "No Name", // Use data title
                                          poppin: true,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TextFont(
                                          text: account['description']
                                                  .toString() ??
                                              "N/A", // Use data description
                                          poppin: true,
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
