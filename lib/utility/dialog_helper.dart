// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class DialogHelper {
  static void showErrorDialogNew({
    String title = 'Umm, Sorry!!',
    String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.',
    Function()? onClose,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                              onPressed: onClose ?? (() => hide()),
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
      ),
    );
  }

  static void showErrorWithFunctionDialog({
    String title = 'Uh oh.',
    String description = 'ການເຊື່ອມຕໍ່ລະບົບມີບັນຫາ, ກະລຸນາລອງໃຫມ່ອີກຄັ້ງ.',
    String closeTitle = 'close',
    bool withCancel = false,
    Function()? onClose,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Dialog(
            surfaceTintColor: color_fff,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: !withCancel
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 25),
                      Image.asset(
                        MyIcon.ic_problem,
                      ),
                      SizedBox(height: 10),
                      TextFont(
                        text: title,
                        fontWeight: FontWeight.w400,
                        color: cr_2929,
                        fontSize: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: TextFont(
                                text: description.tr,
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                fontWeight: FontWeight.normal,
                                color: cr_7070,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: cr_ef33,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      elevation: 0, // Remove shadow
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  onPressed: onClose,
                                  child: TextFont(
                                      text: closeTitle,
                                      textAlign: TextAlign.center,
                                      color: color_fff,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 25),
                          Image.asset(
                            MyIcon.ic_problem,
                          ),
                          SizedBox(height: 10),
                          TextFont(
                            text: title,
                            fontWeight: FontWeight.w400,
                            color: cr_2929,
                            fontSize: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: TextFont(
                                    text: description.tr,
                                    textAlign: TextAlign.center,
                                    maxLines: 5,
                                    fontWeight: FontWeight.normal,
                                    color: cr_7070,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: cr_ef33,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          elevation: 0, // Remove shadow
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10)),
                                      onPressed: onClose,
                                      child: TextFont(
                                          text: closeTitle,
                                          textAlign: TextAlign.center,
                                          color: color_fff,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 20,
                        top: 20,
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color_f4f4,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                MyIcon.ic_deleteX,
                              ),
                            ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15),
                      child: Lottie.asset(
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
                    ),
                    SizedBox(height: 10),
                    TextFont(
                      text: title,
                      fontWeight: FontWeight.w400,
                      color: cr_2929,
                      fontSize: 15,
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

  static void showSuccessWithMascot({
    String title = 'Success.',
    String closeTitle = 'close',
    bool autoClose = false,
    Function()? onClose,
  }) {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: WillPopScope(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15),
                        child: Image.asset(MyIcon.ic_mascot_good),
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

  static void showBorrowPopup({
    required String borrow,
    required String amount,
    String okTitle = 'confirm',
    Function()? onConfirm,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button closing
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Dialog(
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        // Center the image
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20), // Adjust padding if needed
                            child: Image.asset(
                              'assets/icons/problem.png',
                              height: 120,
                            ),
                          ),
                        ),

                        // Close Button on Top-Right
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.black54, size: 24),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFont(
                      text: "$borrow?",
                      fontSize: 10.sp,
                    ),
                    const SizedBox(height: 5),
                    TextFont(
                      text: amount,
                      color: color_7070,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF15244),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                      ),
                      onPressed: () {
                        Get.back(); // Close the dialog
                        if (onConfirm != null) {
                          onConfirm(); // Trigger function if provided
                        }
                      },
                      child: TextFont(
                        text: okTitle,
                        color: color_fff,
                        fontWeight: FontWeight.w500,
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hide() {
    if (Get.isDialogOpen!) Get.back();
  }

  static void showDialogPolicy(
      {String title = 'Policy',
      String description = 'Policy Description.',
      Function()? onClose,
      bool isChecked = false}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          surfaceTintColor: color_fff,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            child: _PolicyDialogContent(
              title: title,
              description: description,
              isChecked: isChecked,
              onClose: onClose,
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyDialogContent extends StatefulWidget {
  final String title;
  final String description;
  final bool isChecked;
  final Function()? onClose;

  const _PolicyDialogContent({
    required this.title,
    required this.description,
    required this.isChecked,
    this.onClose,
  });

  @override
  __PolicyDialogContentState createState() => __PolicyDialogContentState();
}

class __PolicyDialogContentState extends State<_PolicyDialogContent> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFont(
                    fontSize: 16,
                    text: widget.title,
                    fontWeight: FontWeight.w500,
                    color: cr_090a,
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        MyIcon.ic_deleteX,
                      ),
                    ),
                  ),
                ],
              ),
              TextFont(
                fontSize: 12,
                maxLines: 100,
                text: widget.description,
                fontWeight: FontWeight.w300,
                color: color_777,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            Expanded(
              child: TextFont(
                fontSize: 12,
                text: "ຂ້ອຍໄດ້ອ່ານນະໂຍບາຍ ແລະ ຍອມຮັບ",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(
          width: Get.width,
          child: buildBottomAppbar(
            bgColor: isChecked ? cr_ef33 : Colors.grey,
            title: 'next',
            func: () {
              if (isChecked) {
                if (widget.onClose != null) {
                  widget.onClose!();
                }
              } else {
                Get.snackbar(
                  'Error',
                  'Please accept the policy to proceed.',
                  backgroundColor: cr_ef33,
                  colorText: Colors.white,
                );
              }
            },
          ),
        ),
      ],
    );
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
