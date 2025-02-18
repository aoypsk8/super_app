// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/controllers/wetv_controller.dart';
import 'package:super_app/models/wetv_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/views/weTV/confirm_weTV.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class WeTvPackageList extends StatefulWidget {
  const WeTvPackageList({Key? key}) : super(key: key);

  @override
  State<WeTvPackageList> createState() => _WeTvPackageListState();
}

class _WeTvPackageListState extends State<WeTvPackageList> {
  final userController = Get.find<UserController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    userController.increasepage();
    super.initState();
    Get.lazyPut<WeTVController>(() => WeTVController());
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WeTVController weTVController = Get.find();
    return Obx(() => Scaffold(
          backgroundColor: cr_fbf7,
          appBar: BuildAppBar(title: homeController.getMenuTitle()),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: color_fff,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: buildStepProcess(
                        title: '1/3',
                        desc: 'select_package',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AlignedGridView.count(
                        itemCount: weTVController.wetvlist.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final e = weTVController.wetvlist[index];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            columnCount: 2,
                            child: ScaleAnimation(
                              scale: 0.5,
                              child: FadeInAnimation(
                                child: buildWeTvCard(
                                  weTVController: weTVController,
                                  e: e,
                                  homeController: homeController,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: color_fff,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFont(
                          text: 'history',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true, // Keep this
                          itemCount: weTVController.wetvhistory.length,
                          itemBuilder: (context, index) {
                            final e = weTVController.wetvhistory[index];

                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 550),
                                child: SlideAnimation(
                                  verticalOffset:
                                      50, // Slightly increased for a better effect
                                  child: FlipAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: e.code!));
                                        Get.snackbar(
                                          'Copied!',
                                          'Code copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              cr_b326.withOpacity(0.1),
                                          colorText: cr_b326,
                                          duration: Duration(seconds: 2),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                spreadRadius: 1,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.1),
                                                backgroundImage: NetworkImage(
                                                  MyConstant.profile_default,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextFont(
                                                      text:
                                                          'Lao Mobile Money Sole Company',
                                                      fontSize: 12,
                                                    ),
                                                    SizedBox(height: 4),
                                                    TextFont(
                                                      text: e.code!,
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                    ),
                                                    SizedBox(height: 4),
                                                    TextFont(
                                                      text: DateFormat(
                                                              'dd MMM, yyyy HH:mm')
                                                          .format(
                                                        DateTime.parse(e
                                                            .created!
                                                            .replaceAll(
                                                                '/', '-')),
                                                      ),
                                                      color: color_777,
                                                      fontSize: 10,
                                                      poppin: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextFont(
                                                text:
                                                    '-${fn.format(e.price)} LAK',
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class buildWeTvCard extends StatelessWidget {
  const buildWeTvCard({
    super.key,
    required this.weTVController,
    required this.e,
    required this.homeController,
  });

  final WeTVController weTVController;
  final WeTvList e;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        weTVController.wetvdetail.value = e;
        Get.to(ListsPaymentScreen(
          description: 'select_payment',
          stepBuild: '2/3',
          title: homeController.getMenuTitle(),
          onSelectedPayment: () {
            Get.to(() => ConfirmWeTVScreen());
            return Container();
          },
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              e.logo!,
              width: 15.w,
              height: 15.w,
            ),
            SizedBox(height: 12),
            TextFont(
              text: 'ແພັກເກັດ ${e.day} ມື້',
              fontSize: 12,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            TextFont(
              text: '${fn.format(e.price)} LAK',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
