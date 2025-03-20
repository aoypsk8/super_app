import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/image_preview.dart';
import 'package:super_app/views/main/home_recommend.dart';
import 'package:super_app/views/main/telecom_services.dart';
import 'package:super_app/views/notification/notification_box.dart';
import 'package:super_app/views/webview/webapp_webview.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final themeService = Get.find<ThemeService>();
  final UserController userController = Get.find();
  final storage = GetStorage();
  bool showMsisdn = false;
  int indexTabs = 0;
  late TabController _tabController;

  final HomeController homeController = Get.find();
  File? _backgroundImage;

  @override
  void initState() {
    super.initState();

    // Initialize TabController and listen for changes
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != indexTabs) {
        setState(() {
          indexTabs = _tabController.index;
        });
      }
    });
    setState(() {
      if (homeController.rxBgBanner.value == '') {
        _backgroundImage = null;
      } else {
        _backgroundImage = File(homeController.rxBgBanner.value);
      }
    });

    // Set background image without using setState in initState
    if (homeController.rxBgBanner.value == '') {
      _backgroundImage = null;
    } else {
      _backgroundImage = File(homeController.rxBgBanner.value);
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // backgroundColor: cr_fbf7,
    // body: Obx(
    //   () => Container(
    //     decoration: _backgroundImage == null
    //         ? BoxDecoration(
    //             color: color_fff,
    //             image: DecorationImage(
    //               image: AssetImage(MyIcon.deault_theme),
    //               // fit: BoxFit.fill,
    //             ),
    //           )
    //         : BoxDecoration(
    //             color: color_fff,
    //             image: DecorationImage(
    //               image: FileImage(_backgroundImage!),
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //     child: SafeArea(
    //       child: Container(
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 15),
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Container(
    //                     child: Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           width: 12.w,
    //                           height: 12.w,
    //                           padding: const EdgeInsets.all(1.5),
    //                           margin: const EdgeInsets.only(left: 4),
    //                           decoration: BoxDecoration(
    //                             color: color_fff,
    //                             borderRadius: BorderRadius.circular(30),
    //                           ),
    //                           child: ClipRRect(
    //                             borderRadius: BorderRadius.circular(50.0),
    //                             child: Image.network(
    //                               userController.userProfilemodel.value.profileImg != null
    //                                   ? userController.userProfilemodel.value.profileImg!
    //                                   : MyConstant.profile_default,
    //                             ),
    //                           ),
    //                         ),
    //                         const SizedBox(width: 10),
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Row(
    //                               textBaseline: TextBaseline.ideographic,
    //                               children: [
    //                                 TextFont(
    //                                   text: 'welcome_first_screen',
    //                                   fontWeight: FontWeight.w600,
    //                                   color: cr_7070,
    //                                 ),
    //                                 const SizedBox(width: 3),
    //                                 TextFont(
    //                                   text: "${userController.userProfilemodel.value.name ?? ''}!",
    //                                   fontWeight: FontWeight.w600,
    //                                   color: cr_7070,
    //                                 )
    //                               ],
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.only(top: 2.5),
    //                               child: Row(
    //                                 children: [
    //                                   TextFont(
    //                                     text: maskMsisdn(
    //                                       userController.userProfilemodel.value.msisdn ?? '2000000',
    //                                       showMsisdn: showMsisdn,
    //                                     ),
    //                                     fontSize: 14,
    //                                     fontWeight: FontWeight.w500,
    //                                     color: cr_2929,
    //                                     poppin: true,
    //                                   ),
    //                                   const SizedBox(width: 10),
    //                                   GestureDetector(
    //                                     onTap: () {
    //                                       setState(() {
    //                                         showMsisdn = !showMsisdn;
    //                                       });
    //                                     },
    //                                     child: Icon(
    //                                       size: 16.sp,
    //                                       showMsisdn ? Iconsax.eye : Iconsax.eye_slash,
    //                                       color: cr_7070,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   Row(
    //                     children: [
    //                       Stack(
    //                         children: [
    //                           IconButton(
    //                             icon: Icon(Iconsax.notification),
    //                             onPressed: () {
    //                               Get.to(() => NotificationBox());
    //                             },
    //                           ),
    //                           Positioned(
    //                             right: 13,
    //                             top: 13,
    //                             child: Container(
    //                               padding: EdgeInsets.all(1),
    //                               decoration: BoxDecoration(
    //                                 color: cr_ef33,
    //                                 borderRadius: BorderRadius.circular(100),
    //                               ),
    //                               constraints: BoxConstraints(
    //                                 minWidth: 10,
    //                                 minHeight: 10,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             // TabBar and TabBarView will go here
    //             Expanded(
    //               child: Column(
    //                 children: [
    //                   Padding(
    //                     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    //                     child: TabBar(
    //                       controller: _tabController,
    //                       indicatorSize: TabBarIndicatorSize.tab,
    //                       onTap: (index) => setState(() {
    //                         indexTabs = index;
    //                       }),
    //                       dividerColor: Colors.transparent,
    //                       tabs: [
    //                         Tab(
    //                           child: TextFont(
    //                             text: 'recommend',
    //                             fontWeight: FontWeight.w600,
    //                             color: indexTabs == 0 ? Theme.of(context).colorScheme.onPrimary : cr_7070,
    //                           ),
    //                         ),
    //                         Tab(
    //                           child: TextFont(
    //                             text: 'telecom_service',
    //                             fontWeight: FontWeight.w600,
    //                             color: indexTabs == 1 ? Theme.of(context).colorScheme.onPrimary : cr_7070,
    //                           ),
    //                         ),
    //                       ],
    //                       indicatorColor: Theme.of(context).colorScheme.onPrimary,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),

    //             Expanded(
    //               child: TabBarView(
    //                 controller: _tabController,
    //                 children: [
    //                   HomeRecommendScreen(), // HomeRecommend Component is here
    //                   Text("hi1231231"), // HomeTelecom Component is here
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    // );
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: _backgroundImage == null
                ? BoxDecoration(
                    color: color_fff,
                    image: DecorationImage(
                      image: AssetImage(MyIcon.deault_theme),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    color: color_fff,
                    image: DecorationImage(
                      image: FileImage(_backgroundImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.to(ImagepreviewScreen(
                                          imageUrl: userController
                                              .userProfilemodel
                                              .value
                                              .profileImg!,
                                          title: 'profile')),
                                      child: Container(
                                        width: 15.w,
                                        height: 15.w,
                                        padding: const EdgeInsets.all(1.5),
                                        margin: const EdgeInsets.only(left: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: color_fff,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: Image.network(
                                            userController.userProfilemodel
                                                        .value.profileImg !=
                                                    null
                                                ? userController
                                                    .userProfilemodel
                                                    .value
                                                    .profileImg!
                                                : MyConstant.profile_default,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            TextFont(
                                              text: 'welcome_first_screen',
                                              fontWeight: FontWeight.w600,
                                              color: color_fff,
                                            ),
                                            const SizedBox(width: 3),
                                            TextFont(
                                              text:
                                                  "${userController.userProfilemodel.value.name ?? ''}!",
                                              fontWeight: FontWeight.w600,
                                              color: color_fff,
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.5),
                                          child: Row(
                                            children: [
                                              TextFont(
                                                text: maskMsisdn(
                                                  userController
                                                          .userProfilemodel
                                                          .value
                                                          .msisdn ??
                                                      '2000000',
                                                  showMsisdn: showMsisdn,
                                                ),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: color_fff,
                                                poppin: true,
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    showMsisdn = !showMsisdn;
                                                  });
                                                },
                                                child: Icon(
                                                  size: 16.sp,
                                                  showMsisdn
                                                      ? Iconsax.eye
                                                      : Iconsax.eye_slash,
                                                  color: color_fff,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    IconButton(
                                      icon: Icon(Iconsax.notification_bing5),
                                      onPressed: () {
                                        Get.to(() => NotificationBox());
                                      },
                                      color: color_fff,
                                    ),
                                    Positioned(
                                      right: 13,
                                      top: 13,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: cr_ef33,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 10,
                                          minHeight: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: cr_black.withOpacity(0.05),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          onTap: (index) {
                            setState(() {
                              indexTabs = index;
                            });
                          },
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              child: TextFont(
                                text: 'recommend',
                                fontWeight: FontWeight.w600,
                                color: indexTabs == 0 ? color_fff : cr_7070,
                              ),
                            ),
                            Tab(
                              child: TextFont(
                                text: 'telecom_service',
                                fontWeight: FontWeight.w600,
                                color: indexTabs == 1 ? color_fff : cr_7070,
                              ),
                            ),
                          ],
                          indicatorColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // TextButton(
          //     onPressed: () => Get.to(WebappWebviewScreen(
          //           urlWidget: 'https://mmoney.la',
          //         )),
          //     child: TextFont(text: 'NewMenu')),
          // Obx(
          //   () => TextFont(text: 'token : ${userController.rxToken.value}', color: color_1a1, maxLines: 3),
          // ),
          //! detail tabbar
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                HomeRecommendScreen(),
                TelecomServices(),
              ],
            ),
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
              _buildLanguageOption(
                  context, 'Vietnamese', 'vi', languageService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageName,
      String languageCode, LanguageService languageService) {
    return ListTile(
      title: TextFont(
        text: languageName,
        color: cr_7070, // Follow theme color
      ),
      trailing: languageService.locale.languageCode == languageCode
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null, // Show check mark for the active language
      onTap: () {
        languageService.changeLanguage(languageCode);
        Get.back(); // Close the bottom sheet after selecting a language
      },
    );
  }
}
