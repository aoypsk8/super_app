import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

import '../../utility/color.dart';
import '../../widget/custom_clipper.dart';

class ResultTempAScreen extends StatefulWidget {
  const ResultTempAScreen({super.key});

  @override
  State<ResultTempAScreen> createState() => _ResultTempAScreenState();
}

class _ResultTempAScreenState extends State<ResultTempAScreen>
    with SingleTickerProviderStateMixin {
  final screenshotController = ScreenshotController();
  final GlobalKey _globalKey = GlobalKey();
  final storage = GetStorage();
  final controller = Get.find<TempAController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveScreen();
    });
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
      await Future.delayed(Duration(milliseconds: 500));
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
                        SizedBox(height: 10.h),
                        buildTopClippath(),
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
                                backgroudDetailBill(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTextSuccess(),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: cr_fdeb,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            //! from - to account
                                            buildAccountDetails(
                                                context: context,
                                                imageUrl: userController
                                                        .userProfilemodel
                                                        .value
                                                        .profileImg ??
                                                    '',
                                                type: 'from',
                                                accName: userController
                                                    .profileName.value,
                                                accNo: userController
                                                    .userProfilemodel
                                                    .value
                                                    .msisdn!),
                                            buildDotLine(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            buildAccountDetails(
                                                context: context,
                                                imageUrl: controller.tempAdetail
                                                        .value.logo ??
                                                    '',
                                                type: 'to',
                                                accName:
                                                    controller.rxaccname.value,
                                                accNo: controller
                                                    .rxaccnumber.value,
                                                titleProvider: controller
                                                    .tempAdetail.value.title!),
                                          ],
                                        ),
                                      ),
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
                                            text: controller
                                                .rxPaymentAmount.value,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: cr_b326,
                                            poppin: true,
                                          ),
                                          TextFont(
                                            text: '.00 LAK',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: cr_b326,
                                            poppin: true,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      buildTextDetail(
                                          title: "fee",
                                          detail: controller.rxFee.value,
                                          money: true),
                                      const SizedBox(height: 5),
                                      buildTextDetail(
                                          title: "transaction_id",
                                          detail: controller.rxtransid.value),
                                      const SizedBox(height: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: buildTextDetail(
                                            money: false,
                                            title: "description",
                                            detail: controller.rxNote.value,
                                            noto: true,
                                          )),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                PrettyQr(
                                                  image: AssetImage(
                                                    MyIcon.ic_logo_x,
                                                  ),
                                                  size: 35.w,
                                                  data: controller
                                                      .rxtransid.value,
                                                  errorCorrectLevel:
                                                      QrErrorCorrectLevel.H,
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
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
            ),
            TextFont(
              text: DateFormat('dd MMMM yyyy HH:mm:ss').format(
                DateTime.parse(
                    controller.rxtimestamp.value.replaceAll('/', '-')),
              ),
              fontWeight: FontWeight.w400,
              fontSize: 9.5,
              color: cr_7070,
            ),
          ],
        ),
      ],
    );
  }

  Positioned backgroudDetailBill() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Opacity(
        opacity: 0.4,
        child: Image.asset(
          MyIcon.bg_ic_background,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ClipPath buildTopClippath() {
    return ClipPath(
        clipper: MyCustomClipperTop(),
        child: Container(
          padding: EdgeInsets.only(top: 40),
          width: Get.width,
          height: 30,
          margin: EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: color_fff,
          ),
        ));
  }

  Widget buildAccountDetails({
    required BuildContext context,
    required String imageUrl,
    required String type,
    required String accName,
    required String accNo,
    String titleProvider = '',
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50.sp,
                        height: 50.sp,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(imageUrl),
                          backgroundColor: Colors
                              .transparent, // Optional: Set a background color
                        ),
                      ),
                      SizedBox(
                          width:
                              8), // Optional spacing between image and column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            titleProvider == ''
                                ? const SizedBox.shrink()
                                : TextFont(
                                    text: titleProvider,
                                    noto: true,
                                    fontWeight: FontWeight.bold,
                                  ),
                            TextFont(
                              text: accName,
                              noto: true,
                              fontWeight: FontWeight.bold,
                              // fontSize: 14,
                              maxLines: 2,
                            ),
                            TextFont(
                              text: accNo,
                              poppin: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                decoration: BoxDecoration(
                  color: color_fff,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextFont(
                  textAlign: TextAlign.center,
                  text: type,
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
