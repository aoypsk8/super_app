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
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/views/templateB/confirm_tempB.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/mounoy_textfield.dart';
import 'package:super_app/widget/textfont.dart';

class PaymentTempBScreen extends StatelessWidget {
  PaymentTempBScreen({Key? key}) : super(key: key);

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
      bottomNavigationBar: BuildButtonBottom(
          title: 'next',
          isActive: true,
          func: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              String sanitizedAmount =
                  _paymentAmount.text.replaceAll(RegExp(r'[^\w\s]+'), '');
              controller.rxNote.value = _note.text;
              controller.rxPaymentAmount.value = sanitizedAmount.toString();
              if (int.parse(sanitizedAmount) < 1000) {
                DialogHelper.showErrorDialogNew(description: "morethan1000");
              } else {
                if (userController.mainBalance.value >=
                    int.parse(sanitizedAmount)) {
                  controller.rxTransID.value =
                      homeController.menudetail.value.description.toString() +
                          await randomNumber().fucRandomNumber();
                  Get.to(
                    () => ListsPaymentScreen(
                      description: 'select_payment',
                      stepBuild: '4/5',
                      title: homeController.getMenuTitle(),
                      onSelectedPayment: () {
                        Get.to(() => const ConfirmTempBScreen());
                        return Container();
                      },
                    ),
                  );
                } else {
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
}
