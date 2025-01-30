import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/main/home_recommend.dart';
import 'package:super_app/widget/mask_msisdn.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cr_fbf7,
      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          padding: const EdgeInsets.all(1.5),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: color_fff,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              userController
                                          .userProfilemodel.value.profileImg !=
                                      null
                                  ? userController
                                      .userProfilemodel.value.profileImg!
                                  : MyConstant.profile_default,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Row(
                                  textBaseline: TextBaseline.ideographic,
                                  children: [
                                    TextFont(
                                      text: 'welcome',
                                      fontWeight: FontWeight.w600,
                                      color: cr_7070,
                                    ),
                                    const SizedBox(width: 5),
                                    TextFont(
                                      text:
                                          "${userController.userProfilemodel.value.name ?? ''} ${userController.userProfilemodel.value.surname ?? ''}",
                                      fontWeight: FontWeight.w600,
                                      color: cr_7070,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: ShapeDecoration(
                                    color: color_fff,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.5),
                              child: Row(
                                children: [
                                  TextFont(
                                    text: maskMsisdn(
                                      userController
                                              .userProfilemodel.value.msisdn ??
                                          '2000000',
                                      showMsisdn: showMsisdn,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showMsisdn = !showMsisdn;
                                      });
                                    },
                                    child: Icon(
                                      showMsisdn
                                          ? Iconsax.eye
                                          : Iconsax.eye_slash,
                                      color: cr_7070,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Icon(Iconsax.language_circle,
                              color: cr_2929, size: 18.sp),
                          onTap: () {
                            _showLanguageDialog(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.brightness_6),
                          onPressed: themeService.toggleTheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // TabBar and TabBarView will go here
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (index) => setState(() {
                          indexTabs = index;
                        }),
                        tabs: [
                          Tab(
                            child: TextFont(
                              text: 'recommend',
                              fontWeight: FontWeight.w600,
                              color: indexTabs == 0
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : cr_7070,
                            ),
                          ),
                          Tab(
                            child: TextFont(
                              text: 'telecom_service',
                              fontWeight: FontWeight.w600,
                              color: indexTabs == 1
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : cr_7070,
                            ),
                          ),
                        ],
                        indicatorColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          HomeRecommendScreen(), // HomeRecommend Component is here
                          Text("hi1231231"), // HomeTelecom Component is here
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
