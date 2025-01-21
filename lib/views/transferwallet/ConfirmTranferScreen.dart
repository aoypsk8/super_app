import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/build_DotLine.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmTranferScreen extends StatefulWidget {
  const ConfirmTranferScreen({super.key});

  @override
  State<ConfirmTranferScreen> createState() => _ConfirmTranferScreenState();
}

class _ConfirmTranferScreenState extends State<ConfirmTranferScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: AppBar(
        backgroundColor: color_fff,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: cr_090a,
        ),
        elevation: 0,
        title: TextFont(
          // text: menulists.groupNameEN.toString(),
          text: "transfer",
          color: cr_2929,
          fontSize: 11.5.sp,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: cr_ecec,
            thickness: 1,
            height: 0.8,
          ),
        ),
      ),
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
            Get.toNamed('/restultTransfer');
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
                  text: 'Transfer',
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
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
                      fontSize: 14.sp,
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
                      from: true,
                      msisdn: "2052768833",
                      name: "AOY PHONGSAKOUN",
                    ),
                  ),
                  const SizedBox(height: 5),
                  const buildDotLine(color: cr_ef33, dashlenght: 7),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: buildUserDetail(
                      from: false,
                      msisdn: "2052768833",
                      name: "AOY PHONGSAKOUN",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFont(
              text: 'ຈໍານວນເງິນ',
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: cr_7070,
            ),
            Row(
              children: [
                TextFont(
                  text: '10,000,000',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: cr_b326,
                ),
                TextFont(
                  text: '.00 LAK',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: cr_b326,
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildTextDetail(
              title: "ຄ່າທຳນຽມ",
              detail: "5000",
              money: true,
            ),
            const SizedBox(height: 20),
            buildTextDetail(
                money: false,
                title: "ຂໍ້ຄວາມ",
                detail:
                    "Learn about the history, usage and variations of Lorem Ipsum, the industry's standard dummy text."),
          ],
        ),
      ),
    );
  }
}

class buildTextDetail extends StatelessWidget {
  const buildTextDetail({
    super.key,
    required this.title,
    required this.detail,
    required this.money,
  });
  final String title;
  final String detail;
  final bool money;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
          color: cr_7070,
        ),
        Wrap(
          children: [
            TextFont(
              text: detail,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: cr_2929,
              maxLines: 20,
            ),
            money
                ? TextFont(
                    text: '.00 LAK',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: cr_2929,
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}

class buildUserDetail extends StatelessWidget {
  const buildUserDetail({
    super.key,
    required this.from,
    required this.name,
    required this.msisdn,
  });

  final bool from;
  final String name;
  final String msisdn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: color_fff,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFont(
            text: from ? "ຈາກບັນຊີ" : "ຫາບັນຊີ",
            color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.black,
            poppin: true,
            fontSize: 9.sp,
          ),
        ),
        Row(
          children: [
            Container(
              width: 12.5.w,
              height: 12.5.w,
              padding: const EdgeInsets.all(1.5),
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: color_fff,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  "https://gateway.ltcdev.la/AppImage/AppLite/Users/mmoney.png",
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  text: name,
                  color: cr_2929,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                TextFont(
                  text: msisdn,
                  color: cr_2929,
                  fontSize: 14.sp,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
