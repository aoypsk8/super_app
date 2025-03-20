// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/qr_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/input_cvv.dart';
import 'package:super_app/widget/textfont.dart';

class LaoQrPaymentScreen extends StatefulWidget {
  LaoQrPaymentScreen({super.key});

  @override
  State<LaoQrPaymentScreen> createState() => _LaoQrPaymentScreenState();
}

class _LaoQrPaymentScreenState extends State<LaoQrPaymentScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final qrController = Get.put(QrController());
  final paymentController = Get.put(PaymentController());
  bool isMore = false;
  bool isMoreText = false;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final storage = GetStorage();

  final _paymentAmount = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    userController.increasepage();
    Future.delayed(Duration(milliseconds: 500), () {
      qrController.enableBottom.value = true;
    });
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
      () => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: color_fff,
          appBar: BuildAppBar(
            title: qrController.qrModel.value.provider.toString(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  FadeInDown(
                    duration: Durations.long4,
                    child:
                        buildStepProcess(title: "1/3", desc: "transfer_laoQR"),
                  ),
                  FadeInDown(
                    duration: Durations.long4,
                    child: buildHeader(),
                  ),
                  FadeInDown(
                    duration: Durations.long4,
                    child: buildDetailPayment(),
                  ),
                  SizedBox(height: 20.h)
                ],
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
              title: 'next',
              isEnabled: qrController.enableBottom.value,
              func: () async {
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  Get.to(
                    ListsPaymentScreen(
                      description: 0,
                      stepBuild: '2/3',
                      title: homeController.getMenuTitle(),
                      onSelectedPayment: (paymentType, cardIndex, uuid) async {
                        if (paymentType == 'MMONEY') {
                          qrController.rxTransID.value =
                              'L${qrController.rxTransID.value}';
                          qrController.rxPaymentAmount.value = int.parse(
                              _paymentAmount.text.toString() == ''
                                  ? '0'
                                  : _paymentAmount.text
                                      .toString()
                                      .replaceAll(RegExp(r'[^\w\s]+'), ''));
                          qrController.rxNote.value = _note.text;
                          qrController.rxTotalAmount.value =
                              qrController.rxPaymentAmount.value;
                          await qrController.QueryFee();
                          //!Check TransAmount+Fee < BalanceAmount
                          var totalAmount = qrController.rxTotalAmount.value +
                              qrController.rxFeeConsumer.value;
                          if (totalAmount < userController.mainBalance.value) {
                            paymentController
                                .reqCashOut(
                                    transID: qrController.rxTransID.value,
                                    amount: qrController.rxTotalAmount.value,
                                    toAcc:
                                        qrController.qrModel.value.merchantName,
                                    chanel: 'QR',
                                    provider:
                                        qrController.qrModel.value.provider,
                                    remark: qrController.rxNote.value)
                                .then((value) => {
                                      if (value)
                                        {navigateToConfirmScreen(paymentType)}
                                    });
                          } else {
                            qrController.enableBottom.value = true;
                            DialogHelper.showErrorDialogNew(
                              description: 'Your balance not enough.',
                            );
                          }
                        } else {
                          qrController.rxTransID.value =
                              'XXL${qrController.rxTransID.value}';
                          qrController.rxPaymentAmount.value = int.parse(
                              _paymentAmount.text.toString() == ''
                                  ? '0'
                                  : _paymentAmount.text
                                      .toString()
                                      .replaceAll(RegExp(r'[^\w\s]+'), ''));
                          qrController.rxNote.value = _note.text;
                          qrController.rxTotalAmount.value =
                              qrController.rxPaymentAmount.value;
                          await qrController.QueryFee();
                          qrController.rxTotalAmount.value =
                              qrController.rxPaymentAmount.value +
                                  qrController.rxFeeConsumer.value;
                          paymentController
                              .reqCashOut(
                            transID: qrController.rxTransID.value,
                            amount: qrController.rxTotalAmount.value,
                            toAcc: qrController.qrModel.value.merchantName,
                            chanel: 'QR',
                            provider: qrController.qrModel.value.provider,
                            remark: qrController.rxNote.value,
                          )
                              .then((value) async {
                            if (value) {
                              homeController.RxamountUSD.value =
                                  await homeController.convertRate(
                                      qrController.rxTotalAmount.value);
                              String? cvv =
                                  await showDynamicQRDialog(context, () {});
                              if (cvv != null && cvv.trim().length >= 3) {
                                navigateToConfirmScreen(
                                  paymentType,
                                  cvv,
                                  uuid,
                                );
                              } else {
                                qrController.enableBottom.value = true;
                                DialogHelper.showErrorDialogNew(
                                  description: "please_input_cvv",
                                );
                              }
                            }
                          });
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildHeader() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeInRight(
            delay: Durations.medium2,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(vertical: 10),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // color: cr_fdeb,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: buildUserDetail(
                      profile:
                          userController.userProfilemodel.value.profileImg ??
                              MyConstant.profile_default,
                      from: true,
                      msisdn: userController.rxMsisdn.value,
                      name: userController.profileName.value,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const buildDotLine(color: cr_ef33, dashlenght: 7),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: buildUserDetail(
                      profile: qrController.qrModel.value.logoUrl ??
                          MyConstant.profile_default,
                      from: false,
                      msisdn: qrController.qrModel.value.provider.toString(),
                      name: qrController.qrModel.value.shopName.toString(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDetailPayment() {
    var chkType = qrController.qrModel.value.qrType!;
    if (chkType == "dynamic" ||
        int.parse(qrController.qrModel.value.transAmount!) > 0) {
      _paymentAmount.text =
          fn.format(double.parse(qrController.qrModel.value.transAmount!));
    }
    final List<String> amountValue = [
      '10,000',
      '25,000',
      '30,000',
      '100,000',
      '500,000',
      '1,000,000',
    ];
    final List<String> textValue = [
      "ເຕີມເງິນ",
      "ຄ່າເຄື່ອງ",
      "ຄ່າອາຫານ",
      "ຄ່າເຄື່ອງດື່ມ",
      "ເກັບອອມ",
      "ໃຊ້ໜີ້",
      "ຊ່ວຍເຫຼືອ",
      "ການສຶກສາ"
    ];
    return Container(
      color: color_fff,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            buildAccountingFiledVaidate(
              controller: _paymentAmount,
              label: 'amount_kip',
              name: 'amount',
              hintText: '0',
              max: 11,
              enable: (chkType == "dynamic" ||
                      int.parse(qrController.qrModel.value.transAmount!) > 0)
                  ? false
                  : true,
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
                      fontSize: 10,
                    ),
                  ],
                ),
              ),
              suffixonTapFuc: () {},
            ),
            isMore
                ? GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: amountValue.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 7 / 2.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          _paymentAmount.text = amountValue[index];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: color_f5f5,
                              borderRadius: BorderRadius.circular(6)),
                          child: Center(
                            child: TextFont(
                              text: amountValue[index],
                              color: color_blackE72,
                              poppin: true,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: isMore
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMore = isMore ? false : true;
                              });
                            },
                            child: TextFont(
                              text: 'less',
                              color: color_777,
                              fontSize: 8,
                              underline: true,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up_rounded,
                              size: 15.sp, color: color_777),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMore = isMore ? false : true;
                            });
                          },
                          child: TextFont(
                            text: 'more',
                            color: color_777,
                            fontSize: 8,
                            underline: true,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 15.sp, color: color_777),
                      ],
                    ),
            ),
            SizedBox(height: 4),
            const SizedBox(height: 14),
            BuildTextAreaValidate(
              label: 'note',
              controller: _note,
              name: 'note',
              iconColor: color_f4f4,
              hintText: 'input_text',
            ),
            isMoreText
                ? GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: textValue.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 7 / 2.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          _note.text = textValue[index];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color_f5f5,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: TextFont(
                              text: textValue[index],
                              color: color_blackE72,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: isMoreText
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMoreText = isMoreText ? false : true;
                              });
                            },
                            child: TextFont(
                              text: 'less',
                              color: color_777,
                              fontSize: 8,
                              underline: true,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up_rounded,
                              size: 15.sp, color: color_777),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMoreText = isMoreText ? false : true;
                            });
                          },
                          child: TextFont(
                            text: 'more',
                            color: color_777,
                            fontSize: 8,
                            underline: true,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 15.sp, color: color_777),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToConfirmScreen(String paymentType,
      [String cvv = '', String storedCardUniqueID = '']) {
    Get.to(
      () => ReusableConfirmScreen(
        isUSD: paymentType != 'MMONEY',
        isEnabled: qrController.enableBottom,
        appbarTitle: "confirm_payment",
        function: () {
          qrController.enableBottom.value = false;
          if (paymentType == 'MMONEY') {
            if (qrController.qrModel.value.provider == "LMM") {
              qrController.paymentQR();
            } else {
              qrController.paymentLaoQR();
            }
          } else {
            qrController.paymentLaoQRVisa(
              homeController.menudetail.value,
              storedCardUniqueID,
              cvv,
            );
          }
        },
        stepProcess: "3/3",
        stepTitle: "detail",
        fromAccountImage: userController.userProfilemodel.value.profileImg ??
            MyConstant.profile_default,
        fromAccountName:
            '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}',
        fromAccountNumber:
            userController.userProfilemodel.value.msisdn.toString(),
        toAccountImage:
            qrController.qrModel.value.logoUrl ?? MyConstant.profile_default,
        toAccountName: qrController.qrModel.value.shopName.toString(),
        toAccountNumber: qrController.qrModel.value.provider.toString(),
        amount: qrController.rxPaymentAmount.value.toString(),
        fee: paymentType == 'MMONEY'
            ? qrController.rxFee.value.toString()
            : qrController.rxFeeConsumer.value.toString(),
        note: qrController.rxNote.value,
      ),
    );
  }
}
