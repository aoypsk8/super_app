import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/templateC/VerifyAccountTempCNewScreen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ListServiceTempCScreen extends StatefulWidget {
  const ListServiceTempCScreen({super.key});

  @override
  State<ListServiceTempCScreen> createState() => _ListServiceTempCScreenState();
}

class _ListServiceTempCScreenState extends State<ListServiceTempCScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempCcontroler = Get.put(TempCController());

  @override
  void initState() {
    userController.increasepage();
    tempCcontroler.fetchServiceList();
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_grey_background,
        appBar: BuildAppBar(title: homeController.menutitle.value),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildStepProcess(title: "2/5", desc: "telecome_service2"),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: tempCcontroler.tempCservicemodel.length,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListProvider(int index) {
    return InkWell(
      onTap: () {
        tempCcontroler.tempCservicedetail.value =
            tempCcontroler.tempCservicemodel[index];
        Get.to(() => const VerifyAccountTempCNewScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: color_f4f4,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.network(tempCcontroler
                      .tempCservicemodel[index].logo
                      .toString()
                      .replaceAll('https://mmoney.la',
                          'https://gateway.ltcdev.la/AppImage')),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text:
                          tempCcontroler.tempCservicemodel[index].description!,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      fontSize: 12,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
