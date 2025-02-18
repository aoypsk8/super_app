import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_b_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/templateB/verify_account_tempB.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ListProviderTempBScreen extends StatefulWidget {
  const ListProviderTempBScreen({super.key});

  @override
  State<ListProviderTempBScreen> createState() =>
      _ListProviderTempBScreenState();
}

class _ListProviderTempBScreenState extends State<ListProviderTempBScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempBcontroler = Get.put(TempBController());

  @override
  void initState() {
    userController.increasepage();
    tempBcontroler.fetchtempBList(homeController.menudetail.value);
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: homeController.getMenuTitle()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: buildStepProcess(
              title: '1/5',
              desc: 'select_lists_item',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(() {
                if (tempBcontroler.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (tempBcontroler.tampBmodel.isEmpty) {
                  return Center(
                    child: TextFont(
                      text: 'No data available',
                      color: Theme.of(context).primaryColor,
                      poppin: true,
                    ),
                  );
                }

                return AnimationLimiter(
                  child: ListView.builder(
                    itemCount: tempBcontroler.tampBmodel.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 550),
                        child: SlideAnimation(
                          verticalOffset: 1,
                          child: FlipAnimation(
                            child: buildListProvider(index),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListProvider(int index) {
    return InkWell(
      onTap: () {
        tempBcontroler.tempBdetail.value = tempBcontroler.tampBmodel[index];
        tempBcontroler.fetchrecent(homeController.menudetail.value);
        Get.to(() => VerifyAccountTempB());
      },
      child: Container(
        decoration: BoxDecoration(
          color: color_eee,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: ClipOval(
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: cr_red,
                    ),
                  ),
                  imageUrl: tempBcontroler.tampBmodel[index].logo
                      .toString()
                      .replaceAll(
                        'https://mmoney.la',
                        'https://gateway.ltcdev.la/AppImage',
                      ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFont(
                    text: tempBcontroler.tampBmodel[index].nameLa.toString(),
                    fontWeight: FontWeight.w700,
                    noto: true,
                  ),
                  TextFont(
                    text: tempBcontroler.tampBmodel[index].nameEn.toString(),
                    fontSize: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
