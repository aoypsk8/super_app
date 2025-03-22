// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_pay_visa.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/input_cvv.dart';
import 'package:super_app/widget/textfont.dart';
import '../../../utility/dialog_helper.dart';
import 'package:intl/intl.dart';

class PaymentPostpaidTempCScreen extends StatefulWidget {
  const PaymentPostpaidTempCScreen({super.key});

  @override
  State<PaymentPostpaidTempCScreen> createState() =>
      _PaymentPostpaidTempCScreenState();
}

class _PaymentPostpaidTempCScreenState
    extends State<PaymentPostpaidTempCScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempCcontroler = Get.put(TempCController());

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final storage = GetStorage();
  final _paymentAmount = TextEditingController();
  final _note = TextEditingController();
  final _noteFocusNode = FocusNode();

  @override
  void initState() {
    userController.increasepage();
    // Add listener to update total amount in real-time
    _paymentAmount.addListener(() {
      final cleaned = _paymentAmount.text.replaceAll(RegExp(r'[^\d]'), '');
      if (cleaned.isNotEmpty) {
        tempCcontroler.rxTotalAmount.value = int.tryParse(cleaned) ?? 0;
      } else {
        tempCcontroler.rxTotalAmount.value = 0;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  static const locale = 'en';
  String formatNumber(String s) =>
      NumberFormat.decimalPattern(locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_grey_background,
        appBar: BuildAppBar(title: homeController.menutitle.value),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: FooterLayout(
            child: SingleChildScrollView(
              child: FadeInUp(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      billdetail(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            footer: FadeInDown(child: btnconfirmamount()),
          ),
        ),
      ),
    );
  }

  Widget billdetail() {
    return Container(
      padding: const EdgeInsets.only(left: 26, right: 26, top: 16, bottom: 36),
      decoration: const BoxDecoration(
        color: color_fff,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          buildStepProcess(title: "4/6", desc: "detail"),
          const SizedBox(height: 14),
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(14),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1.0, color: Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Column(
              children: [
                Image.network(
                  tempCcontroler.tempCdetail.value.groupLogo.toString(),
                  width: 20.w,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFont(
                        text: 'account_number',
                        color: color_777,
                        fontWeight: FontWeight.bold,
                      ),
                      Expanded(
                        child: TextFont(
                          text: tempCcontroler.rxAccNo.value,
                          poppin: true,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: 'fullname',
                            color: color_777,
                          ),
                          Expanded(
                            child: TextFont(
                              text: tempCcontroler.rxAccName.value,
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              noto: true,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: 'type',
                            color: color_777,
                          ),
                          Expanded(
                            child: TextFont(
                              text: tempCcontroler.tempCservicedetail.value.name
                                  .toString(),
                              textAlign: TextAlign.right,
                              poppin: true,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: 'amount',
                            color: color_777,
                          ),
                          Expanded(
                            child: TextFont(
                              text: fn.format(double.parse(tempCcontroler
                                  .rxDebit.value
                                  .replaceAll('-', ''))),
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              color:
                                  double.parse(tempCcontroler.rxDebit.value) <=
                                          0
                                      ? Colors.green
                                      : Colors.red,
                              poppin: true,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          buildAccountingFiledVaidate(
            controller: _paymentAmount,
            label: 'amount_kip',
            name: 'amount',
            hintText: '0',
            max: 11,
            fillcolor: color_f4f4,
            bordercolor: color_f4f4,
            focus: _noteFocusNode,
            suffixWidget: true,
            suffixWidgetData: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFont(
                    text: '.00 LAK',
                    color: cr_7070,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
            suffixonTapFuc: () {},
          ),
          const SizedBox(height: 14),
          BuildTextAreaValidate(
            label: 'note',
            controller: _note,
            name: 'note',
            iconColor: color_f4f4,
            hintText: 'input_text',
          ),
        ],
      ),
    );
  }

  Widget btnconfirmamount() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(top: 10, left: 6, right: 6),
      decoration:
          BoxDecoration(color: color_fff, border: Border.all(color: color_ddd)),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.only(left: 26, right: 26, bottom: 0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextFont(
                            text: 'total_kip',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextFont(
                                  text: fn.format(
                                      tempCcontroler.rxTotalAmount.value),
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.right,
                                  poppin: true,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            buildBottomAppbar(
              title: 'next',
              isEnabled: tempCcontroler.enableBottom.value,
              func: () {
                tempCcontroler.enableBottom.value = false;
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  Future.delayed(MyConstant.delayTime).then(
                    (_) async {
                      if (int.parse(_paymentAmount.text
                              .replaceAll(RegExp(r'[^\w\s]+'), '')) <
                          1000) {
                        tempCcontroler.enableBottom.value = true;
                        DialogHelper.showErrorDialogNew(
                            description:
                                'Minimum payment must than 1,000 Kip.');
                      } else {
                        tempCcontroler.rxNote.value = _note.text;
                        tempCcontroler.rxPaymentAmount.value = int.parse(
                            _paymentAmount.text
                                .replaceAll(RegExp(r'[^\w\s]+'), ''));
                        tempCcontroler.rxTotalAmount.value = int.parse(
                            _paymentAmount.text
                                .replaceAll(RegExp(r'[^\w\s]+'), ''));
                        print(tempCcontroler.rxPaymentAmount.value);
                        paymentController
                            .reqCashOut(
                                transID: tempCcontroler.rxTransID.value,
                                amount: tempCcontroler.rxTotalAmount.value,
                                toAcc: tempCcontroler.rxAccNo.value,
                                chanel:
                                    homeController.menudetail.value.groupNameEN,
                                provider:
                                    "${tempCcontroler.tempCdetail.value.groupTelecom!}|${tempCcontroler.tempCservicedetail.value.name!}",
                                remark: tempCcontroler.rxNote.value)
                            .then(
                              (value) => {
                                if (value)
                                  {
                                    tempCcontroler.enableBottom.value = true,
                                    Get.to(ListsPaymentScreen(
                                      description: homeController
                                          .menudetail.value.appid!,
                                      stepBuild: '5/6',
                                      title: homeController.getMenuTitle(),
                                      onSelectedPayment: (paymentType,
                                          cardIndex,
                                          uuid,
                                          logo,
                                          accName,
                                          cardNumber) async {
                                        if (paymentType == "Other") {
                                          // homeController.RxamountUSD.value =
                                          //     await homeController.convertRate(
                                          //         tempCcontroler
                                          //             .rxTotalAmount.value);
                                          // tempCcontroler.rxTransID.value =
                                          //     "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
                                          // Get.to(PaymentVisaMasterCard(
                                          //   function: () {
                                          //     tempCcontroler
                                          //         .paymentPostpaidVisaWithoutstoredCardUniqueID(
                                          //       homeController.menudetail.value,
                                          //     );
                                          //   },
                                          //   trainID:
                                          //       tempCcontroler.rxTransID.value,
                                          //   description:
                                          //       tempCcontroler.rxNote.value,
                                          //   amount: tempCcontroler
                                          //       .rxTotalAmount.value,
                                          // ));
                                        } else if (paymentType == 'MMONEY') {
                                          navigateToConfirmScreen(paymentType);
                                        } else {
                                          String? cvv =
                                              await showDynamicQRDialog(
                                                  context, () {});
                                          if (cvv != null &&
                                              cvv.isNotEmpty &&
                                              cvv.length >= 3) {
                                            navigateToConfirmScreen(
                                                paymentType,
                                                cvv,
                                                uuid,
                                                logo,
                                                accName,
                                                cardNumber);
                                          } else {
                                            DialogHelper.showErrorDialogNew(
                                              description: "please_input_cvv",
                                            );
                                          }
                                        }
                                      },
                                    ))
                                  }
                                else
                                  {
                                    tempCcontroler.enableBottom.value = true,
                                  }
                              },
                            );
                      }
                    },
                  );
                } else {
                  tempCcontroler.enableBottom.value = true;
                }
              },
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
    Get.to(
      () => ReusableConfirmScreen(
        isEnabled: tempCcontroler.enableBottom,
        appbarTitle: "confirm_payment",
        function: () {
          tempCcontroler.enableBottom.value = false;
          if (paymentType == 'MMONEY') {
            tempCcontroler.paymentPostpaid(homeController.menudetail.value);
          } else {
            tempCcontroler.paymentPostpaidVisa(
              homeController.menudetail.value,
              storedCardUniqueID,
              cvv,
            );
          }
        },
        stepProcess: "6/6",
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
        toAccountImage: tempCcontroler.tempCdetail.value.groupLogo.toString(),
        toAccountName:
            '${tempCcontroler.rxAccName.value} - ${tempCcontroler.tempCdetail.value.groupTelecom} - ${tempCcontroler.tempCservicedetail.value.name}',
        toAccountNumber: tempCcontroler.rxAccNo.value,
        amount: tempCcontroler.rxPaymentAmount.value.toString(),
        fee: '0',
        note: tempCcontroler.rxNote.value,
      ),
    );
  }
}
