// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/qr_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/web/openWebView.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final qrController = Get.put(QrController());
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    homeController.menuModel.forEach((menu) {
      print('Menu Title: ${menu.title}');
      if (menu.menulists != null && menu.menulists!.isNotEmpty) {
        print('Menulists for ${menu.title}:');
        menu.menulists!.forEach((menulist) {
          print(
              ' - AppID: ${menulist.appid}, GroupName_EN: ${menulist.groupNameEN}');
        });
      } else {
        print('No menulists found for ${menu.title}');
      }
    });

    // Assign the fetched data to the reactive list
    return Obx(
      () => Scaffold(
        appBar: BuildAppBar(title: "service_nav"),
        body: ListView.builder(
          itemCount: homeController.menuModel.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, menuIndex) {
            var menuModelItem = homeController.menuModel[menuIndex];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding:
                  EdgeInsets.only(right: 26, left: 26, top: 12, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  TextFont(
                    text: menuModelItem.title!,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  SizedBox(height: 3),
                  Container(
                    width: 13.w,
                    height: 3,
                    decoration: BoxDecoration(
                      color: cr_ef33,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: AlignedGridView.count(
                      itemCount: menuModelItem.menulists!.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 17,
                      crossAxisSpacing: 20,
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var result = menuModelItem.menulists![index];
                        String? url = result.logo;
                        String? updatedUrl = url!.replaceFirst(
                          'https://mmoney.la',
                          'https://gateway.ltcdev.la/AppImage',
                        );
                        return InkWell(
                          onTap: () async {
                            await homeController.clear();
                            print(result.template);
                            if (!userController.isCheckToken.value) {
                              userController.isCheckToken.value = true;
                              if (result.template == "proof") {
                                homeController.menutitle.value =
                                    result.groupNameEN!;
                                homeController.menudetail.value = result;
                                qrController.fetchProofLists();

                                Get.toNamed('/${result.template}');
                              } else {
                                userController
                                    .checktoken(name: 'menu')
                                    .then((value) {
                                  if (userController.isLogin.value) {
                                    if (result.template != '/') {
                                      homeController.menutitle.value =
                                          result.groupNameEN!;
                                      homeController.menudetail.value = result;
                                      if (result.template == "webview") {
                                        Get.to(
                                          OpenWebView(
                                              url: homeController
                                                  .menudetail.value.url
                                                  .toString()),
                                        );
                                      } else {
                                        Get.toNamed('/${result.template}');
                                      }
                                    } else {
                                      DialogHelper.showErrorDialogNew(
                                        description: 'Not available',
                                      );
                                    }
                                  }
                                });
                              }
                              userController.isCheckToken.value = false;
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 6),
                              SvgPicture.network(
                                updatedUrl,
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: const CircularProgressIndicator(),
                                ),
                                width: 8.5.w,
                                height: 8.5.w,
                              ),
                              SizedBox(height: 10),
                              TextFont(
                                text: getLocalizedGroupName(result),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w400,
                                maxLines: 2,
                                color: cr_4139,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String getLocalizedGroupName(result) {
  switch (Get.locale?.languageCode) {
    case 'en':
      return result.groupNameEN ?? '';
    case 'lo':
      return result.groupNameLA ?? '';
    case 'zh':
      return result.groupNameCH ?? '';
    case 'vi':
      return result.groupNameVT ?? '';
    default:
      return result.groupNameEN ?? '';
  }
}
