import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/mounoy_textfield.dart';
import 'package:super_app/widget/textfont.dart';

class PaymentTempAScreen extends StatelessWidget {
  PaymentTempAScreen({Key? key}) : super(key: key);

  final controller = Get.find<TempAController>();
  final _paymentAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'ຈ່າຍຄ່ານ້ຳປະປາ'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            buildStepProcess(title: '3/4', desc: 'input_amount'),
            const SizedBox(height: 16),
            // Info Card
            Container(
              decoration: BoxDecoration(
                color: color_fdeb,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CachedNetworkImage(
                            imageUrl: controller.tempAdetail.value.logo ?? ''),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: controller.tempAdetail.value.title ?? '',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          TextFont(
                              text: controller.rxaccname.value, fontSize: 12),
                          TextFont(text: controller.rxaccnumber.value),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                TextFont(
                                  text: fn.format(
                                          int.parse(controller.debit.value)) ??
                                      '',
                                  // text: '999,999,999,999',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: color_primary_light,
                                  poppin: true,
                                ),
                                TextFont(
                                  text: '.00 LAK',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: color_primary_light,
                                  poppin: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            textfieldAccountingWithButton(
              controller: _paymentAmount,
              label: 'amount_kip',
              name: 'name',
              hintText: '0',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
              suffixWidgetData: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextFont(
                  text: '.00 LAK',
                  color: cr_7070,
                  fontSize: 9,
                ),
              ),
              buttonText: 'all',
              onButtonPressed: () => _paymentAmount.text =
                  fn.format(int.parse(controller.debit.value)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BuildButtonBottom(
        title: 'next',
        isActive: true,
        func: () {
          // Add your function here
        },
      ),
    );
  }
}
