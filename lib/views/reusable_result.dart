// ignore_for_file: unused_element, avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/myIcon.dart';

import '../../utility/color.dart';
import '../../widget/custom_clipper.dart';
import '../../widget/buildBottomAppbar.dart';
import '../../widget/build_DotLine.dart';
import '../../widget/textfont.dart';

class ReusableResultScreen extends StatefulWidget {
  final String fromAccountImage;
  final String fromAccountName;
  final String fromAccountNumber;
  final String toAccountImage;
  final String toAccountName;
  final String toAccountNumber;
  final String toTitleProvider;

  final String amount;
  final String fee;
  final String transactionId;
  final String note;
  final String timestamp;

  const ReusableResultScreen({
    super.key,
    required this.fromAccountImage,
    required this.fromAccountName,
    required this.fromAccountNumber,
    required this.toAccountImage,
    required this.toAccountName,
    required this.toAccountNumber,
    required this.toTitleProvider,
    required this.amount,
    required this.fee,
    required this.transactionId,
    required this.note,
    required this.timestamp,
  });

  @override
  _ReusableResultScreenState createState() => _ReusableResultScreenState();
}

class _ReusableResultScreenState extends State<ReusableResultScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  GlobalKey _repaintBoundaryKey = GlobalKey();

  Future<void> _takeScreenshotAndShare() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = File('${directory.path}/screenshot.png');
        await imagePath.writeAsBytes(image);
        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    } catch (e) {
      print("Error taking screenshot: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for the widget to fully render
      Future.delayed(Duration(milliseconds: 500), _captureScreenshot);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        print("Waiting for repaint...");
        await Future.delayed(Duration(milliseconds: 500));
        return _captureScreenshot();
      }

      // Capture image with high resolution (pixelRatio 3.0 for better quality)
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // Save to gallery
      final result = await SaverGallery.saveImage(
        pngBytes,
        fileName: "screenshot_${DateTime.now().millisecondsSinceEpoch}.jpg",
        androidRelativePath: "Pictures/Screenshots",
        skipIfExists: false,
      );

      print('✅ Screenshot saved at: $filePath');
      print('📸 Saved to gallery: $result');
    } catch (e) {
      print('❌ Error capturing screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _repaintBoundaryKey,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(MyIcon.bg_backgroundBill, fit: BoxFit.cover),
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
                        // _takeScreenshot();
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
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildTextSuccess(),
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: cr_fdeb,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          //! from - to account
                                          buildAccountDetails(
                                            context: context,
                                            imageUrl: widget.fromAccountImage,
                                            type: 'from',
                                            accName: widget.fromAccountName,
                                            accNo: widget.fromAccountNumber,
                                          ),
                                          buildDotLine(color: Theme.of(context).primaryColor),
                                          buildAccountDetails(
                                              context: context,
                                              imageUrl: widget.toAccountImage,
                                              type: 'to',
                                              accName: widget.toAccountName,
                                              accNo: widget.toAccountNumber,
                                              titleProvider: widget.toTitleProvider),
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
                                          text: widget.amount,
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
                                    buildTextDetail(title: "fee", detail: widget.fee, money: true),
                                    const SizedBox(height: 5),
                                    buildTextDetail(title: "transaction_id", detail: widget.transactionId),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: buildTextDetail(
                                          money: false,
                                          title: "description",
                                          detail: widget.note,
                                          noto: true,
                                        )),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              PrettyQr(
                                                image: AssetImage(
                                                  MyIcon.ic_logo_x,
                                                ),
                                                size: 35.w,
                                                data: widget.transactionId,
                                                errorCorrectLevel: QrErrorCorrectLevel.H,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                DateTime.parse(widget.timestamp.replaceAll('/', '-')),
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
                          backgroundColor: Colors.transparent, // Optional: Set a background color
                        ),
                      ),
                      SizedBox(width: 8), // Optional spacing between image and column
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

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(
          text: 'Amount',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        TextFont(
          text: '${widget.amount} LAK',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: cr_b326,
        ),
        const SizedBox(height: 10),
        buildTextDetail(title: 'Fee', detail: widget.fee, money: true),
        buildTextDetail(title: 'Transaction ID', detail: widget.transactionId),
        buildTextDetail(title: 'Note', detail: widget.note),
        const SizedBox(height: 10),
        PrettyQr(
          data: widget.transactionId,
          size: 120,
          errorCorrectLevel: QrErrorCorrectLevel.H,
        ),
      ],
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
}
