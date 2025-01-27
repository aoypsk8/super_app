// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/finance_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

import '../../widget/myIcon.dart';

class PaymentFinanceScreen extends StatefulWidget {
  const PaymentFinanceScreen({super.key});

  @override
  State<PaymentFinanceScreen> createState() => _PaymentFinanceScreenState();
}

class _PaymentFinanceScreenState extends State<PaymentFinanceScreen> {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  final financeController = Get.put(FinanceController());

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final fn = NumberFormat('#,###', 'en_US');
  final storage = GetStorage();
  final _paymentAmount = TextEditingController();
  final _note = TextEditingController();

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
    return Scaffold(
      appBar: BuildAppBar(
          title: "homeController.menudetail.value.groupNameEN.toString()"),
      body: FooterLayout(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Column(
              children: [
                billdetail(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        footer: btnconfirmamount(),
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
          TextFont(
            text: 'detail',
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
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
                  financeController.financeModelDetail.value.logo!,
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
                          text: financeController.rxAccNo.value,
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
                            // text: 'ຊື່ ແລະ ນາມສະກຸນ',
                            text: 'fullname',
                            color: color_777,
                          ),
                          Expanded(
                            child: TextFont(
                              text: financeController.rxAccName.value,
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
              ],
            ),
          ),
          const SizedBox(height: 14),
          FormBuilder(key: _formKey, child: fieldamount()),
          const SizedBox(height: 14),
          fieldNote(),
        ],
      ),
    );
  }

  Widget fieldamount() {
    return buildAccountingFiledVaidate(
      controller: _paymentAmount,
      label: 'amount_kip',
      name: 'wallet',
      hintText: '0,000',
      max: 10,
      fillcolor: color_f4f4,
      bordercolor: color_f4f4,
      suffixWidget: true,
      suffixWidgetData: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(Iconsax.close_circle5, color: color_bbb, size: 6.w),
      ),
      suffixonTapFuc: () async {
        _paymentAmount.text = '';
      },
    );
  }

  Widget fieldNote() {
    return BuildTextAreaValidate(
      label: 'note',
      controller: _note,
      name: '_note',
      iconColor: color_f4f4,
      hintText: 'input_text',
    );
  }

  Widget btnconfirmamount() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(top: 20),
      decoration:
          BoxDecoration(color: color_fff, border: Border.all(color: color_ddd)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildBottomAppbar(
            title: 'next',
            func: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                if (int.parse(_paymentAmount.text
                        .replaceAll(RegExp(r'[^\w\s]+'), '')) <
                    1000) {
                  DialogHelper.showErrorDialogNew(
                      description: 'Minimum payment must than 1,000 Kip.');
                } else {
                  financeController.rxNote.value = _note.text;
                  financeController.rxPaymentAmount.value =
                      _paymentAmount.text.replaceAll(RegExp(r'[^\w\s]+'), '');
                  Get.toNamed("/confirmFinance");
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
