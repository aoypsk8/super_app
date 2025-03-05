// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:super_app/test.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/login/calendar.dart';
import 'package:super_app/views/login/_login.dart';
import 'package:super_app/views/login/login.dart';
import 'package:super_app/views/login/login_have_acc.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/views/main/bottom_nav.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TempUserProfileStorage userStorage = TempUserProfileStorage();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() {
    List<TempUserProfile> users = userStorage.getTempUserProfiles();
    var msisdn = box.read('msisdn');

    print(msisdn);
    if (users.isNotEmpty && msisdn != null) {
      Future.delayed(Duration(seconds: 1)).then((_) {
        TempUserProfile? lastUser = userStorage.getLastLoggedInUser();
        Get.offAll(LoginHaveAccount(user: lastUser!.toJson()));
      });
    } else {
      Future.delayed(Duration(seconds: 1)).then((_) {
        Get.offAll(LoginScreen());
      });
    }
  }

  _checkUpdate() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                MyIcon.ic_logo_x,
                height: 80,
                width: 80,
              ),
              LoadingAnimationWidget.horizontalRotatingDots(
                color: color_primary_light,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
