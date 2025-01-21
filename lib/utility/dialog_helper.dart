// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class DialogHelper {
  static void showErrorDialogNew(
      {String title = 'Umm, Sorry!!',
      String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.'}) {
    Get.dialog(
      // ignore: deprecated_member_use
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          surfaceTintColor: color_fff,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 25),
                Image.asset(
                  MyIcon.ic_error_png,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10),
                TextFont(
                  text: title,
                  fontWeight: FontWeight.w400,
                  color: cr_2929,
                  fontSize: 12.sp,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFont(
                          text: description.tr,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          fontWeight: FontWeight.normal,
                          color: cr_7070,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: cr_eae7,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 0, // Remove shadow
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            onPressed: (() => hide()),
                            child: TextFont(
                                text: 'close',
                                textAlign: TextAlign.center,
                                color: cr_3b3b,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showErrorWithFunctionDialog({
    String title = 'Uh oh.',
    String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.',
    String closeTitle = 'close',
    Function()? onClose,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          surfaceTintColor: color_fff,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 25),
                Image.asset(
                  MyIcon.ic_error_png,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10),
                TextFont(
                  text: title,
                  fontWeight: FontWeight.w400,
                  color: cr_2929,
                  fontSize: 12.sp,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFont(
                          text: description.tr,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          fontWeight: FontWeight.normal,
                          color: cr_7070,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: cr_eae7,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 0, // Remove shadow
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            onPressed: onClose,
                            child: TextFont(
                                text: closeTitle,
                                textAlign: TextAlign.center,
                                color: cr_3b3b,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void loading(
      {String title = 'Uh oh.',
      String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.'}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          surfaceTintColor: color_fff,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/logox.png",
                  height: 80,
                  width: 80,
                ),
                LoadingAnimationWidget.horizontalRotatingDots(
                  color: color_ed1,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide() {
    if (Get.isDialogOpen!) Get.back();
  }
}

class Loading {
  static void hide() {
    Get.back();
  }

  static void show() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/logox.png",
                  height: 80,
                  width: 80,
                ),
                LoadingAnimationWidget.horizontalRotatingDots(
                  color: color_ed1,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    // path.lineTo(0, height - 50);
    // path.quadraticBezierTo(width / 2, height, width, height - 50);
    // path.lineTo(width, 0);
    // path.close();
    path.lineTo(0, height);
    path.quadraticBezierTo(width * 0.5, height - 60, width, height);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class CustomShapeOut extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 30);
    path.quadraticBezierTo(width * 0.5, height + 30, width, height - 30);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
