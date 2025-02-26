import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class CardWidgetBorrowing extends StatelessWidget {
  final String packagename;
  final String code;
  final String amount;
  final String type;
  final String detail;
  final String? detail2;
  final VoidCallback onTap;
  final bool? gb;
  final bool? package;
  final bool? discountBool;
  final String? discountText;

  CardWidgetBorrowing({
    required this.packagename,
    required this.code,
    required this.amount,
    required this.type,
    required this.detail,
    this.detail2 = '',
    required this.onTap,
    this.gb = true,
    this.package = false,
    this.discountBool = false,
    this.discountText = '',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: color_ec1c,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Positioned(
                  child: SvgPicture.asset(
                    MyIcon.bgOfCard,
                    color: cr_ef33,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                type != ""
                                    ? TextFont(
                                        color: color_fff,
                                        text: type == 'airtime'
                                            ? "ຢືມມູນຄ່າໂທ"
                                            : "ຢືມເນັດ",
                                        fontSize: 13,
                                      )
                                    : const SizedBox(),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      50), // Makes it round
                                  child: Image.asset(
                                    "assets/icons/ltc_logo.png", // Using asset image
                                    width: 30, // Adjust size as needed
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            TextFont(
                              color: color_fff,
                              text: type == 'airtime'
                                  ? "${fn.format(int.parse(amount.replaceAll(RegExp(r'[^0-9]'), '')))} LAK"
                                  : "${amount} ${gb == true ? 'GB' : ''}",
                            ),
                            package == true
                                ? Row(
                                    children: [
                                      TextFont(
                                        color: color_fff,
                                        text: "ດາຕ້າໃຊ້ໄດ້",
                                      ),
                                      const SizedBox(width: 2),
                                      TextFont(
                                        color: color_fff,
                                        text: detail,
                                      ),
                                      const SizedBox(width: 2),
                                      TextFont(
                                        color: color_fff,
                                        text: "ໄລຍະກຳນົດ",
                                      ),
                                      const SizedBox(width: 2),
                                      TextFont(
                                        color: color_fff,
                                        text: detail2!,
                                      ),
                                      const SizedBox(width: 2),
                                      TextFont(
                                        color: color_fff,
                                        text: "ວັນ",
                                      ),
                                    ],
                                  )
                                : TextFont(
                                    color: color_fff,
                                    text: detail,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.phone,
                                      color: Colors.red.shade700, size: 16),
                                  SizedBox(width: 5),
                                  TextFont(
                                    text: code,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    discountBool == true
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: cr_b326,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFont(
                                              color: color_fff,
                                              text: discountText!,
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Text(''),
                                          ),
                                    SizedBox(height: 5),
                                    TextFont(
                                      color: color_fff,
                                      text: packagename,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
