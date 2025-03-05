import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'forgot_password'),
      body: ForgotPasswordWidget(),
    );
  }
}

class ForgotPasswordWidget extends StatelessWidget {
  ForgotPasswordWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final _username = TextEditingController();
    final UserController userCoxntroller = Get.find();
    return Animate(
      delay: Durations.long1,
      effects: [FlipEffect(), SlideEffect()],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: 'Forgot ',
                      color: color_primary_light,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    TextFont(
                      text: 'Password',
                      maxLines: 2,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextFont(
                      text: 'Super App',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 20.sp),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        controller: _username,
                        label: 'username',
                        name: 'username',
                        hintText: 'enter_your_username',
                      ),
                      SizedBox(height: 20.sp),
                      buildBottomAppbar(
                          func: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              userCoxntroller.requestOTP(_username.text, "forgot");
                            }
                          },
                          title: 'next'),
                      // newuser_register(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
