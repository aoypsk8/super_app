import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

Future<dynamic> showDynamicQRDialog(
    BuildContext context, VoidCallback function) async {
  final cvvController = TextEditingController();
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFont(text: 'input_cvv_code'),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color_f4f4,
              ),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
        content: FormBuilder(
          child: GestureDetector(
            onTap: () {
              function();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    buildNumberFiledValidate(
                      controller: cvvController,
                      label: 'fill_cvv',
                      name: 'cvv',
                      hintText: 'XXX',
                      max: 3,
                      fillcolor: color_f4f4,
                      bordercolor: color_f4f4,
                    ),
                    SizedBox(height: 20),
                    buildBottomAppbar(
                      high: 0,
                      margin: EdgeInsets.all(0),
                      bgColor: Theme.of(context).primaryColor,
                      title: 'next',
                      func: () {
                        Get.back(result: cvvController.text);
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
