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
              ),
              SizedBox(width: 10),
              _buildIconButton(
                icon: MyIcon.ic_more,
                text: 'other_service',
                isSvg: true,
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
          onTap: () => _showLanguageDialog(context), // ✅ Moved function inside AppbarLogin
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

  /// ✅ Moved `_showLanguageDialog()` inside AppbarLogin
  void _showLanguageDialog(BuildContext context) {
    final languageService = Get.find<LanguageService>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                color: cr_7070,
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
      leading: SvgPicture.asset(getSvgIcon(languageCode)),
      title: TextFont(
        text: languageName,
        color: cr_7070,
      ),
      trailing: languageService.locale.languageCode == languageCode ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
      onTap: () {
        languageService.changeLanguage(languageCode);
        Get.back(); // Close the bottom sheet after selecting a language
      },
    );
  }

  Widget _buildIconButton({required String icon, required String text, bool isSvg = false}) {
    return Column(
      children: [
        Container(
          height: 40.sp,
          width: 40.sp,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: color_fdeb, borderRadius: BorderRadius.circular(50)),
          child: isSvg ? SvgPicture.asset(icon) : Image.asset(icon),
        ),
        TextFont(
          text: text,
          fontSize: 8,
        ),
      ],
    );
  }
}
