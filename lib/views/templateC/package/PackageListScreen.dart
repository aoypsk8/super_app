// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/RoundedRectangleTabIndicator';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_card_borrowing.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({super.key});

  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen>
    with SingleTickerProviderStateMixin {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempCcontroler = Get.put(TempCController());
  int indexTabs = 0;
  final storage = GetStorage();
  late TabController _tabController;

  @override
  void initState() {
    userController.increasepage();
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    userController.decreasepage();
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(
          title: tempCcontroler.tempCservicedetail.value.description!),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            buildStepProcess(title: "2/2", desc: "ເລືອກແພັກເກດ gg"),
            SizedBox(height: 10),
            buildTabBar(context),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: RoundedRectangleTabIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              weight: 4.0,
              borderRadius: 10.0,
            ),
            onTap: (index) => setState(() {
              indexTabs = index;
            }),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: TextFont(
                  text: 'ຂາຍດີທີ່ສຸດ',
                  fontWeight: FontWeight.w600,
                  color: indexTabs == 0
                      ? Theme.of(context).colorScheme.onPrimary
                      : cr_7070,
                ),
              ),
              Tab(
                child: TextFont(
                  text: 'ໂປຣໂມຊັ່ນທັງໝົດ',
                  fontWeight: FontWeight.w600,
                  color: indexTabs == 1
                      ? Theme.of(context).colorScheme.onPrimary
                      : cr_7070,
                ),
              ),
              Tab(
                child: TextFont(
                  text: '',
                ),
              ),
              Tab(
                child: TextFont(
                  text: '',
                ),
              ),
            ],
            indicatorColor: Theme.of(context).colorScheme.onPrimary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildPackageRecomend(),
                buildPackageOther(),
                const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildPackageRecomend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tempCcontroler.tempCpackagemodel.length,
        itemBuilder: (BuildContext context, int index) {
          var recommned =
              tempCcontroler.tempCpackagemodel.value[index].popular!;
          return Column(
            children: [
              if (recommned == true) cardRecommendPacakge(index, recommned),
              // const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget cardRecommendPacakge(int index, bool recommned) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CardWidgetBorrowing(
        onTap: () {
          tempCcontroler.rxCouponAmount.value = 0;
          tempCcontroler.rxPaymentAmount.value = int.parse(tempCcontroler
              .tempCpackagemodel[index].amount
              .toString()
              .replaceAll(RegExp(r'[^\w\s]+'), ''));
          tempCcontroler.rxTotalAmount.value = int.parse(tempCcontroler
              .tempCpackagemodel[index].amount
              .toString()
              .replaceAll(RegExp(r'[^\w\s]+'), ''));
          //! set value package
          tempCcontroler.tempCpackagedetail.value =
              tempCcontroler.tempCpackagemodel[index];
          //! Call Request CashOut
          paymentController
              .reqCashOut(
                  transID: tempCcontroler.rxTransID.value,
                  amount: tempCcontroler.rxTotalAmount.value,
                  toAcc: tempCcontroler.rxAccNo.value,
                  chanel: homeController.menudetail.value.groupNameEN,
                  provider:
                      "${tempCcontroler.tempCdetail.value.groupTelecom!}|${tempCcontroler.tempCservicedetail.value.name!}",
                  package:
                      '${tempCcontroler.tempCpackagemodel[index].pKCode}|${tempCcontroler.tempCpackagemodel[index].sPNV}',
                  remark: tempCcontroler.rxNote.value)
              .then((value) => {
                    // if (value) {Get.to(() => const ConfirmPackageTempCnewScreen())}
                  });
        },
        packagename: tempCcontroler.tempCpackagemodel[index].packageName!,
        code: "ຊື້ແພັກເກັດ",
        gb: false,
        package: true,
        discountBool: tempCcontroler.tempCpackagemodel[index].discount != 0
            ? true
            : false,
        discountText: '${tempCcontroler.tempCdetail.value.discount}% OFF',
        amount: tempCcontroler.tempCpackagemodel[index].packageValue!,
        type: "",
        detail: tempCcontroler.tempCpackagemodel[index].packageValue!,
        detail2: tempCcontroler.tempCpackagemodel[index].userDay.toString(),
      ),
    );
  }

  buildPackageOther() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment(0.00, -2.00),
                  end: Alignment(0, 1),
                  colors: [
                    Color.fromARGB(255, 239, 83, 94),
                    Color.fromARGB(255, 248, 135, 142),
                    color_fff
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 100,
              child: SvgPicture.asset(
                MyIcon.bg_gradient1,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 3.1.h,
              left: 15,
              child: Row(
                children: [
                  TextFont(
                    text: 'ລາຍການແພັກເກັດ',
                    fontWeight: FontWeight.bold,
                    noto: true,
                  )
                ],
              ),
            ),
            Container(
              child: Positioned(
                top: 70,
                left: 10,
                right: 10,
                bottom: 0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tempCcontroler.tempCpackagemodel.length,
                  itemBuilder: (BuildContext context, int index) {
                    var recommned =
                        tempCcontroler.tempCpackagemodel.value[index].popular!;
                    return cardOtherPackage(index, recommned);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardOtherPackage(int index, bool recommned) {
    if (recommned) {
      return Container();
    } else {
      return InkWell(
        onTap: () {
          tempCcontroler.rxCouponAmount.value = 0;
          tempCcontroler.rxPaymentAmount.value = int.parse(tempCcontroler
              .tempCpackagemodel[index].amount
              .toString()
              .replaceAll(RegExp(r'[^\w\s]+'), ''));
          tempCcontroler.rxTotalAmount.value = int.parse(tempCcontroler
              .tempCpackagemodel[index].amount
              .toString()
              .replaceAll(RegExp(r'[^\w\s]+'), ''));
          //! set value package
          tempCcontroler.tempCpackagedetail.value =
              tempCcontroler.tempCpackagemodel[index];
          //! Call Request CashOut
          paymentController
              .reqCashOut(
                  transID: tempCcontroler.rxTransID.value,
                  amount: tempCcontroler.rxTotalAmount.value,
                  toAcc: tempCcontroler.rxAccNo.value,
                  chanel: homeController.menudetail.value.groupNameEN,
                  provider:
                      "${tempCcontroler.tempCdetail.value.groupTelecom!}|${tempCcontroler.tempCservicedetail.value.name!}",
                  package:
                      '${tempCcontroler.tempCpackagemodel[index].pKCode}|${tempCcontroler.tempCpackagemodel[index].sPNV}',
                  remark: tempCcontroler.rxNote.value)
              .then((value) => {
                    // if (value) {Get.to(() => const ConfirmPackageTempCnewScreen())}
                  });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              color: color_fff,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFont(
                        text:
                            '${tempCcontroler.tempCpackagemodel[index].packageName}',
                        fontWeight: FontWeight.w500,
                      ),
                      TextFont(
                        text:
                            'ດາຕ້າໃຊ້ໄດ້ ${tempCcontroler.tempCpackagemodel[index].packageValue}, ໄລຍະກຳນົດ ${tempCcontroler.tempCpackagemodel[index].userDay}ວັນ ',
                        color: color_777,
                        fontSize: 10,
                        noto: true,
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          TextFont(
                            text: fn.format(double.parse(tempCcontroler
                                .tempCpackagemodel[index].amount
                                .toString())),
                            // color: color_fff,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            poppin: true,
                          ),
                          SizedBox(width: 2.sp),
                          TextFont(
                            text: 'ກີບ',
                            fontSize: 10,
                            // color: color_fff,
                          ),
                        ],
                      ),
                      tempCcontroler.tempCpackagemodel[index].discount != 0
                          ? Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffC2EBAF),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: TextFont(
                                  text:
                                      '${tempCcontroler.tempCdetail.value.discount}% OFF',
                                  color: const Color(0xff458E24),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  poppin: true,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xff87D861)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
