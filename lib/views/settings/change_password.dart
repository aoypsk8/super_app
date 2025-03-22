import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

String? msisdn = storage.read('msisdn');
TempUserProfileStorage boxUser = TempUserProfileStorage();
TempUserProfile? user = boxUser.getUserByUsername(msisdn ?? '');
final TextEditingController _oldPassword = TextEditingController();
final TextEditingController _newPassword = TextEditingController();
final TextEditingController _confirmPassword = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'change_password'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: color_fff,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 40.w,
                              height: 40.w,
                              child: Lottie.asset('assets/animation/circle.json'),
                            ),
                            Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: color_primary_light.withOpacity(0.2), width: 5),
                              ),
                              child: CircleAvatar(
                                radius: 80.sp,
                                backgroundColor: Colors.transparent,
                                backgroundImage: CachedNetworkImageProvider(
                                  user!.imageProfile,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFont(text: user!.fullname, fontSize: 14, fontWeight: FontWeight.w500, noto: true),
                        SizedBox(height: 10),
                        TextFont(text: user!.username, fontSize: 14, color: color_777, poppin: true),
                        SizedBox(height: 10),
                        buildPasswordField(
                          controller: _oldPassword,
                          label: 'password',
                          name: 'password',
                          isMinLengthRequired: true,
                        ),
                        SizedBox(height: 10),
                        buildPasswordField(
                          controller: _newPassword,
                          label: 'new_password',
                          name: 'new_password',
                          isMinLengthRequired: true,
                        ),
                        SizedBox(height: 10),
                        buildPasswordField(
                          controller: _confirmPassword,
                          label: 'confirm_password',
                          name: 'confirm_password',
                          isMinLengthRequired: true,
                        ),
                        SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.of(dialogContext).pop(false);
                        //       },
                        //       child: TextFont(text: 'cancel', color: color_777),
                        //     ),
                        //     TextButton(
                        //       onPressed: () async {
                        //         if (_formKey.currentState!.validate()) {
                        //           isAuthenticated = await userController.chkPasswordSetBiometic(
                        //               user.username, _passwordController.text);
                        //           if (isAuthenticated) {
                        //             Navigator.of(dialogContext).pop(true);
                        //           } else {
                        //             ScaffoldMessenger.of(dialogContext)
                        //                 .showSnackBar(SnackBar(content: Text('Incorrect password')));
                        //           }
                        //         }
                        //       },
                        //       child: TextFont(
                        //         text: 'confirm',
                        //         color: Theme.of(dialogContext).primaryColor,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
