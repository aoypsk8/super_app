// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/controllers/wetv_controller.dart';
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
          appBar: BuildAppBar(title: 'ຈ່າຍຄ່າ WeTV'),
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
                        desc: 'select package',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: weTVController.wetvlist.length,
                        itemBuilder: (context, index) {
                          final e = weTVController.wetvlist[index];
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
                          text: 'ລາຍການລ່າສຸດ',
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
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
                                      child: Icon(
                                        Icons.money,
                                        color: Colors.red,
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
                                                'Lao Mobile Money Sole Company...',
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
                                            text:
                                                DateFormat('dd MMM, yyyy HH:mm')
                                                    .format(
                                              DateTime.parse(e.created!
                                                  .replaceAll('/', '-')),
                                            ),
                                            color: color_777,
                                            fontSize: 10,
                                            poppin: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextFont(
                                      text: '-${fn.format(e.price)} LAK',
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            );
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
