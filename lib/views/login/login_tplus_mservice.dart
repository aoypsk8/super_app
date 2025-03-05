import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/login.dart';
import 'package:super_app/views/settings/verify_account.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class LoginTplusMservice extends StatelessWidget {
  final Function(String) onMethodSelected;
  final String title;
  const LoginTplusMservice({super.key, required this.onMethodSelected, required this.title});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final _username = TextEditingController();
    final _password = TextEditingController();
    return Expanded(
      child: Animate(
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
                        text: 'Login ',
                        color: color_primary_light,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      TextFont(
                        text: 'with',
                        maxLines: 2,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFont(
                        text: '$title Users',
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
                        buildTextField(controller: _username, label: 'username', name: 'username'),
                        buildPasswordField(controller: _password, label: 'password', name: 'password'),
                        // forgot_password(),
                        SizedBox(height: 20.sp),
                        buildBottomAppbar(
                            func: () {
                              if (_formKey.currentState!.saveAndValidate()) {
                                userController.checkMserviceTplus(_username.text, _password.text);
                              }
                            },
                            title: 'login'),
                        newuser_register(),
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
