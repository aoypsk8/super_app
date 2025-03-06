// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashIn_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({super.key});

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final UserController userController = Get.find();
  final TextEditingController _paymentAmount = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final cashInController = Get.put(CashInController());
  int? selectedIndex;

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
    _paymentAmount.addListener(() {
      if (_paymentAmount.text.isNotEmpty && selectedIndex != null) {
        setState(() {
          selectedIndex = null;
        });
      }
    });
    return Obx(
      () => Scaffold(
        backgroundColor: color_fff,
        appBar: BuildAppBar(title: "cash_in"),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: FormBuilder(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFont(
                  //   text: 'input_amount',
                  //   fontWeight: FontWeight.w500,
                  //   fontSize: 12.sp,
                  // ),
                  buildStepProcess(title: "1/2", desc: "input_amount"),
                  const SizedBox(height: 10),
                  buildAccountingFiledVaidate(
                    controller: _paymentAmount,
                    label: 'amount_transfer',
                    name: 'amount',
                    focus: _amountFocusNode,
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
                  const SizedBox(height: 10),
                  showSelectMenu()
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 20),
          child: buildBottomAppbar(
            title: 'next',
            isEnabled: !cashInController.loading.isTrue,
            func: () async {
              String requestValue = await randomNumber().fucRandomNumber();
              // cashInController.requestId.value = "LQR$requestValue";
              cashInController.requestId.value = "LQRIN$requestValue";
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                String sanitizedAmount =
                    _paymentAmount.text.replaceAll(',', '');
                cashInController.txnAmount.value = sanitizedAmount.toString();
                if (int.parse(sanitizedAmount) < 1000) {
                  DialogHelper.showErrorDialogNew(description: "morethan1000");
                } else if (int.parse(sanitizedAmount) > 20000000) {
                  DialogHelper.showErrorDialogNew(description: "limit20000000");
                } else {
                  // Get.toNamed("/confirmCashIN");
                  await userController.fetchBalance();
                  final limitBalance = int.parse(userController
                      .balanceModel.value.data!.limitBalance
                      .toString());
                  final amount = int.parse(sanitizedAmount.toString());
                  if (userController.mainBalance.value + amount <=
                      limitBalance) {
                    cashInController.generateDynamicQR();
                  } else {
                    DialogHelper.showErrorDialogNew(
                        description: "morethanlimitbalance");
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showSelectMenu() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(
            text: 'select_your_amount',
          ),
          SizedBox(height: 10.sp),
          AlignedGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            itemCount: cashInController.prepaidAmounts.length,
            primary: false,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 3,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () {
                        _paymentAmount.text =
                            cashInController.prepaidAmounts[index].toString();
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index ? cr_fdeb : color_f4f4,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: selectedIndex == index ? cr_ef33 : color_fff,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFont(
                              text: NumberFormat('#,###').format(int.parse(
                                  cashInController.prepaidAmounts[index]
                                      .toString())),
                              color: color_blackE72,
                              poppin: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
