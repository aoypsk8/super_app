import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/cashout/buildFavoriteCashOut.dart';
import 'package:super_app/views/cashout/buildHistoryCashOutAll.dart';
import 'package:super_app/views/cashout/buildHistoryCashOutRecent.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class VerifyAccountBankScreen extends StatefulWidget {
  const VerifyAccountBankScreen({super.key});

  @override
  State<VerifyAccountBankScreen> createState() =>
      _VerifyAccountBankScreenState();
}

class _VerifyAccountBankScreenState extends State<VerifyAccountBankScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final cashOutController = Get.put(CashOutController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _accountNumber = TextEditingController();
  final _paymentAmount = TextEditingController();
  final _note = TextEditingController();

  bool isMore = false;
  bool isMoreText = false;

  @override
  void initState() {
    userController.increasepage();
    cashOutController.fetchRecentBank();
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  void _updateParentValue(String AccNo, String AccName) {
    setState(() {
      _accountNumber.text = AccNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: cr_fbf7,
          appBar: BuildAppBar(title: "cashout"),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    buildToAccount(context),
                    const SizedBox(height: 12),
                    buildRecentCashOut(context),
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
              title: 'next',
              isEnabled: !cashOutController.loading.isTrue,
              func: () {
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  cashOutController.loading.value = true;
                  cashOutController.rxPaymentAmount.value =
                      _paymentAmount.text.replaceAll(RegExp(r'[^\w\s]+'), '');
                  cashOutController.rxNote.value = _note.text;
                  cashOutController.verifyAcc(_accountNumber.text);
                }
              },
            ),
          ),
        ));
  }

  Widget buildToAccount(BuildContext context) {
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // TextFont(
            //   text: 'transfer_to_bank',
            //   fontWeight: FontWeight.w500,
            //   fontSize: 12,
            // ),
            buildStepProcess(title: '2/3', desc: 'transfer_to_bank'),
            const SizedBox(height: 10),
            buildNumberFiledValidate(
              controller: _accountNumber,
              label: 'account_number',
              name: 'accountNumber',
              hintText: 'XXXXXXXX',
              max: 16,
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildAccountingFiledVaidate(
              controller: _paymentAmount,
              label: 'amount_kip',
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
                                isMore = !isMore;
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
                              isMore = !isMore;
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
                                isMoreText = !isMoreText;
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
                              isMoreText = !isMoreText;
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

  Widget buildRecentCashOut(BuildContext context) {
    return Container(
      color: color_fff,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 350,
              child: ContainedTabBarView(
                initialIndex: 0,
                tabBarProperties: TabBarProperties(
                  indicatorColor: Theme.of(context).primaryColor,
                ),
                tabBarViewProperties: TabBarViewProperties(
                  physics: NeverScrollableScrollPhysics(),
                ),
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.clock,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      TextFont(
                        text: 'recent',
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.heart,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      TextFont(
                        text: 'favorite',
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.like, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      TextFont(
                        text: 'all',
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
                views: [
                  buildHistoryCashOutRecent(
                    updateParentValue: _updateParentValue,
                  ),
                  buildFavoriteCashOut(
                    updateParentValue: _updateParentValue,
                  ),
                  buildHistoryCashOutAll(
                    updateParentValue: _updateParentValue,
                  ),
                ],
                onChange: (index) => print(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
