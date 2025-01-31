// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class DialogHelper {
  static void showErrorDialogNew(
      {String title = 'Umm, Sorry!!',
      String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.'}) {
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
                  MyIcon.ic_mascot_dontknow,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10),
                TextFont(
                  text: title,
                  fontWeight: FontWeight.w400,
                  color: cr_2929,
                  fontSize: 12,
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
                  MyIcon.ic_mascot_dontknow,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10),
                TextFont(
                  text: title,
                  fontWeight: FontWeight.w400,
                  color: cr_2929,
                  fontSize: 12,
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

  static void showSuccess({
    String title = 'Success.',
    String closeTitle = 'close',
    bool autoClose = false,
    Function()? onClose,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: () {
            if (onClose != null) {
              onClose();
              Get.back();
              hide();
            } else {
              Get.until((route) => route.isFirst);
              Get.back();
              hide();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Dialog(
              surfaceTintColor: color_fff,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      MyIcon.animation_success,
                      repeat: autoClose ? false : true,
                      onLoaded: (composition) {
                        autoClose
                            ? Future.delayed(composition.duration * 2, () {
                                Get.back();
                              })
                            : null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFont(
                      text: title,
                      fontWeight: FontWeight.w400,
                      color: cr_2929,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void dialogRecurringConfirm({
    String title = 'Uh oh.',
    String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.',
    String okTitle = 'confirm',
    bool onMultiBtn = true,
    Function()? onOk,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          surfaceTintColor: color_fff,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  MyIcon.ic_mascot_dontknow,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 10),
                TextFont(
                  text: title,
                  fontWeight: FontWeight.bold,
                  color: color_436,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFont(
                          text: description,
                          textAlign: TextAlign.center,
                          maxLines: 8,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff636E72),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          if (onMultiBtn)
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFEDF1F7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  child: TextFont(
                                      text: 'cancel',
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          if (onMultiBtn)
                            SizedBox(
                              width: 10,
                            ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: onOk,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF15244),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: TextFont(
                                    text: okTitle,
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
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
                  MyIcon.ic_logo_x,
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
                  MyIcon.ic_logo_x,
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
