import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/templateC/ListsServiceTempCScreen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ListProviderTempCScreen extends StatefulWidget {
  const ListProviderTempCScreen({super.key});

  @override
  State<ListProviderTempCScreen> createState() =>
      _ListProviderTempCScreenState();
}

class _ListProviderTempCScreenState extends State<ListProviderTempCScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempCcontroler = Get.put(TempCController());

  @override
  void initState() {
    userController.increasepage();
    tempCcontroler.fetchtempCList(homeController.menudetail.value);
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
              buildStepProcess(title: "1/5", desc: "telecome_service"),
              const SizedBox(height: 10),
              Expanded(
                child: tempCcontroler.tempCmodel.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: tempCcontroler.tempCmodel.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            columnCount: 3,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: buildListProvider(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListProvider(int index) {
    return InkWell(
      onTap: () {
        tempCcontroler.tempCdetail.value = tempCcontroler.tempCmodel[index];
        tempCcontroler.rxgroupTelecom.value =
            tempCcontroler.tempCmodel[index].groupTelecom.toString();
        Get.to(() => const ListServiceTempCScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: color_f4f4,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      tempCcontroler.tempCmodel[index].groupLogo.toString(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFont(
                text: tempCcontroler.tempCmodel[index].groupTelecom!,
                fontWeight: FontWeight.w400,
                fontSize: 11,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
