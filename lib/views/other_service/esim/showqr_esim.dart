import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
import 'package:super_app/views/web/openWebView.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: esimController.esimDetailModelRes.first.data,
                    fontSize: 12,
                    poppin: true,
                  ),
                  TextFont(
                    text: " / ",
                    fontSize: 12,
                  ),
                  TextFont(
                    text: esimController.esimDetailModelRes.first.time,
                    fontSize: 12,
                    poppin: true,
                  ),
                  TextFont(
                    text: " / ",
                    fontSize: 12,
                  ),
                  TextFont(
                    text: esimController.esimDetailModelRes.first.freeCall,
                    fontSize: 12,
                    poppin: true,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: esimController.esimDetailModelRes.first.phoneNumber,
                    poppin: true,
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: esimController
                              .esimDetailModelRes.first.phoneNumber,
                        ),
                      );
                      showTopSnackBar(
                        Overlay.of(context),
                        snackBarPosition: SnackBarPosition.bottom,
                        displayDuration: const Duration(milliseconds: 1000),
                        CustomSnackBar.success(
                          icon: const Icon(Icons.check_circle,
                              color: Color.fromARGB(161, 255, 255, 255),
                              size: 120),
                          message: "Phone number copied",
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.copy,
                      color: Theme.of(context).primaryColor,
                      size: 10.sp,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                fontWeight: FontWeight.w400,
              ),
              TextFont(
                textAlign: TextAlign.center,
                maxLines: 2,
                text: "you_need_to_active_this_phone_number_before_suing",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: cr_0e19.withOpacity(0.6),
              ),
              InkWell(
                onTap: () {
                  DialogHelper.dialogRecurringConfirm(
                    title: "are_you_sure_to_acctive_this_phon_number",
                    description:
                        "if_you_active_this_phone_number_this_phone_number_will_active_and_begin_the_internet_when_you_active_success",
                    onOk: () {
                      Get.to(OpenWebView(url: "https://onegrab.laotel.com/"));
                    },
                  );
                  //
                },
                child: TextFont(
                  text: "active_this_phone_number_here",
                  fontSize: 13,
                  underline: true,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
