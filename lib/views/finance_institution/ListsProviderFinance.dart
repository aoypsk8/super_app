import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/finance_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class ListsProviderFinance extends StatefulWidget {
  const ListsProviderFinance({super.key});

  @override
  State<ListsProviderFinance> createState() => _ListsProviderFinanceState();
}

class _ListsProviderFinanceState extends State<ListsProviderFinance> {
  final HomeController homeController = Get.find();
  final UserController userController = Get.find();
  final financeController = Get.put(FinanceController());

  @override
  void initState() {
    super.initState();
    userController.increasepage();
    financeController.fetchInstitution();
  }

  @override
  void dispose() {
    super.dispose();
    userController.decreasepage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(
          title: "homeController.menudetail.value.groupNameEN.toString()"),
      body: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(
                text: 'ເລືອກສະຖາບັນ',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: financeController.financeModel.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          financeController.financeModelDetail.value =
                              financeController.financeModel[index];
                          Get.toNamed("/vertifyAccountFinace");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color_f4f4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  child: CachedNetworkImage(
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                        color: cr_red,
                                      ),
                                    ),
                                    imageUrl: financeController
                                        .financeModel[index].logo
                                        .toString(),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFont(
                                        text: financeController
                                            .financeModel[index].title!,
                                        fontWeight: FontWeight.w500,
                                        maxLines: 1,
                                        fontSize: 12.sp,
                                      ),
                                      TextFont(
                                        text: 'Finance institution',
                                        fontWeight: FontWeight.w400,
                                        maxLines: 1,
                                        color: cr_2929,
                                        fontSize: 9.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
