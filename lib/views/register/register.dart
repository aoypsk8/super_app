import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _username = TextEditingController();
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'register'),
      body: Animate(
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
                        text: 'Register ',
                        color: color_primary_light,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      TextFont(
                        text: 'New User',
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
                            func: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                userController.rxMsisdn.value = _username.text;
                                if (await userController.checkHaveWalletBO()) {
                                  DialogHelper.showErrorDialogNew(
                                      description:
                                          'You already have an account.');
                                } else {
                                  userController.requestOTP(
                                      _username.text, "register");
                                }
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
      ),
    );
  }
}
