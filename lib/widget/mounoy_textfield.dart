// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/scanqr/qr_scanner.dart';
import 'package:super_app/widget/textfont.dart';

class textfieldAccountingWithButton extends StatelessWidget {
  const textfieldAccountingWithButton({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.max,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.focus,
    this.fillcolor = color_fafa,
    this.bordercolor = color_ddd,
    this.suffixWidgetData,
    required this.buttonText,
    this.onButtonPressed,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final int? max;
  final IconData? suffixIcon;
  final Function()? suffixonTapFuc;
  final FocusNode? focus;
  final Color fillcolor;
  final Color bordercolor;
  final Widget? suffixWidgetData;
  final String buttonText;
  final Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: bordercolor, width: 1.5),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(text: label),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: fillcolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: name,
                  controller: controller,
                  focusNode: focus,
                  keyboardType: TextInputType.number,
                  maxLength: max,
                  style: languageCode == 'lo'
                      ? GoogleFonts.notoSerifLao(
                          color: cr_7070,
                          fontSize: 12.5.sp,
                        )
                      : GoogleFonts.poppins(
                          color: cr_7070,
                          fontSize: 12.5.sp,
                        ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    hintText: hintText.tr,
                    hintStyle: languageCode == 'lo'
                        ? GoogleFonts.notoSerifLao(
                            color: cr_7070.withOpacity(0.8),
                            fontSize: 12.5.sp,
                          )
                        : GoogleFonts.poppins(
                            color: cr_7070.withOpacity(0.8),
                            fontSize: 12.5.sp,
                          ),
                    fillColor: fillcolor,
                    filled: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    //! Hide counter length text
                    counter: SizedBox.shrink(),
                    //! Error styles
                    errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
                    focusedErrorBorder: border,
                    errorBorder: border,
                    suffixIcon: suffixWidgetData == null
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [suffixWidgetData!],
                          ),
                  ),
                  inputFormatters: [ThousandsFormatter()],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: color_primary_light, // Button background color
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: TextButton(
                  onPressed: onButtonPressed,
                  child: TextFont(text: buttonText, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TextfieldWithScanButton extends StatelessWidget {
  const TextfieldWithScanButton({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.max,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.focus,
    this.fillcolor = color_fafa,
    this.bordercolor = color_ddd,
    this.suffixWidgetData,
    required this.buttonText,
    required this.onScanned,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final int? max;
  final IconData? suffixIcon;
  final Function()? suffixonTapFuc;
  final FocusNode? focus;
  final Color fillcolor;
  final Color bordercolor;
  final Widget? suffixWidgetData;
  final String buttonText;
  final Function(String scannedResult) onScanned;

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: bordercolor, width: 1.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(text: label),
        SizedBox(height: 4),
        Container(
          // Ensure the stack has a height constraint
          // height: 60.sp, // Set the height to match the TextField and Button height
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(right: 50.sp), // Margin to leave space for button
                child: FormBuilderTextField(
                  name: name,
                  controller: controller,
                  focusNode: focus,
                  maxLength: max,
                  style: languageCode == 'lo' ? GoogleFonts.notoSerifLao(color: cr_7070, fontSize: 12.5.sp) : GoogleFonts.poppins(color: cr_7070, fontSize: 12.5.sp),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    hintText: hintText.tr,
                    hintStyle: languageCode == 'lo' ? GoogleFonts.notoSerifLao(color: cr_7070, fontSize: 12.5.sp) : GoogleFonts.poppins(color: cr_7070, fontSize: 12.5.sp),
                    fillColor: fillcolor,
                    filled: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    counter: SizedBox.shrink(),
                    errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
                    focusedErrorBorder: border,
                    errorBorder: border,
                  ),
                  // inputFormatters: [ThousandsFormatter()],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),

              // QR Scan Button, positioned to the right
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 43.sp,
                  width: 43.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final result = await Get.to(() => QRScannerScreen());
                      if (result != null) {
                        onScanned(result);
                      }
                    },
                    icon: Image.asset('assets/icons/scan.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
