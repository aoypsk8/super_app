import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/ticket_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/build_pay_visa.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/input_cvv.dart';
import 'package:super_app/widget/textfont.dart';

class TicketPaymentScreen extends StatefulWidget {
  const TicketPaymentScreen({super.key});

  @override
  State<TicketPaymentScreen> createState() => _TicketPaymentScreenState();
}

class _TicketPaymentScreenState extends State<TicketPaymentScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final ticketController = Get.put(TicketController());

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
        appBar: BuildAppBar(
            title: ticketController.ticketDetail.value.title.toString()),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildStepProcess(title: "1/3", desc: "detail"),
                const SizedBox(height: 5),
                SizedBox(
                  width: Get.width,
                  height: 55.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ticketController.ticketDetail.value.logo!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFont(
                  text: ticketController.ticketDetail.value.title!,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  color: cr_2929,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12.sp,
                      color: cr_7070,
                    ),
                    const SizedBox(width: 3),
                    TextFont(
                      text: ticketController.ticketDetail.value.dateEvent
                          .toString(),
                      fontSize: 11,
                      noto: true,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: cr_7070,
                    ),
                    const SizedBox(width: 3),
                    TextFont(
                      text: ticketController.ticketDetail.value.location
                          .toString(),
                      fontSize: 11,
                      noto: true,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: cr_ecec,
                  thickness: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextFont(
                          text: 'price',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                          color: cr_2929,
                        ),
                        TextFont(
                          text: ' : ',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          maxLines: 2,
                          color: cr_2929,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFont(
                          text: NumberFormat('#,###').format(double.parse(
                              ticketController.ticketDetail.value.price
                                  .toString())),
                          fontWeight: FontWeight.w500,
                          color: cr_b326,
                          poppin: true,
                          fontSize: 17,
                        ),
                        SizedBox(width: 5),
                        TextFont(
                          text: 'kip',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: cr_b326,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildBottomAppbar(
          bgColor: Theme.of(context).primaryColor,
          title: 'next',
          func: () async {
            if (userController.mainBalance.value >=
                ticketController.ticketDetail.value.price!) {
              ticketController.rxTransID.value =
                  homeController.menudetail.value.description.toString() +
                      await randomNumber().fucRandomNumber();
              Get.to(
                ListsPaymentScreen(
                  description: homeController.menudetail.value.appid!,
                  stepBuild: '2/3',
                  title: homeController.getMenuTitle(),
                  onSelectedPayment: (paymentType, cardIndex, uuid) async {
                    if (paymentType == "Other") {
                      // homeController.RxamountUSD.value =
                      //     await homeController.convertRate(
                      //         ticketController.ticketDetail.value.price!);
                      // ticketController.rxTransID.value =
                      //     "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
                      // Get.to(PaymentVisaMasterCard(
                      //   function: () {
                      //     ticketController
                      //         .paymentProcessVisaWithoutstoredCardUniqueID(
                      //       homeController.menudetail.value,
                      //     );
                      //   },
                      //   trainID: ticketController.rxTransID.value,
                      //   description: ticketController.rxNote.value,
                      //   amount:
                      //       int.parse(ticketController.rxPaymentAmount.value),
                      // ));
                    } else if (paymentType == 'MMONEY') {
                      navigateToConfirmScreen(paymentType);
                    } else {
                      String? cvv = await showDynamicQRDialog(context, () {});
                      if (cvv != null && cvv.isNotEmpty && cvv.length >= 3) {
                        navigateToConfirmScreen(
                          paymentType,
                          cvv,
                          uuid,
                        );
                      } else {
                        DialogHelper.showErrorDialogNew(
                          description: "please_input_cvv",
                        );
                      }
                    }
                  },
                ),
              );
            } else {
              DialogHelper.showErrorDialogNew(
                  description: 'Your balance not enough.');
            }
          },
        ),
      ),
    );
  }

  void navigateToConfirmScreen(String paymentType,
      [String cvv = '', String storedCardUniqueID = '']) {
    Get.to(
      () => ReusableConfirmScreen(
        isEnabled: ticketController.enableBottom,
        appbarTitle: "confirm_payment",
        function: () {
          ticketController.enableBottom.value = false;
          if (paymentType == 'MMONEY') {
            ticketController.paymentProcess();
          } else {
            ticketController.paymentProcessVisa(
              homeController.menudetail.value,
              storedCardUniqueID,
              cvv,
            );
          }
        },
        stepProcess: "5/5",
        stepTitle: "detail",
        fromAccountImage: userController.userProfilemodel.value.profileImg ??
            MyConstant.profile_default,
        fromAccountName:
            '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}',
        fromAccountNumber:
            userController.userProfilemodel.value.msisdn.toString(),
        toAccountImage: ticketController.ticketDetail.value.logo ??
            MyConstant.profile_default,
        toAccountName: ticketController.ticketDetail.value.title!,
        toAccountNumber:
            ticketController.ticketDetail.value.description.toString(),
        amount: ticketController.rxPaymentAmount.value,
        fee: '0',
        note: ticketController.rxNote.value,
      ),
    );
  }
}
