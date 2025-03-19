// ignore_for_file: invalid_use_of_protected_member, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/RoundedRectangleTabIndicator';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_card_borrowing.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/input_cvv.dart';
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
            buildStepProcess(title: "4/6", desc: "choose_package"),
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
                  text: 'the_most_sold',
                  fontWeight: FontWeight.w600,
                  color: indexTabs == 0
                      ? Theme.of(context).colorScheme.onPrimary
                      : cr_7070,
                ),
              ),
              Tab(
                child: TextFont(
                  text: 'all_promotion',
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
                buildPackageAll(),
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
          tempCcontroler.enableBottom.value = false;
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
                    if (value)
                      {
                        tempCcontroler.enableBottom.value = true,
                        Get.to(ListsPaymentScreen(
                          description:
                              homeController.menudetail.value.groupNameEN!,
                          stepBuild: '5/6',
                          title: homeController.getMenuTitle(),
                          onSelectedPayment:
                              (paymentType, cardIndex, uuid) async {
                            if (paymentType == "Other") {
                              // homeController.RxamountUSD.value =
                              //     await homeController.convertRate(
                              //         tempCcontroler
                              //             .tempCpackagedetail.value.amount!);
                              // tempCcontroler.rxTransID.value =
                              //     "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
                              // Get.to(PaymentVisaMasterCard(
                              //   function: () {
                              //     tempCcontroler
                              //         .paymentPackageVisaWithoutstoredCardUniqueID(
                              //       homeController.menudetail.value,
                              //     );
                              //   },
                              //   trainID: tempCcontroler.rxTransID.value,
                              //   description: tempCcontroler.rxNote.value,
                              //   amount: tempCcontroler.rxTotalAmount.value,
                              // ));
                            } else if (paymentType == 'MMONEY') {
                              navigateToConfirmScreen(paymentType);
                            } else {
                              homeController.RxamountUSD.value =
                                  await homeController.convertRate(
                                      tempCcontroler
                                          .tempCpackagedetail.value.amount!);
                              String? cvv =
                                  await showDynamicQRDialog(context, () {});
                              if (cvv != null &&
                                  cvv.isNotEmpty &&
                                  cvv.length >= 3) {
                                navigateToConfirmScreen(
                                  paymentType,
                                  cvv,
                                  uuid,
                                );
                              } else {
                                DialogHelper.showErrorDialogNew(
                                  description: "please_input_cvv",
                                );
                              }
                            }
                          },
                        ))
                      }
                    else
                      {
                        tempCcontroler.enableBottom.value = true,
                      }
                  });
        },
        packagename: tempCcontroler.tempCpackagemodel[index].packageName!,
        code: "purchase",
        gb: false,
        package: true,
        discountBool: tempCcontroler.tempCpackagemodel[index].discount != 0
            ? true
            : false,
        discountText: '${tempCcontroler.tempCdetail.value.discount}% OFF',
        amount: tempCcontroler.tempCpackagemodel[index].packageValue!,
        type: "",
        detail: fn.format(tempCcontroler.tempCpackagemodel[index].amount),
        detail2: tempCcontroler.tempCpackagemodel[index].userDay.toString(),
      ),
    );
  }

  buildPackageAll() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tempCcontroler.tempCpackagemodel.length,
        itemBuilder: (BuildContext context, int index) {
          var recommned =
              tempCcontroler.tempCpackagemodel.value[index].popular!;
          return cardOtherPackage(index, recommned);
        },
      ),
    );
  }

  Widget cardOtherPackage(int index, bool recommned) {
    if (recommned) {
      return Container();
    } else {
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
                .then(
                  (value) => {
                    if (value)
                      {
                        tempCcontroler.enableBottom.value = true,
                        Get.to(
                          ListsPaymentScreen(
                            description:
                                homeController.menudetail.value.groupNameEN!,
                            stepBuild: '5/6',
                            title: homeController.getMenuTitle(),
                            onSelectedPayment:
                                (paymentType, cardIndex, uuid) async {
                              if (paymentType == "Other") {
                                // homeController.RxamountUSD.value =
                                //     await homeController.convertRate(
                                //         tempCcontroler
                                //             .tempCpackagedetail.value.amount!);
                                // tempCcontroler.rxTransID.value =
                                //     "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
                                // Get.to(PaymentVisaMasterCard(
                                //   function: () {
                                //     tempCcontroler
                                //         .paymentPackageVisaWithoutstoredCardUniqueID(
                                //       homeController.menudetail.value,
                                //     );
                                //   },
                                //   trainID: tempCcontroler.rxTransID.value,
                                //   description: tempCcontroler.rxNote.value,
                                //   amount: tempCcontroler.rxTotalAmount.value,
                                // ));
                              } else if (paymentType == 'MMONEY') {
                                navigateToConfirmScreen(paymentType);
                              } else {
                                homeController.RxamountUSD.value =
                                    await homeController.convertRate(
                                        tempCcontroler
                                            .tempCpackagedetail.value.amount!);
                                String? cvv =
                                    await showDynamicQRDialog(context, () {});
                                if (cvv != null &&
                                    cvv.isNotEmpty &&
                                    cvv.length >= 3) {
                                  navigateToConfirmScreen(
                                    paymentType,
                                    cvv,
                                    uuid,
                                  );
                                } else {
                                  DialogHelper.showErrorDialogNew(
                                    description: "please_input_cvv",
                                  );
                                }
                              }
                            },
                          ),
                        )
                      }
                    else
                      {
                        tempCcontroler.enableBottom.value = true,
                      }
                  },
                );
          },
          packagename: tempCcontroler.tempCpackagemodel[index].packageName!,
          code: "purchase",
          gb: false,
          package: true,
          discountBool: tempCcontroler.tempCpackagemodel[index].discount != 0
              ? true
              : false,
          discountText: '${tempCcontroler.tempCdetail.value.discount}% OFF',
          amount: tempCcontroler.tempCpackagemodel[index].packageValue!,
          type: "",
          detail: fn.format(tempCcontroler.tempCpackagemodel[index].amount),
          detail2: tempCcontroler.tempCpackagemodel[index].userDay.toString(),
        ),
      );
    }
  }

  void navigateToConfirmScreen(String paymentType,
      [String cvv = '', String storedCardUniqueID = '']) {
    Get.to(
      () => ReusableConfirmScreen(
        isUSD: paymentType != 'MMONEY',
        isEnabled: tempCcontroler.enableBottom,
        appbarTitle: "confirm_payment",
        function: () {
          tempCcontroler.enableBottom.value = false;
          if (paymentType == 'MMONEY') {
            tempCcontroler.paymentPackage(homeController.menudetail.value);
          } else {
            tempCcontroler.paymentPackageVisa(
              homeController.menudetail.value,
              storedCardUniqueID,
              cvv,
            );
          }
        },
        stepProcess: "6/6",
        stepTitle: "check_detail",
        fromAccountImage: userController.userProfilemodel.value.profileImg ??
            MyConstant.profile_default,
        fromAccountName:
            '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}',
        fromAccountNumber:
            userController.userProfilemodel.value.msisdn.toString(),
        toAccountImage: MyConstant.profile_default,
        toAccountName: tempCcontroler.tempCpackagedetail.value.packageName!,
        toAccountNumber:
            '${tempCcontroler.tempCpackagedetail.value.packageValue} | ${tempCcontroler.tempCpackagedetail.value.userDay} Day',
        amount: tempCcontroler.tempCpackagedetail.value.amount.toString(),
        fee: '0',
        note:
            'ດາຕ້າໃຊ້ໄດ້${tempCcontroler.tempCpackagedetail.value.packageValue} ແລະ ໄລຍະກຳນົດ ${tempCcontroler.tempCpackagedetail.value.userDay}ວັນ',
      ),
    );
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
