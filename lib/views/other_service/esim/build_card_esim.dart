import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class CardWidgetESIM extends StatelessWidget {
  final String packagename;
  final String code;
  final String amount;
  final String detail;
  final VoidCallback onTap;

  final bool? btn;

  CardWidgetESIM({
    required this.packagename,
    required this.code,
    required this.amount,
    required this.detail,
    required this.onTap,
    this.btn = true,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color_fff,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ClipOval(
                                    child: Image.network(
                                      MyConstant.profile_default,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Wrap(
                              children: [
                                TextFont(
                                  color: color_fff,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  text:
                                      "${fn.format(double.parse(amount))} LAK",
                                ),
                                const SizedBox(width: 2),
                                TextFont(
                                  color: color_fff,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  text:
                                      " (${(double.parse((double.parse(amount) / homeController.RxrateUSDKIP.value).toStringAsFixed(2)))} USD)",
                                ),
                              ],
                            ),
                            TextFont(
                              color: color_fff,
                              text: code,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            TextFont(
                              color: color_fff,
                              text: detail,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              btn == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        children: [
                                          Icon(Iconsax.card_edit,
                                              color: Colors.red.shade700,
                                              size: 16),
                                          SizedBox(width: 5),
                                          TextFont(
                                            text: "purchase",
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              TextFont(
                                color: color_fff,
                                text: packagename,
                              ),
                            ],
                          ),
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
