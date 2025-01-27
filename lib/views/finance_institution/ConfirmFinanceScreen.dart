import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:super_app/controllers/finance_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmFinanceScreen extends StatefulWidget {
  const ConfirmFinanceScreen({super.key});

  @override
  State<ConfirmFinanceScreen> createState() => _ConfirmFinanceScreenState();
}

class _ConfirmFinanceScreenState extends State<ConfirmFinanceScreen> {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  final financeController = Get.put(FinanceController());
  final storage = GetStorage();

  @override
  void initState() {
    userController.increasepage();
    _startCountdownTimer();
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    _countdownTimer?.cancel();
    super.dispose();
  }

  int _remainingTime = 600;
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
        Get.close(2);
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  bool hideButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "confirm_payment"),
      body: Obx(
        () => SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  buildDetail(context),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 20),
        child: buildBottomAppbar(
          title: 'confirm',
          func: () {
            financeController.paymentProcess();
          },
        ),
      ),
    );
  }

  Widget buildDetail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFont(
              text: 'detail',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
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
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cr_fdeb,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: buildUserDetail(
                  profile:
                      "https://gateway.ltcdev.la/AppImage/AppLite/Users/mmoney.png",
                  from: true,
                  msisdn: storage.read('msisdn'),
                  name: "userController.name.value",
                ),
              ),
              const SizedBox(height: 5),
              const buildDotLine(color: cr_ef33, dashlenght: 7),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: buildUserDetail(
                  profile: financeController.financeModelDetail.value.logo!,
                  from: false,
                  msisdn: financeController.rxAccNo.value,
                  name: financeController.rxAccName.value,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        buildNoteMessage(),
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
              text: fn.format(double.parse("10000000")),
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: cr_b326,
            ),
            TextFont(
              text: '.00 LAK',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: cr_b326,
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildTextDetail(
          title: "fee",
          detail: fn.format(
              double.parse(financeController.financeModelDetail.value.fee!)),
          money: true,
        ),
        const SizedBox(height: 20),
        TextFont(
          text: 'ເລກໃບບິນສະຖາບັນທະນາຄານ',
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: cr_7070,
        ),
        const SizedBox(height: 4),
        TextFont(
          text: financeController.rxTransID.value,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: cr_2929,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget buildNoteMessage() {
    return Column(
      children: [
        Row(
          children: [
            TextFont(text: 'message', color: color_777),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFont(
                text: financeController.rxNote.value,
                noto: true,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
