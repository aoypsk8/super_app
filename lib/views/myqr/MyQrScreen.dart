// ignore_for_file: sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/qr_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/utility/shareResult.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _dynamicAmount = TextEditingController();
  final _note = TextEditingController();
  final qrController = Get.put(QrController());

  final ScreenshotController _screenshotController = ScreenshotController();
  GlobalKey _repaintBoundaryKey = GlobalKey();

  Future<void> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(Duration(milliseconds: 500));
        return _captureScreenshot();
      }
      // Capture image with high resolution (pixelRatio 3.0 for better quality)
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
      DialogHelper.showSuccess(title: 'save_pic_success', autoClose: true);
    } catch (e) {
      DialogHelper.showErrorDialogNew(
        title: 'Error',
        description: 'Error capturing screenshot: $e',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    qrController.generateQR_firstscreen(0, 'static', '');
    // checkToken();
  }

  void checkToken() async {
    bool isValidToken = await userController.checktokenSuperApp();
    if (isValidToken) {
      qrController.generateQR_firstscreen(0, 'static', '');
    }
  }

  @override
  void dispose() {
    qrController.rxQrDynamicAmout.value = '';
    _note.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: BuildAppBar(title: "MyQR"),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: bodyQR(),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  buildBottomIconButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container bodyQR() {
    return Container(
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
            children: [
              header(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: 'Qr Type : ',
                    fontSize: 10,
                    poppin: true,
                  ),
                  Row(
                    children: [
                      TextFont(
                        text: qrController.generateQrModel.value.qrType
                                ?.toUpperCase() ??
                            "N/A",
                        fontSize: 10,
                        poppin: true,
                        color: cr_2929,
                      ),
                      const SizedBox(width: 5),
                      TextFont(
                        text: "(LAK)",
                        fontSize: 10,
                        color: cr_2929,
                        poppin: true,
                      ),
                    ],
                  ),
                ],
              ),
              qrController.rxQrDynamicAmout.value == ''
                  ? TextFont(
                      text: "scan_me",
                      poppin: true,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFont(
                          text: qrController.rxQrDynamicAmout.value,
                          poppin: true,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 5),
                        TextFont(
                          text: 'kip',
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
              const SizedBox(height: 5),
              qrController.rxNote.value == ''
                  ? const SizedBox()
                  : TextFont(
                      text: qrController.rxNote.value,
                      poppin: true,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
              const SizedBox(height: 5),
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
                        child: qrController.generateQrModel.value.qrstr != null
                            ? PrettyQr(
                                image: AssetImage(MyIcon.ic_lao_qr),
                                size: 70.w,
                                data:
                                    qrController.generateQrModel.value.qrstr ??
                                        "N/A",
                                errorCorrectLevel: QrErrorCorrectLevel.H,
                                typeNumber: null,
                                roundEdges: false,
                              )
                            : Container(
                                height: 70.w,
                                width: 70.w,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: cr_red,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              footer()
            ],
          ),
        ],
      ),
    );
  }

  Container footer() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFont(
              text: 'devby',
              color: cr_2929,
              fontSize: 10,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Container header() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(2),
                  width: 13.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                        userController.userProfilemodel.value.profileImg ??
                            MyConstant.profile_default),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          TextFont(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            text:
                                '${userController.userProfilemodel.value.name!} ${userController.userProfilemodel.value.surname!}',
                            color: cr_2929,
                          ),
                          TextFont(
                            fontWeight: FontWeight.w500,
                            text: userController.userProfilemodel.value.msisdn!,
                            color: cr_2929,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: color_fff.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(2),
                        width: 9.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(MyConstant.profile_default),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Widget buildBottomIconButton() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              _captureScreenshot();
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(50),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  MyIcon.ic_save_qr,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              sharedScreenshot(_screenshotController);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(50),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  MyIcon.ic_share_qr,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              buildCreateDynamicQR();
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(50),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  MyIcon.ic_edit_qr,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Future<dynamic> buildCreateDynamicQR() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    child: Image.asset(MyIcon.ic_logo_x),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFont(text: 'dynamic_qr'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: FormBuilder(
            key: _formKey,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildDotLine(
                        dashlenght: 10,
                        color: cr_b326.withOpacity(0.5),
                      ),
                      SizedBox(height: 15),
                      buildAccountingFiledVaidate(
                        controller: _dynamicAmount,
                        label: 'amount_kip',
                        name: 'amount',
                        hintText: '0',
                        max: 11,
                        fillcolor: color_f4f4,
                        bordercolor: color_f4f4,
                        suffixWidget: true,
                        suffixWidgetData: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextFont(
                                text: '.00 LAK',
                                color: cr_7070,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ),
                        suffixonTapFuc: () {},
                      ),
                      SizedBox(height: 10),
                      BuildTextAreaValidate(
                        label: 'message',
                        controller: _note,
                        name: 'note',
                        iconColor: color_f4f4,
                        hintText: 'input_text',
                        Isvalidate: true,
                      ),
                      SizedBox(height: 20),
                      buildBottomAppbar(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        bgColor: Theme.of(context).primaryColor,
                        title: 'create_dynamic_qr',
                        high: 0,
                        func: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            int paymentAmount = int.parse(_dynamicAmount.text
                                .trim()
                                .replaceAll(RegExp(r'[^\w\s]+'), ''));
                            qrController.rxQrDynamicAmout.value =
                                _dynamicAmount.text;
                            Navigator.pop(context);
                            qrController.generateQR_firstscreen(
                                paymentAmount, 'dynamic', _note.text);
                          }
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
