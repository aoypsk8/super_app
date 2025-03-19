import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/esim_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class ShowQRESIMScreen extends StatefulWidget {
  const ShowQRESIMScreen({super.key});

  @override
  State<ShowQRESIMScreen> createState() => _ShowQRESIMScreenState();
}

class _ShowQRESIMScreenState extends State<ShowQRESIMScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  GlobalKey _repaintBoundaryKey = GlobalKey();
  final esimController = Get.put(ESIMController());

  Future<void> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(Duration(milliseconds: 500));
        return _captureScreenshot();
      }
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);
      // Save to gallery
      await SaverGallery.saveImage(
        pngBytes,
        fileName: "screenshot_${DateTime.now().millisecondsSinceEpoch}.jpg",
        androidRelativePath: "Pictures/Screenshots",
        skipIfExists: false,
      );
      DialogHelper.showSuccess(
        title: 'save_pic_success',
      );
    } catch (e) {
      DialogHelper.showErrorDialogNew(
        title: 'Error',
        description: 'Error capturing screenshot: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color_fff,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: bodyQR(),
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomAppbar(
        title: 'save_pic_and_close',
        func: () async {
          await _captureScreenshot();
        },
      ),
    );
  }

  Container bodyQR() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: cr_fdeb,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFont(
                text: esimController.esimDetailModelRes.first.phoneNumber,
                fontSize: 12,
                poppin: true,
              ),
              TextFont(
                text: esimController.esimDetailModelRes.first.phoneNumber,
                poppin: true,
                fontSize: 15,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text:
                        '${fn.format(esimController.esimDetailModelRes.first.price)} KIP',
                    poppin: true,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  TextFont(
                    text: ' ( ${esimController.RxUSD.toString()} USD )',
                    poppin: true,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color_fff,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: PrettyQr(
                            size: 70.w,
                            data: esimController.esimDetailModelRes.first.qr
                                    .trim() ??
                                "N/A",
                            errorCorrectLevel: QrErrorCorrectLevel.H,
                            typeNumber: null,
                            roundEdges: false,
                          )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFont(
                  maxLines: 2,
                  text:
                      'If you forget to save this QR code, you can see the QR code from this email.',
                  fontSize: 12,
                  textAlign: TextAlign.center,
                ),
              ),
              TextFont(
                text: esimController.RxMail.value,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
