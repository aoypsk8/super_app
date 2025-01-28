import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmCashOutScreen extends StatefulWidget {
  const ConfirmCashOutScreen({super.key});

  @override
  State<ConfirmCashOutScreen> createState() => _ConfirmCashOutScreenState();
}

class _ConfirmCashOutScreenState extends State<ConfirmCashOutScreen> {
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

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  bool hideButton = false;

  final cashOutController = Get.put(CashOutController());
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "confirm_payment"),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: color_fff,
          border: Border.all(color: color_ddd),
        ),
        child: buildBottomAppbar(
          bgColor: Theme.of(context).primaryColor,
          title: 'confirm_transfer',
          func: () {
            _countdownTimer?.cancel();
            cashOutController.loading.value = true;
            setState(() {
              hideButton = true;
            });
            cashOutController.confirmPayment();
            setState(() {
              hideButton = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFont(
                  text: 'check_detail',
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
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
                      profile: cashOutController.rxLogo.value,
                      from: false,
                      msisdn: cashOutController.rxAccNo.toString(),
                      name: cashOutController.rxAccName.toString(),
                    ),
                  ),
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
                  text: fn.format(
                      double.parse(cashOutController.rxPaymentAmount.value)),
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
              detail: fn.format(double.parse(cashOutController.rxFee.value)),
              money: true,
            ),
            const SizedBox(height: 20),
            buildTextDetail(
              money: false,
              title: "description",
              detail: cashOutController.rxNote.value,
            ),
          ],
        ),
      ),
    );
  }
}
