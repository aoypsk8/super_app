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
                desc: 'ລາຍການທັງໝົດ',
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
                                    ...provider.data
                                        .map((data) => GestureDetector(
                                              onTap: () {
                                                DialogHelper.showBorrowPopup(
                                                  borrow: data.type == 'airtime'
                                                      ? "ຢືມມູນຄ່າໂທ"
                                                      : "ຢືມເນັດ",
                                                  amount: data.type == 'airtime'
                                                      ? "${fn.format(int.parse(data.amount.replaceAll(RegExp(r'[^0-9]'), '')))} LAK"
                                                      : "${data.amount}GB",
                                                  onConfirm: () {
                                                    // Store provider path in rxPathUrl
                                                    borrowingController
                                                        .rxPathUrl
                                                        .value = provider.path;

                                                    // Call borrowing process
                                                    borrowingController
                                                        .borrowingProcess();
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0),
                                                child: CardWidget(
                                                  packagename: data.packagename,
                                                  code: data.code,
                                                  amount:
                                                      data.amount.toString(),
                                                  type: data.type,
                                                  detail: data.detail,
                                                ),
                                              ),
                                            ))
                                        .toList(),
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

class CardWidget extends StatelessWidget {
  final String packagename;
  final String code;
  final String amount;
  final String type;
  final String detail;

  CardWidget({
    required this.packagename,
    required this.code,
    required this.amount,
    required this.type,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: color_ec1c,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 22.h,
          child: Stack(
            children: [
              SvgPicture.asset(
                MyIcon.bgOfCard,
                color: cr_ef33,
              ),
              SizedBox(
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFont(
                                text: type == 'airtime'
                                    ? "ຢືມມູນຄ່າໂທ"
                                    : "ຢືມເນັດ",
                                color: color_fff,
                                fontSize: 13,
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(50), // Makes it round
                                child: Image.asset(
                                  "assets/icons/ltc_logo.png", // Using asset image
                                  width: 30, // Adjust size as needed
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            type == 'airtime'
                                ? "${fn.format(int.parse(amount.replaceAll(RegExp(r'[^0-9]'), '')))} LAK"
                                : "${amount}GB",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            detail,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                Icon(Icons.phone,
                                    color: Colors.red.shade700, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  code,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: cr_b326,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "New",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    packagename,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
