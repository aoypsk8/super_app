// ignore_for_file: camel_case_types, prefer_if_null_operators, prefer_const_constructors

// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/TextCustom.dart';
import 'package:super_app/widget/textfont.dart';

final storage = GetStorage();

class buildTextFiledValidate extends StatelessWidget {
  const buildTextFiledValidate({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.radius = 30,
    this.readonly = false,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final double radius;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderSide: const BorderSide(color: color_ddd),
      borderRadius: BorderRadius.circular(radius),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          SizedBox(
            height: 4,
          ),
          FormBuilderTextField(
            name: name,
            controller: controller,
            readOnly: readonly,
            // maxLength: max == null ? null : max,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black,
              fontFamily: 'PoppinsRegular',
            ),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              hintText: hintText.tr,
              fillColor: color_fff,
              filled: true,
              enabledBorder: border,
              focusedBorder: border,
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
        ],
      ),
    );
  }
}

class buildEmailValidate extends StatelessWidget {
  const buildEmailValidate({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textCustom.textBlack_p5),
          SizedBox(
            height: 4,
          ),
          FormBuilderTextField(
            name: name,
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: hintText.tr,
              hintStyle: textCustom.textBlack_p5,
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),
        ],
      ),
    );
  }
}

class buildPhoneEmailValidate extends StatelessWidget {
  const buildPhoneEmailValidate({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.fillcolor = color_fafa,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final Color fillcolor;
  final Widget? suffixIcon;
  final Function()? suffixonTapFuc;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color_ddd,
        width: 1.5,
      ),
    );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          SizedBox(height: 4),
          FormBuilderTextField(
            name: name,
            controller: controller,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'PoppinsRegular',
            ),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              hintText: hintText.tr,
              fillColor: fillcolor,
              filled: true,
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              suffixIcon: suffixonTapFuc != null
                  ? Container(
                      margin: EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: suffixonTapFuc,
                        child: suffixIcon,
                      ),
                    )
                  : null,
              counter: SizedBox.shrink(),
              enabledBorder: border,
              focusedBorder: border,
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'This field is required.',
              ),
              ((value) {
                if (value == null || value.isEmpty) {
                  return null; // Handled by `required` validator
                }
                if (!value.contains('@') && !value.startsWith('20')) {
                  return 'Phone numbers must start with 20XXXXXXXX.';
                }
                return null; // No error
              }),
            ]),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}

class buildTextField extends StatelessWidget {
  const buildTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.max,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.fillcolor = color_f2f2,
    this.bordercolor = color_f2f2,
    this.errorBorderColor = Colors.red,
    this.labelWeight = FontWeight.normal,
    this.suffixIconColor = Colors.black,
    this.isRequire = true,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final int? max;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final Function()? suffixonTapFuc;
  final Color fillcolor;
  final Color bordercolor;
  final Color errorBorderColor;
  final FontWeight labelWeight;
  final bool isRequire;

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
          TextFont(
            text: label,
            fontWeight: labelWeight,
          ),
          const SizedBox(height: 4),
          FormBuilderTextField(
            name: name,
            controller: controller,
            maxLength: max,
            style:
                GoogleFonts.notoSansLao(fontSize: 13.sp, color: Colors.black),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
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
              // Hide error message
              errorStyle: const TextStyle(height: 0),
            ),
            validator: isRequire
                ? FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: ''),
                  ])
                : null,
          ),
        ],
      ),
    );
  }
}

class buildLongTextFiled extends StatelessWidget {
  const buildLongTextFiled({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textCustom.textBlack_p5),
          SizedBox(
            height: 4,
          ),
          FormBuilderTextField(
            name: name,
            controller: controller,
            minLines: 4,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hintText.tr,
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              // suffixIcon: Icon(Icons.phone, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class buildNumberFiledValidate extends StatelessWidget {
  const buildNumberFiledValidate({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    this.max,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.fillcolor = color_fafa,
    this.bordercolor = color_ddd,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final int? max;
  final Color fillcolor;
  final Color bordercolor;
  final Widget? suffixIcon;
  final Function()? suffixonTapFuc;

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: bordercolor,
        width: 1.5,
      ),
    );
    return Container(
      // margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          SizedBox(
            height: 4,
          ),
          FormBuilderTextField(
            name: name,
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: max == null ? null : max,
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              suffixIcon: suffixonTapFuc != null
                  ? Container(
                      margin: EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: suffixonTapFuc,
                        child: suffixIcon,
                      ),
                    )
                  : null,
              //! hiden counter lenght text
              counter: SizedBox.shrink(),
              enabledBorder: border,
              focusedBorder: border,
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
        ],
      ),
    );
  }
}

