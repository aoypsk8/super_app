import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/controllers/wetv_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmWeTVScreen extends StatefulWidget {
  const ConfirmWeTVScreen({super.key});

  @override
  State<ConfirmWeTVScreen> createState() => _ConfirmWeTVScreenState();
}

class _ConfirmWeTVScreenState extends State<ConfirmWeTVScreen> {
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
        Get.until((route) => route.isFirst);
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

  final userController = Get.find<UserController>();
  final weTVController = Get.put(WeTVController());
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
            weTVController.loading.value = true;
            setState(() {
              hideButton = true;
            });
            var amount = weTVController.wetvdetail.value.price
                .toString()
                .replaceAll(new RegExp(r'[^\w\s]+'), '');
            weTVController.wetvpayment(amount);
            setState(() {
              hideButton = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: buildStepProcess(
                    title: '3/3',
                    desc: 'ກວດລາຍລະອຽດ',
                  ),
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
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                      name: userController.profileName.value,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const buildDotLine(color: cr_ef33, dashlenght: 7),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: buildUserDetail(
                      profile: weTVController.wetvdetail.value.logo ?? '',
                      from: false,
                      msisdn: "",
                      name: weTVController.title.value,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First TextFont Widget
                  TextFont(
                    text: 'amount_transfer',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: cr_7070,
                  ),
                  Row(
                    children: [
                      TextFont(
                        text:
                            fn.format((weTVController.wetvdetail.value.price)),
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
                    detail: fn.format(double.parse(weTVController.rxFee.value)),
                    money: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
