import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/borrowing_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_card_borrowing.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class ListsBorrowing extends StatefulWidget {
  const ListsBorrowing({super.key});

  @override
  State<ListsBorrowing> createState() => _ListsBorrowingState();
}

class _ListsBorrowingState extends State<ListsBorrowing> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final borrowingController = Get.put(BorrowingController());
  final NumberFormat fn = NumberFormat("#,###"); // Formatting instance

  @override
  void initState() {
    super.initState();
    userController.increasepage();

    // Fetch provider list only if menu details are available
    if (homeController.menudetail.value.url != null &&
        homeController.menudetail.value.url!.isNotEmpty) {
      borrowingController.fetchBorrowingList(homeController.menudetail.value);
    } else {
      print("Error: Menu detail URL is null or empty.");
    }
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
        backgroundColor: color_fff,
        appBar: BuildAppBar(title: homeController.getMenuTitle()),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: buildStepProcess(
                title: '',
                desc: 'all_lists',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() {
                  if (borrowingController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (borrowingController.borrowingModels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          TextFont(
                            text: 'Loading...',
                            color: Theme.of(context).primaryColor,
                            poppin: true,
                          ),
                        ],
                      ),
                    );
                  }

                  return AnimationLimiter(
                    child: ListView.builder(
                      itemCount: borrowingController.borrowingModels.length,
                      itemBuilder: (context, index) {
                        final provider =
                            borrowingController.borrowingModels[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 550),
                          child: SlideAnimation(
                            verticalOffset: 1,
                            child: FlipAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...provider.data.map(
                                      (data) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        child: CardWidgetBorrowing(
                                          onTap: () {
                                            DialogHelper.showBorrowPopup(
                                              borrow: data.type == 'airtime'
                                                  ? "airtime_borrow".tr
                                                  : "data_borrow".tr,
                                              amount: data.type == 'airtime'
                                                  ? "${fn.format(int.parse(data.amount.replaceAll(RegExp(r'[^0-9]'), '')))} LAK"
                                                  : "${data.amount}GB",
                                              onConfirm: () {
                                                // Store provider path in rxPathUrl
                                                borrowingController.rxPathUrl
                                                    .value = provider.path;
                                                // Call borrowing process
                                                borrowingController
                                                    .borrowingProcess();
                                              },
                                            );
                                          },
                                          packagename: data.packagename,
                                          code: data.code,
                                          amount: data.amount.toString(),
                                          type: data.type,
                                          detail: data.detail,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
