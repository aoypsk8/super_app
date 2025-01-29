import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'setting'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                color: color_primary_dark,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50.sp,
                          height: 50.sp,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(userController.userProfilemodel.value.profileImg ?? ''),
                            backgroundColor: Colors.transparent, // Optional: Set a background color
                          ),
                        ),
                        SizedBox(width: 8), // Optional spacing between image and column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFont(
                                text: 'accName',
                                noto: true,
                                fontWeight: FontWeight.bold,
                                // fontSize: 14,
                                maxLines: 2,
                              ),
                              TextFont(
                                text: 'accNo',
                                poppin: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: 5.h,
                left: 40.w,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: color_2929,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: color_2929.withOpacity(0.1), blurRadius: 10, spreadRadius: 5),
                    ],
                  ),
                  child: Icon(Icons.person, color: color_primary_dark, size: 20.sp),
                ),
              ),
            ]),
            SizedBox(height: 15.h),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          TextFont(text: "personal_info"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: color_ecec),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          TextFont(text: "change_password"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: color_ecec),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          TextFont(text: "verify_account"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: color_ecec),
                  Row(
                    children: [
                      TextFont(text: "biometric"),
                      Spacer(),
                      Switch(
                        value: box.read('biometric') ?? false,
                        onChanged: (value) {
                          setState(() {
                            box.write('biometric', value);
                          });
                        },
                      ),
                      TextFont(text: box.read('biometric') ?? false ? "on" : "off"),
                    ],
                  ),
                  Divider(color: color_ecec),
                  Row(
                    children: [
                      TextFont(text: "save_screenshot"),
                      Spacer(),
                      Switch(
                        value: box.read('save_screenshot') ?? false,
                        onChanged: (value) {
                          setState(() {
                            box.write('save_screenshot', value);
                          });
                        },
                      ),
                      TextFont(text: box.read('save_screenshot') ?? false ? "on" : "off"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.sp),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          TextFont(text: "about_us"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: color_ecec),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          TextFont(text: "policy_and_terms"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: color_ecec),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          TextFont(text: "change_language"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 50.w,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(20)),
                child: TextFont(text: 'sign_out', textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
