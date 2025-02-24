import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'create_password'),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 60.w,
                    width: 60.w,
                    child: Image.asset('assets/images/otp.png', fit: BoxFit.cover),
                  ),
                ),
                TextFont(
                  text: 'new_password',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: cr_2929,
                ),
                TextFont(
                  text: 'secure_your_account',
                  color: color_777,
                  fontSize: 10,
                  maxLines: 2,
                ),
                buildPasswordField(
                  controller: _password,
                  label: '',
                  name: 'password',
                  hintText: 'enter_new_password',
                ),
                buildPasswordField(
                  controller: _confirmPassword,
                  label: '',
                  name: 'password',
                  hintText: 'confirm_password',
                ),
                SizedBox(height: 30),
                buildBottomAppbar(func: () {}, title: 'save'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
