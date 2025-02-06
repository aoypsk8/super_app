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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TextfieldAccountingWithButton extends StatelessWidget {
  const TextfieldAccountingWithButton({
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
    this.fillcolor = const Color(0xFFF5F5F5), // Example fill color
    this.bordercolor = const Color(0xFFDDDDDD), // Example border color
    this.suffixWidgetData,
    required this.buttonText,
    this.onButtonPressed,
    this.isRequire = false,
    this.checkLimit = false,
    this.limitValue,
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
  final bool isRequire;
  final bool checkLimit; // Enable limit validation
  final int? limitValue; // Max limit for input values

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'en';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: bordercolor, width: 1.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label), // Adjusted for your existing TextFont widget if needed
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
                          color: const Color(0xFF292929), // Example text color
                          fontSize: 12.5.sp,
                        )
                      : GoogleFonts.poppins(
                          color: const Color(0xFF292929),
                          fontSize: 12.5.sp,
                        ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    hintText: hintText.tr,
                    hintStyle: languageCode == 'lo'
                        ? GoogleFonts.notoSerifLao(
                            color: const Color(0xFF707070).withOpacity(0.8),
                            fontSize: 12.5.sp,
                          )
                        : GoogleFonts.poppins(
                            color: const Color(0xFF707070).withOpacity(0.8),
                            fontSize: 12.5.sp,
                          ),
                    fillColor: fillcolor,
                    filled: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    counter: SizedBox.shrink(), // Hide counter text
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ThousandsFormatter(limit: checkLimit ? limitValue : null),
                  ],
                  validator: isRequire
                      ? FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ])
                      : null,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Button background color
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: TextButton(
                  onPressed: onButtonPressed,
                  // child: Text(buttonText, style: TextStyle(color: Colors.white)),
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

class _ThousandsFormatter extends TextInputFormatter {
  final int? limit;

  _ThousandsFormatter({this.limit});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String numericValue = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (limit != null && numericValue.isNotEmpty) {
      int parsedValue = int.parse(numericValue);
      if (parsedValue > limit!) {
        numericValue = limit.toString();
      }
    }
    String formattedValue = _formatNumber(numericValue);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value) ?? 0;
    return NumberFormat('#,###').format(number);
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
                  style: languageCode == 'lo' ? GoogleFonts.notoSerifLao(color: color_2929, fontSize: 12.5.sp) : GoogleFonts.poppins(color: color_2929, fontSize: 12.5.sp),
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

class LongTextField extends StatelessWidget {
  const LongTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.fillcolor = const Color(0xFFF2F2F2),
    this.bordercolor = const Color(0xFFF2F2F2),
    this.errorBorderColor = Colors.red,
    this.labelWeight = FontWeight.normal,
    this.suffixIconColor = Colors.black,
    this.isRequire = true,
    this.minLines = 3,
    this.maxLines,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final IconData? suffixIcon;
  final Function()? suffixonTapFuc;
  final Color fillcolor;
  final Color bordercolor;
  final Color errorBorderColor;
  final FontWeight labelWeight;
  final Color suffixIconColor;
  final bool isRequire;
  final int minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';

    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: bordercolor,
        width: 1.5,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: errorBorderColor,
        width: 1.5,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          TextFont(
            text: label,
            fontWeight: labelWeight,
          ),
          const SizedBox(height: 4),
          // FormBuilderTextField
          FormBuilderTextField(
            name: name,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: TextInputType.multiline,
            style: GoogleFonts.notoSansLao(fontSize: 13.sp, color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
              prefixIcon: icons != null ? Icon(icons, color: Colors.black) : null,
              suffixIcon: suffixonTapFuc != null
                  ? GestureDetector(
                      onTap: suffixonTapFuc,
                      child: Icon(suffixIcon, color: suffixIconColor),
                    )
                  : null,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              errorStyle: const TextStyle(height: 0), // Hide error message
            ),
            validator: isRequire
                ? FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ])
                : null,
          ),
        ],
      ),
    );
  }
}

class BuildDropDown extends StatelessWidget {
  const BuildDropDown({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    required this.dataObject,
    required this.colName,
    required this.valName,
    required this.onChanged,
    this.initValue,
    this.isEditable = true,
    this.bordercolor = const Color(0xFFF2F2F2),
    this.errorBorderColor = Colors.red,
    this.fillcolor = const Color(0xFFF2F2F2),
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final List<Map<String, Object>> dataObject;
  final String colName;
  final String valName;
  final String? initValue;
  final Function(String?) onChanged;
  final bool isEditable;
  final Color bordercolor;
  final Color errorBorderColor;
  final Color fillcolor;

  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: bordercolor,
        width: 1.5,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: errorBorderColor,
        width: 1.5,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          const SizedBox(height: 4),
          FormBuilderDropdown(
            name: name,
            initialValue: initValue,
            enabled: isEditable, // Disable dropdown when false
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: icons != null ? Icon(icons, color: Colors.black) : null,

              fillColor: fillcolor,
              filled: true,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
              errorBorder: errorBorder, // Custom disabled border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: defaultBorder,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            items: dataObject.map((dataProvice) {
              String? value = dataProvice[valName]?.toString();
              String? displayText = dataProvice[colName]?.toString();

              return DropdownMenuItem(
                value: value != null && displayText != null ? '$value-$displayText' : null,
                child: TextFont(
                  text: displayText ?? 'N/A',
                  color: isEditable ? Colors.black : Colors.grey,
                  noto: true,
                ),
              );
            }).toList(),
            onChanged: isEditable ? onChanged : null, // Prevent changes when disabled
          ),
        ],
      ),
    );
  }
}
