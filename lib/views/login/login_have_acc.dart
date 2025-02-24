import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/login.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class LoginHaveAccount extends StatelessWidget {
  final Function(String) onMethodSelected;
  LoginHaveAccount({
    super.key,
    required this.onMethodSelected,
  });
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(children: [
              Stack(
                children: [
                  SizedBox(
                    width: 25.h,
                    height: 25.h,
                    child: Lottie.asset('assets/animation/circle.json'),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 17.h,
                        height: 17.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color_primary_light.withOpacity(0.2), width: 5),
                        ),
                        child: CircleAvatar(
                          radius: 80.sp,
                          backgroundColor: Colors.transparent,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://profile.mmoney.la/ImageProfile/2052555999/image_cropper_974829D0-223A-4966-AAD4-61355CFE596A-9313-000005AFC1BF66E0.jpg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFont(
                text: 'ອຸດົມສັກ ພາບຸດດີ',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                noto: true,
              ),
              TextFont(
                text: '205*****99',
                fontSize: 18,
                // fontWeight: FontWeight.w500,
                poppin: true,
              ),
              buildPasswordField(controller: _password, label: 'password', name: 'password'),
              forgot_password(),
              SizedBox(height: 20.sp),
              buildBottomAppbar(func: () {}, title: 'login'),
              InkWell(
                onTap: () {
                  onMethodSelected('default');
                },
                child: TextFont(
                  text: 'swap_account',
                  underline: true,
                  color: cr_ef33,
                  underlineColor: cr_ef33,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