class buildAccountingFiledVaidate extends StatelessWidget {
  const buildAccountingFiledVaidate({
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
    this.suffixWidget = false,
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
  final bool suffixWidget;
  final Widget? suffixWidgetData;

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: bordercolor, width: 1.5),
    );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          SizedBox(height: 4),
          FormBuilderTextField(
            name: name,
            controller: controller,
            focusNode: focus,
            keyboardType: TextInputType.number,
            maxLength: max == null ? null : max,
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              hintText: hintText.tr,
              fillColor: fillcolor,
              hintStyle: languageCode == 'lo'
                  ? GoogleFonts.notoSerifLao(
                      color: cr_7070.withOpacity(0.8),
                      fontSize: 12.5.sp,
                    )
                  : GoogleFonts.poppins(
                      color: cr_7070.withOpacity(0.8),
                      fontSize: 12.5.sp,
                    ),
              filled: true,
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              suffixIcon: suffixonTapFuc != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (suffixWidget == true && suffixWidgetData != null)
                          suffixWidgetData!,
                        if (suffixIcon != null)
                          GestureDetector(
                            onTap: suffixonTapFuc,
                            child: Icon(suffixIcon, color: Colors.black),
                          ),
                      ],
                    )
                  : null,

              enabledBorder: border,
              focusedBorder: border,
              //! hiden counter lenght text
              counter: SizedBox.shrink(),

              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
            ),
            // onChanged: (val) {},
            inputFormatters: [ThousandsFormatter()],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
        ],
      ),
    );
  }
}

class buildDropDownValidate extends StatelessWidget {
  const buildDropDownValidate({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
    required this.dataObject,
    required this.colName,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;
  final List<Map<String, Object>> dataObject;
  final String colName;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          SizedBox(
            height: 4,
          ),
          FormBuilderDropdown(
            name: name,
            decoration: InputDecoration(
              // hintText: tr(hintText),
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              // suffixIcon: Icon(Icons.phone, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            items: dataObject.map((dataProvice) {
              return DropdownMenuItem(
                value: dataProvice[colName].toString(),
                child: Text(dataProvice[colName].toString(),
                    style: textCustom.textBlack_p5),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class buildDropDown_return_Value_Name_Validate extends StatelessWidget {
  const buildDropDown_return_Value_Name_Validate({
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

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderSide: const BorderSide(color: color_ddd),
      borderRadius: BorderRadius.circular(6),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: label),
          SizedBox(
            height: 4,
          ),
          FormBuilderDropdown(
            name: name,
            initialValue: initValue,
            decoration: InputDecoration(
              hintText: hintText.tr,
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              // suffixIcon: Icon(Icons.phone, color: Colors.black),
              enabledBorder: border,
              focusedBorder: border,
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            items: dataObject.map((dataProvice) {
              return DropdownMenuItem(
                value:
                    '${dataProvice[valName].toString()}-${dataProvice[colName].toString()}',
                // child: TextFont(text: dataProvice[colName].toString()),
                child: TextFont(
                  text: dataProvice[colName].toString(),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class buildPasswordFiledValidate extends StatelessWidget {
  const buildPasswordFiledValidate({
    super.key,
    required this.controller,
    required this.label,
    required this.name,
    required this.hintText,
    this.icons,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textCustom.textBlack_p5),
          SizedBox(
            height: 4,
          ),
          FormBuilderTextField(
            name: name,
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hintText.tr,
              hintStyle: textCustom.textBlack_p5,
              prefixIcon:
                  icons != null ? Icon(icons, color: Colors.black) : null,
              // suffixIcon: Icon(Icons.phone, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
        ],
      ),
    );
  }
}

class BuildTextAreaValidate extends StatelessWidget {
  BuildTextAreaValidate({
    Key? key,
    required this.controller,
    this.label = '',
    required this.name,
    this.hintText = '',
    this.icon,
    this.iconColor = color_777,
    this.max,
    this.suffixIcon,
    this.suffixonTapFuc,
    this.fillcolor = color_f2f2,
    this.inputHeight = 50.0,
  });

  final TextEditingController controller;
  final String name;
  final String label;
  final String hintText;
  final IconData? icon;
  final Color iconColor;
  final int? max;
  final Color fillcolor;
  final Widget? suffixIcon;
  final Function()? suffixonTapFuc;
  final double inputHeight;

  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'lo';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: color_f4f4, width: 1.5),
    );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != ''
              ? Column(
                  children: [
                    TextFont(text: label),
                    const SizedBox(height: 4),
                  ],
                )
              : const SizedBox(height: 4),
          FormBuilderTextField(
            name: name,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: max == null ? null : max,
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
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText.tr,
              hintStyle: languageCode == 'lo'
                  ? GoogleFonts.notoSerifLao(
                      color: cr_7070,
                      fontSize: 12.5.sp,
                    )
                  : GoogleFonts.poppins(
                      color: cr_7070,
                      fontSize: 12.5.sp,
                    ),
              fillColor: fillcolor,
              filled: true,
              prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
              suffixIcon: suffixonTapFuc != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: suffixonTapFuc,
                        child: suffixIcon,
                      ),
                    )
                  : null,
              //! hidden counter length text
              counter: const SizedBox.shrink(),
              enabledBorder: border,
              focusedBorder: border,
              //! error border
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
            ),
            // validator: FormBuilderValidators.compose([
            //   FormBuilderValidators.required(),
            // ]),
          ),
        ],
      ),
    );
  }
}
