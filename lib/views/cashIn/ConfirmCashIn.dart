// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, depend_on_referenced_packages, unnecessary_null_comparison
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashIn_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/socket_service.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmCashInScreen extends StatefulWidget {
  const ConfirmCashInScreen({super.key});

  @override
  State<ConfirmCashInScreen> createState() => _ConfirmCashInScreenState();
}

class _ConfirmCashInScreenState extends State<ConfirmCashInScreen>
    with WidgetsBindingObserver {
  final SocketService socketService = SocketService();
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final cashInController = Get.put(CashInController());
  final storage = GetStorage();
  final screenshotController = ScreenshotController();
  final GlobalKey _globalKey = GlobalKey();

  Timer? _socketCheckTimer;

  // Starts periodic checks via socket
  void _startSocketChecks() {
    _socketCheckTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      socketService.sendCheckData(cashInController.requestId.value);
    });
  }

  int _remainingTime = 180;
  Timer? _countdownTimer;
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        if (mounted) {
          setState(() {
            _remainingTime--;
          });
        }
      } else {
        timer.cancel();
        _onCountdownComplete();
      }
    });
  }

  // Called when the countdown timer completes
  void _onCountdownComplete() {
    DialogHelper.showErrorWithFunctionDialog(
      title: 'time_out',
      description: 'try_again_later',
      onClose: () {
        Get.until((route) => route.isFirst);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userController.increasepage();
    _startCountdownTimer();
    socketService.onResponse = (data) {
      if (data['success'] == true) {
        _socketCheckTimer?.cancel();
        _countdownTimer?.cancel();
        DialogHelper.showSuccess(
          onClose: () => DialogHelper.hide(),
          title: 'success',
        );
      }
    };
    socketService.connect();
    _startSocketChecks();
  }

  @override
  void dispose() {
    userController.decreasepage();
    socketService.disconnect();
    _socketCheckTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> _saveScreenshot() async {
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
          DialogHelper.showSuccess(
              title: 'save_pic_success', autoClose: true, onClose: () {});
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_fff,
        appBar: BuildAppBar(title: "cash_in"),
        body: Container(
          color: color_fff,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 26, right: 26, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextFont(
                    //   text: 'please_pay',
                    //   fontWeight: FontWeight.w500,
                    //   fontSize: 11.sp,
                    // ),
                    buildStepProcess(title: "2/2", desc: "please_pay"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.clock,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 5),
                        TextFont(
                          text: _formatTime(_remainingTime),
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: _globalKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  child: bodyQR(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(top: 20),
          child: buildBottomAppbar(
            title: 'save_pic',
            func: () {
              _saveScreenshot();
            },
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
              const SizedBox(height: 30),
              TextFont(
                text: 'amount',
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: cr_2929,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: fn.format(
                        int.tryParse(cashInController.txnAmount.value) ?? 0),
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: cr_ef33,
                  ),
                  TextFont(
                    text: '.00 LAK',
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: cr_ef33,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFont(
                    text: '+',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: cr_2929,
                  ),
                  const SizedBox(width: 2),
                  TextFont(
                    text: 'fee',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: cr_2929,
                  ),
                  const SizedBox(width: 5),
                  TextFont(
                    text: '0',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: cr_2929,
                  ),
                  const SizedBox(width: 5),
                  TextFont(
                    text: 'currency',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: cr_2929,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color_fff,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: cashInController.emvCode.value != null
                            ? PrettyQr(
                                image: AssetImage(MyIcon.ic_lao_qr),
                                size: 70.w,
                                data: cashInController.emvCode.value,
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
                        // child: PrettyQr(
                        //   image: AssetImage(MyIcon.ic_lao_qr),
                        //   size: 70.w,
                        //   data: cashInController.emvCode.value,
                        //   errorCorrectLevel: QrErrorCorrectLevel.M,
                        //   typeNumber: null,
                        //   roundEdges: true,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
