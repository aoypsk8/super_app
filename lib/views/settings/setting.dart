// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/splash_screen.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/login/login_have_acc.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/views/settings/account_profile.dart';
import 'package:super_app/views/settings/verify_account.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();
  final userController = Get.find<UserController>();
  final themeService = Get.find<ThemeService>();
  final _confirmPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
              InkWell(
                onTap: () {
                  userController.isRenewToken.value = false;
                  Get.offAll(SplashScreen());
                },
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
                      backgroundImage: CachedNetworkImageProvider(
                        userController.userProfilemodel.value.profileImg ?? MyConstant.profile_default,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 8),
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
                              text: isHidden
                                  ? maskMsisdn(userController.userProfilemodel.value.msisdn ?? '2055555555')
                                  : userController.userProfilemodel.value.msisdn!,
                              poppin: true,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isHidden = !isHidden;
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
                                      color: userController.userProfilemodel.value.verify == "UnApproved"
                                          ? color_primary_light
                                          : Colors.grey,
                                    ),
                              SizedBox(width: 5),
                              TextFont(
                                text: userController.userProfilemodel.value.verify == 'Pending'
                                    ? '...Watting'
                                    : userController.userProfilemodel.value.verify!,
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
            child: InkWell(
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
            child: InkWell(
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
            child: InkWell(
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
          Divider(color: color_ecec),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  themeService.toggleTheme();
                },
                child: Row(
                  children: [
                    TextFont(text: "change_theme"),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: color_7070, size: 15.sp),
                  ],
                ),
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
            child: InkWell(
              onTap: () {
                Get.to(AccountProfileScreen());
              },
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
            child: InkWell(
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
          userController.userProfilemodel.value.verify == "Approved" ||
                  userController.userProfilemodel.value.verify == "Pending"
              ? SizedBox.shrink()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () {
                          Get.to(VerifyAccountScreen());
                        },
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
                  ],
                ),
          Row(
            children: [
              TextFont(text: "biometric"),
              Spacer(),
              Switch(
                value: box.read('biometric') ?? false,
                onChanged: (value) async {
                  if (value) {
                    bool isAuthenticated = await _showPasswordConfirmationDialog(context);
                    if (isAuthenticated) {
                      setState(() {
                        box.write('biometric', value);
                      });
                    }
                  } else {
                    setState(() {
                      box.write('biometric', value);
                    });
                  }
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width / 7,
                    height: 5,
                    decoration: BoxDecoration(color: cr_ecec, borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFont(
                    text: 'Select Language',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: cr_7070,
                    poppin: true,
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: color_ecec),
              _buildLanguageOption(context, 'English', 'en', languageService),
              _buildLanguageOption(context, 'ລາວ', 'lo', languageService),
              _buildLanguageOption(context, 'Chinese', 'zh', languageService),
              _buildLanguageOption(context, 'Vietnamese', 'vi', languageService),
              SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: buildBottomAppbar(
                  paddingbottom: 0,
                  bgColor: Theme.of(context).primaryColor,
                  title: 'save',
                  func: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String languageName, String languageCode, LanguageService languageService) {
    bool isSelected = languageService.locale.languageCode == languageCode;

    return GestureDetector(
      onTap: () {
        languageService.changeLanguage(languageCode);
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: color_f4f4,
          border: isSelected ? Border.all(color: cr_ef33) : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            languageCode == 'en'
                ? SvgPicture.asset(
                    MyIcon.flat_usa,
                    width: 7.w,
                    height: 7.w,
                  )
                : languageCode == 'lo'
                    ? SvgPicture.asset(
                        MyIcon.flat_lao,
                        width: 7.w,
                        height: 7.w,
                      )
                    : languageCode == 'zh'
                        ? SvgPicture.asset(
                            MyIcon.flat_ch,
                            width: 7.w,
                            height: 7.w,
                          )
                        : SvgPicture.asset(
                            MyIcon.flat_vietnames,
                            width: 7.w,
                            height: 7.w,
                          ),
            SizedBox(width: 10),
            Expanded(
              child: TextFont(
                text: languageName,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: cr_2929,
                noto: languageCode == 'lo' ? true : false,
              ),
            ),
            if (isSelected) Icon(Icons.check, color: cr_ef33),
          ],
        ),
      ),
    );
  }

  Future<bool> _showPasswordConfirmationDialog(BuildContext context) async {
    String? msisdn = storage.read('msisdn');
    TempUserProfileStorage boxUser = TempUserProfileStorage();
    TempUserProfile? user = boxUser.getUserByUsername(msisdn ?? '');
    final TextEditingController _passwordController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isAuthenticated = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            child: Padding(
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
                                user.imageProfile,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFont(text: user.fullname, fontSize: 14, fontWeight: FontWeight.w500, noto: true),
                      SizedBox(height: 10),
                      TextFont(text: user.username, fontSize: 14, color: color_777, poppin: true),
                      SizedBox(height: 10),
                      buildPasswordField(
                          controller: _passwordController, label: 'confirm_password', name: 'confirm_password'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(false);
                            },
                            child: TextFont(text: 'Cancel', color: color_777),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                isAuthenticated = await userController.chkPasswordSetBiometic(
                                    user.username, _passwordController.text);
                                if (isAuthenticated) {
                                  Navigator.of(dialogContext).pop(true);
                                } else {
                                  ScaffoldMessenger.of(dialogContext)
                                      .showSnackBar(SnackBar(content: Text('Incorrect password')));
                                }
                              }
                            },
                            child: TextFont(
                              text: 'Confirm',
                              color: Theme.of(dialogContext).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return isAuthenticated;
  }
}
