import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/views/other_service/other_service.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class AppbarLogin extends StatelessWidget {
  const AppbarLogin({super.key});
  @override
  Widget build(BuildContext context) {
    final GetStorage box = GetStorage();
    String languageCode = box.read('language') ?? 'lo';

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildIconButton(
                icon: 'assets/images/assistant.png',
                text: 'help',
                func: () {},
              ),
              SizedBox(width: 10),
              _buildIconButton(
                icon: MyIcon.ic_more,
                text: 'other_service',
                isSvg: true,
                func: () {
                  Get.to(OtherService());
                },
              ),
              // InkWell(
              //   onTap: () {
              //     final userStorage = TempUserProfileStorage();
              //     userStorage.addTempUserProfile(TempUserProfile(
              //       username: '2059395774',
              //       fullname: 'Oudomsak PHABOUDY',
              //       imageProfile: 'https://profile.mmoney.la/ImageProfile/2052555999/image_cropper_974829D0-223A-4966-AAD4-61355CFE596A-9313-000005AFC1BF66E0.jpg',
              //     ));
              //   },
              //   child: TextFont(
              //     text: 'add\naccount',
              //     maxLines: 2,
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        ),
        InkWell(
          onTap: () => _showLanguageDialog(
              context), // ✅ Moved function inside AppbarLogin
          child: Column(
            children: [
              Container(
                height: 40.sp,
                width: 40.sp,
                padding: EdgeInsets.all(5),
                child: SvgPicture.asset(getSvgIcon(languageCode)),
              ),
              TextFont(
                text: getLang(languageCode).toUpperCase(),
                fontSize: 8,
                poppin: true,
              )
            ],
          ),
        ),
      ],
    );
  }

  String getSvgIcon(String iconType) {
    switch (iconType) {
      case 'lo':
        return MyIconOld.flat_lao;
      case 'en':
        return MyIconOld.flat_usa;
      case 'zh':
        return MyIconOld.flat_ch;
      case 'vi':
        return MyIconOld.flat_vietnames;
      default:
        return MyIconOld.flat_lao;
    }
  }

  String getLang(String iconType) {
    switch (iconType) {
      case 'lo':
        return 'lao';
      case 'en':
        return 'english';
      case 'zh':
        return 'chinese';
      case 'vi':
        return 'vietnamese';
      default:
        return MyIconOld.flat_lao;
    }
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
                    decoration: BoxDecoration(
                        color: cr_ecec,
                        borderRadius: BorderRadius.circular(20)),
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
              _buildLanguageOption(
                  context, 'Vietnamese', 'vi', languageService),
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

  Widget _buildLanguageOption(BuildContext context, String languageName,
      String languageCode, LanguageService languageService) {
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
          border: isSelected
              ? Border.all(color: cr_ef33)
              : Border.all(color: Colors.transparent),
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

  Widget _buildIconButton(
      {required String icon,
      required String text,
      bool isSvg = false,
      required VoidCallback func}) {
    return InkWell(
      onTap: func,
      child: Column(
        children: [
          Container(
            height: 40.sp,
            width: 40.sp,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color_fdeb, borderRadius: BorderRadius.circular(50)),
            child: isSvg ? SvgPicture.asset(icon) : Image.asset(icon),
          ),
          TextFont(
            text: text,
            fontSize: 8,
          ),
        ],
      ),
    );
  }
}
