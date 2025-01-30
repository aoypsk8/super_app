import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';

import 'textfont.dart';

class buildExpiryDateField extends StatelessWidget {
  const buildExpiryDateField({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
  });

  final String title;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color_f4f4,
        width: 1.5,
      ),
    );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: title),
          SizedBox(
            height: 4,
          ),
          FormBuilderTextField(
            name: title,
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 5,
            style: GoogleFonts.poppins(
              color: cr_7070,
              fontSize: 12.5.sp,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly,
              _ExpiryDateInputFormatter(),
            ],
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                color: cr_7070.withOpacity(0.8),
                fontSize: 12.5.sp,
              ),
              fillColor: color_f4f4,
              filled: true,
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

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) {
      text = text.substring(0, 4);
    }
    String formattedText = text;
    if (text.length > 2) {
      formattedText = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    if (oldValue.text.endsWith('/') &&
        newValue.text.length < oldValue.text.length) {
      formattedText = text.substring(0, text.length - 1);
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
