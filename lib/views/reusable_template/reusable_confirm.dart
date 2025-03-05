// ignore_for_file: unused_element, avoid_print

import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildTextDetail.dart';
import 'package:super_app/widget/buildUserDetail.dart';
import 'package:super_app/widget/build_step_process.dart';
import '../../../utility/color.dart';
import '../../../widget/buildBottomAppbar.dart';
import '../../../widget/build_DotLine.dart';
import '../../../widget/textfont.dart';

class ReusableConfirmScreen extends StatefulWidget {
  final String appbarTitle;
  final String stepProcess;
  final String stepTitle;
  final VoidCallback function;
  final String fromAccountImage;
  final String fromAccountName;
  final String fromAccountNumber;
  final String toAccountImage;
  final String toAccountName;
  final String toAccountNumber;
  final String amount;
  final String fee;
  final String note;

  const ReusableConfirmScreen({
    super.key,
    required this.appbarTitle,
    required this.function,
    required this.stepProcess,
    required this.stepTitle,
    required this.fromAccountImage,
    required this.fromAccountName,
    required this.fromAccountNumber,
    required this.toAccountImage,
    required this.toAccountName,
    required this.toAccountNumber,
    required this.amount,
    required this.fee,
    required this.note,
  });

  @override
  _ReusableConfirmScreenState createState() => _ReusableConfirmScreenState();
}

class _ReusableConfirmScreenState extends State<ReusableConfirmScreen> {
  final userController = Get.find<UserController>();
  final storage = GetStorage();
  int _remainingTime = 600;
  Timer? _countdownTimer;
  bool hideButton = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: widget.appbarTitle),
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
            widget.function();
            _countdownTimer?.cancel();
            setState(() {
              hideButton = true;
            });
            setState(() {
              hideButton = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStepProcess(
                      title: widget.stepProcess, desc: widget.stepTitle),
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
                          profile: widget.fromAccountImage,
                          from: true,
                          msisdn: widget.fromAccountNumber,
                          name: widget.fromAccountName,
                        )),
                    const SizedBox(height: 5),
                    const buildDotLine(color: cr_ef33, dashlenght: 7),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: buildUserDetail(
                        profile: widget.toAccountImage,
                        from: false,
                        msisdn: widget.toAccountNumber,
                        name: widget.toAccountName,
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
                    text: fn.format(double.parse(widget.amount)),
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
                detail: fn.format(double.parse(widget.fee)),
                money: true,
              ),
              const SizedBox(height: 20),
              if (widget.note != null && widget.note!.isNotEmpty)
                buildTextDetail(
                  money: false,
                  title: "description",
                  detail: widget.note!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
