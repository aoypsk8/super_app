import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_b_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_pay_visa.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/input_cvv.dart';
import 'package:super_app/widget/mounoy_textfield.dart';
import 'package:super_app/widget/textfont.dart';

class PaymentTempBScreen extends StatelessWidget {
  PaymentTempBScreen({super.key});

  final controller = Get.find<TempBController>();
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();

  final PaymentController paymentController = Get.put(PaymentController());

  final _formKey = GlobalKey<FormBuilderState>();
  final _paymentAmount = TextEditingController();
  final _note = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: homeController.getMenuTitle()),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildStepProcess(title: '3/5', desc: 'input_amount'),
                const SizedBox(height: 16),
                buildDetailDebt(context),
                const SizedBox(height: 8),
                buildFormPayment(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomAppbar(
          title: 'next',
          isEnabled: controller.enableBottom.value,
          func: () async {
            controller.enableBottom.value = false;
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              String sanitizedAmount =
                  _paymentAmount.text.replaceAll(RegExp(r'[^\w\s]+'), '');
              controller.rxNote.value = _note.text;
              controller.rxPaymentAmount.value = sanitizedAmount.toString();
              if (int.parse(sanitizedAmount) < 1000) {
                controller.enableBottom.value = true;
                DialogHelper.showErrorDialogNew(description: "morethan1000");
              } else {
                if (userController.totalBalance.value >=
                    int.parse(sanitizedAmount)) {
                  controller.rxTransID.value =
                      homeController.menudetail.value.description.toString() +
                          await randomNumber().fucRandomNumber();
                  controller.enableBottom.value = true;
                  Get.to(
                    () => ListsPaymentScreen(
                      description: homeController.menudetail.value.appid!,
                      stepBuild: '4/5',
                      title: homeController.getMenuTitle(),
                      onSelectedPayment: (paymentType, cardIndex, uuid, logo,
                          accName, cardNumber) async {
                        paymentController
                            .reqCashOut(
                          transID: controller.rxTransID.value,
                          amount: controller.rxPaymentAmount.value,
                          toAcc: controller.rxAccNo.value,
                          chanel: homeController.menudetail.value.groupNameEN,
                          provider: controller.tempBdetail.value.nameCode,
                          remark: controller.rxNote.value,
                        )
                            .then(
                          (value) async {
                            if (value) {
                              if (paymentType == "Other") {
                                // homeController.RxamountUSD.value =
                                //     await homeController.convertRate(int.parse(
                                //         controller.rxPaymentAmount.value));
                                // controller.rxTransID.value =
                                //     "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
                                // //! Confirm CashOut
                                // Get.to(PaymentVisaMasterCard(
                                //   function: () {
                                //     controller
                                //         .paymentProcessVisaWithoutstoredCardUniqueID(
                                //             homeController.menudetail.value);
                                //   },
                                //   trainID: controller.rxTransID.value,
                                //   description: controller.rxNote.value,
                                //   amount: int.parse(
                                //       controller.rxPaymentAmount.value),
                                // ));
                              } else if (paymentType == 'MMONEY') {
                                navigateToConfirmScreen(paymentType);
                              } else {
                                String? cvv =
                                    await showDynamicQRDialog(context, () {});
                                if (cvv != null &&
                                    cvv.isNotEmpty &&
                                    cvv.length >= 3) {
                                  navigateToConfirmScreen(paymentType, cvv,
                                      uuid, logo, accName, cardNumber);
                                } else {
                                  DialogHelper.showErrorDialogNew(
                                    description: "please_input_cvv",
                                  );
                                }
                              }
                            } else {
                              controller.enableBottom.value = true;
                            }
                          },
                        );
                      },
                    ),
                  );
                } else {
                  controller.enableBottom.value = true;
                  DialogHelper.showErrorDialogNew(
                      description: 'Your balance not enough.');
                }
              }
            }
          }),
    );
  }

  FormBuilder buildFormPayment() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          buildAccountingFiledVaidate(
            controller: _paymentAmount,
            label: 'amount_transfer',
            name: 'amount',
            hintText: '0',
            max: 11,
            fillcolor: color_f4f4,
            bordercolor: color_f4f4,
            suffixWidget: true,
            suffixWidgetData: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFont(
                    text: '.00 LAK',
                    color: cr_7070,
                    fontSize: 10.sp,
                  ),
                ],
              ),
            ),
            suffixonTapFuc: () {},
          ),
          const SizedBox(height: 8),
          LongTextField(
            controller: _note,
            label: 'note',
            name: 'note',
            hintText: 'detail',
            isRequire: false,
          )
        ],
      ),
    );
  }

  Container buildDetailDebt(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CachedNetworkImage(
                    imageUrl: controller.tempBdetail.value.logo ?? ''),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFont(
                    text: controller.tempBdetail.value.nameEn ?? '',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    noto: true,
                  ),
                  TextFont(
                    text: controller.rxAccName.value,
                    fontSize: 12,
                    noto: true,
                  ),
                  TextFont(
                    text: controller.rxAccNo.value,
                    poppin: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToConfirmScreen(
    String paymentType, [
    String cvv = '',
    String storedCardUniqueID = '',
    String? logo,
    String accName = '',
    String cardNumber = '',
  ]) {
    logo ??= MyConstant.profile_default;
    Get.to(() => ReusableConfirmScreen(
          isEnabled: controller.enableBottom,
          appbarTitle: "confirm_payment",
          function: () {
            if (paymentType == 'MMONEY') {
              controller.isLoading.value = true;
              controller.enableBottom.value = false;
              controller.paymentProcess(homeController.menudetail.value);
            } else {
              controller.paymentProcessVisa(
                homeController.menudetail.value,
                storedCardUniqueID,
                cvv,
                paymentType,
                logo!,
                accName,
                cardNumber,
              );
            }
          },
          stepProcess: "5/5",
          stepTitle: "check_detail",
          fromAccountImage: paymentType == 'MMONEY'
              ? (userController.userProfilemodel.value.profileImg ??
                  MyConstant.profile_default)
              : (logo ?? MyConstant.profile_default),
          fromAccountName: paymentType == 'MMONEY'
              ? '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}'
              : accName,
          fromAccountNumber: paymentType == 'MMONEY'
              ? userController.userProfilemodel.value.msisdn.toString()
              : cardNumber,
          toAccountImage: controller.tempBdetail.value.logo ?? '',
          toAccountName: controller.rxAccName.value, // Fixed swapped values
          toAccountNumber: controller.rxAccNo.value,
          amount: controller.rxPaymentAmount.value,
          fee: controller.tempBdetail.value.fee ?? '0', // Prevent null error
          note: controller.rxNote.value,
        ));
  }
}
