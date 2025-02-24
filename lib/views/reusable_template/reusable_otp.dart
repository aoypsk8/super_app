import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/textfont.dart';

class ReusableOtpScreen extends StatefulWidget {
  final String title;
  final String desc1;
  final String desc2;
  final String phoneNumber;
  final String buttonText;
  final Function(String) onOtpCompleted;
  final VoidCallback onResendPressed;

  const ReusableOtpScreen({
    Key? key,
    required this.title,
    required this.desc1,
    required this.desc2,
    required this.phoneNumber,
    required this.buttonText,
    required this.onOtpCompleted,
    required this.onResendPressed,
  }) : super(key: key);

  @override
  State<ReusableOtpScreen> createState() => _ReusableOtpScreenState();
}

class _ReusableOtpScreenState extends State<ReusableOtpScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BuildAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image Placeholder
                SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/otp.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                TextFont(text: widget.desc1),
                const SizedBox(height: 5),
                TextFont(
                  text: 'otp_send_to',
                  args: true,
                  arguments: {'phone': widget.phoneNumber},
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                buildOTP(),
                const SizedBox(height: 30),
                InkWell(
                  onTap: widget.onResendPressed,
                  child: TextFont(
                    text: 'send_otp_again',
                    underline: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOTP() {
    return Pinput(
      length: 6,
      pinAnimationType: PinAnimationType.slide,
      controller: pinController,
      onCompleted: widget.onOtpCompleted,
      focusNode: focusNode,
      defaultPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: GoogleFonts.poppins(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: color_f4f4,
          border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      showCursor: true,
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: GoogleFonts.poppins(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: cr_ef33), // Focus color change when typing
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
