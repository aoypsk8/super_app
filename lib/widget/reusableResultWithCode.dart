import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/wetv_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:intl/intl.dart';
import 'package:super_app/widget/textfont.dart';

class ReusableResultWithCode extends StatefulWidget {
  final String fromAccountImage;
  final String fromAccountName;
  final String fromAccountNumber;
  final String toAccountImage;
  final String toAccountName;
  final String toAccountNumber;
  final String amount;
  final String fee;
  final String transactionId;
  final String timestamp;
  final bool fromHistory;
  final String code;
  bool isUSD = false;

  ReusableResultWithCode({
    super.key,
    required this.fromAccountImage,
    required this.fromAccountName,
    required this.fromAccountNumber,
    required this.toAccountImage,
    required this.toAccountName,
    required this.toAccountNumber,
    required this.amount,
    required this.fee,
    required this.transactionId,
    required this.timestamp,
    required this.fromHistory,
    required this.code,
    this.isUSD = false,
  });

  @override
  State<ReusableResultWithCode> createState() => _ReusableResultWithCodeState();
}

class _ReusableResultWithCodeState extends State<ReusableResultWithCode>
    with SingleTickerProviderStateMixin {
  final homeController = Get.find<HomeController>();
  final screenshotController = ScreenshotController();
  final GlobalKey _globalKey = GlobalKey();

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _saveScreen();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Take a screenshot and share it
  void _takeScreenshot() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = File('${directory.path}/image.png');
        await imagePath.writeAsBytes(image);
        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    } catch (e) {
      print("Error taking screenshot: $e");
    }
  }

  Future<void> _saveScreen() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      if (_globalKey.currentContext != null) {
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          String picturesPath = "${DateTime.now().millisecondsSinceEpoch}.jpg";
          final result = await SaverGallery.saveImage(
            byteData.buffer.asUint8List(),
            fileName: picturesPath,
            skipIfExists: false,
          );
          print(result.toString());
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildWetvCodeBox(String code) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cr_7070.withOpacity(0.3)),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFont(
                  text: 'ລະຫັດ',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: cr_7070,
                ),
                SizedBox(height: 4),
                TextFont(
                  text: code,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: cr_2929,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: cr_b326, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Get.snackbar(
                'Copied!',
                'Code copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: cr_b326.withOpacity(0.1),
                colorText: cr_b326,
                duration: Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: RepaintBoundary(
          key: _globalKey,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    MyIcon.bg_backgroundBill,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              FooterLayout(
                footer: Row(
                  children: [
                    Expanded(
                      child: buildBottomBill(
                        title: 'share',
                        bgColor: cr_fdeb,
                        func: () async {
                          _takeScreenshot();
                        },
                        share: true,
                      ),
                    ),
                    Expanded(
                      child: buildBottomBill(
                        title: 'close',
                        bgColor: cr_b326,
                        textColor: color_fff,
                        func: () async {
                          Get.until((route) => route.isFirst);
                        },
                      ),
                    ),
                  ],
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        ClipPath(
                            clipper: MyCustomClipperTop(),
                            child: Container(
                              padding: EdgeInsets.only(top: 40),
                              width: Get.width,
                              height: 30,
                              margin: EdgeInsets.symmetric(horizontal: 17),
                              decoration: BoxDecoration(
                                color: color_fff,
                              ),
                            )),
                        ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 17),
                            decoration: BoxDecoration(
                              color: color_fff,
                            ),
                            width: Get.width,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                      MyIcon.bg_ic_background,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          buildTextSuccess(),
                                          TextFont(
                                            text: widget.timestamp,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 9.5,
                                            color: cr_7070,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 15),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: cr_fdeb,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: buildUserDetail(
                                                profile:
                                                    widget.fromAccountImage,
                                                from: true,
                                                msisdn:
                                                    widget.fromAccountNumber,
                                                name: widget.fromAccountName,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            const buildDotLine(
                                              color: cr_ef33,
                                              dashlenght: 7,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: buildUserDetail(
                                                  profile:
                                                      widget.toAccountImage,
                                                  from: false,
                                                  msisdn:
                                                      widget.toAccountNumber,
                                                  name: widget.toAccountName),
                                            ),
                                          ],
                                        ),
                                      ),
                                      buildWetvCodeBox(widget.code),
                                      const SizedBox(height: 10),
                                      TextFont(
                                        text: 'amount_transfer',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        color: cr_7070,
                                      ),
                                      Row(
                                        children: [
                                          TextFont(
                                            text: NumberFormat('#,###').format(
                                                double.parse(widget.amount)),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: cr_b326,
                                          ),
                                          TextFont(
                                            text:
                                                '.00 LAK ${widget.isUSD ? '(${homeController.RxamountUSD.value} USD)' : ''}',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: cr_b326,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      buildTextDetail(
                                        title: "fee",
                                        detail: NumberFormat('#,###')
                                            .format(double.parse(widget.fee)),
                                        money: true,
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: buildTextDetail(
                                                maxlines: 1,
                                                title: "ເລກໃບບິນ",
                                                detail: widget.transactionId),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // ignore: deprecated_member_use
                                                PrettyQr(
                                                  image: AssetImage(
                                                    MyIcon.ic_logo_x,
                                                  ),
                                                  size: 25.w,
                                                  data: widget.transactionId,
                                                  errorCorrectLevel:
                                                      QrErrorCorrectLevel.M,
                                                  typeNumber: null,
                                                  roundEdges: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        ClipPath(
                            clipper: MyCustomClipperButtom(),
                            child: Container(
                              width: Get.width,
                              height: 30,
                              margin: EdgeInsets.symmetric(horizontal: 17),
                              decoration: BoxDecoration(
                                color: color_fff,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextSuccess() {
    return Expanded(
      child: Row(
        children: [
          SvgPicture.asset(
            MyIcon.ic_check,
            fit: BoxFit.cover,
            width: 6.w,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFont(
              text: 'transfer_success',
              fontWeight: FontWeight.w500,
              color: cr_2929,
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class MyCustomClipperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 58;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 10 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.height, size.width);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyCustomClipperButtom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 58;

    path.moveTo(0, size.height);

    // Create the zigzag wave
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 10 : size.height;
      path.lineTo(curXPos, curYPos);
    }

    // Complete the path
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
