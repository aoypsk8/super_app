import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
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

  bool isHidden = true;
  String maskPhoneNumber(String number) {
    if (number.length >= 7) {
      return number.replaceRange(3, 7, '****'); // Replace characters 4-7 with ****
    }
    return number; // If length is less than 7, return as is
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'setting'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context),
            SizedBox(height: 15.sp),
            buildConfig(),
            SizedBox(height: 10.sp),
            buildInfomation(),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 50.w,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(20)),
                child: TextFont(text: 'logout', textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        children: [
          Column(
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
                          text: userController.profileName.value ?? '',
                          noto: true,
                          color: color_7070,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        Row(
                          children: [
                            TextFont(
                              text: isHidden ? maskPhoneNumber(userController.userProfilemodel.value.msisdn ?? '2055555555') : userController.userProfilemodel.value.msisdn!,
                              poppin: true,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHidden = !isHidden; // Toggle visibility
                                });
                              },
                              child: Icon(
                                isHidden ? Iconsax.eye_slash : Iconsax.eye,
                                color: color_7070,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              userController.userProfilemodel.value.verify == "Approved"
                                  ? SvgPicture.asset(MyIconOld.ic_check_circle)
                                  : SvgPicture.asset(
                                      MyIconOld.ic_info,
                                      color: userController.userProfilemodel.value.verify == "UnApproved" ? color_primary_light : Colors.grey,
                                    ),
                              SizedBox(width: 5),
                              TextFont(
                                text: userController.userProfilemodel.value.verify ?? '',
                                fontSize: 10,
                                poppin: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(color: color_primary_light, borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFont(
                        text: 'ຮັບສ່ວນຫຼຸດສູງສຸດ 15%\nຈາກ M MoneyX',
                        maxLines: 2,
                        fontSize: 14,
                        color: color_fff,
                        noto: true,
                      ),
                    ),
                    Expanded(
                      // This is the expanded widget
                      child: Container(color: color_fff),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: color_2929.withOpacity(0.1), blurRadius: 10, spreadRadius: 5),
                ],
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/cart_gift.png', width: 25.w),
                  Container(
                    decoration: BoxDecoration(color: color_fff, borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFont(
                      text: 'ກົດຊວນໝູ່&ຮັບລາງວັນ',
                      fontSize: 10,
                      noto: true,
                      color: color_primary_light,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildInfomation() {
    return Container(
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
                  TextFont(text: "policy_and_term"),
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
              onTap: () {
                _showLanguageDialog(context);
              },
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
    );
  }

  Container buildConfig() {
    return Container(
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
                onChanged: (value) async {
                  // PermissionStatus status = await Permission.photos.request();
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
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageService = Get.find<LanguageService>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows bottom sheet to be flexible
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(
                text: 'Select Language',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: cr_7070, // Follow theme color
              ),
              SizedBox(height: 16),
              _buildLanguageOption(context, 'English', 'en', languageService),
              _buildLanguageOption(context, 'Lao', 'lo', languageService),
              _buildLanguageOption(context, 'Chinese', 'zh', languageService),
              _buildLanguageOption(context, 'Vietnamese', 'vi', languageService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageName, String languageCode, LanguageService languageService) {
    return ListTile(
      title: TextFont(
        text: languageName,
        color: cr_7070, // Follow theme color
      ),
      trailing: languageService.locale.languageCode == languageCode ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null, // Show check mark for the active language
      onTap: () {
        languageService.changeLanguage(languageCode);
        Get.back(); // Close the bottom sheet after selecting a language
      },
    );
  }
}
