// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names, unnecessary_null_comparison
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/qr_controller.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/scanqr/qr_scanner.dart';
import 'package:super_app/views/web/openWebView.dart';
import 'package:super_app/widget/button.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/pull_refresh.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class HomeRecommendScreen extends StatefulWidget {
  const HomeRecommendScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeRecommendScreenState createState() => _HomeRecommendScreenState();
}

class _HomeRecommendScreenState extends State<HomeRecommendScreen> {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  // final paymentController = Get.put(PaymentController());
  final qrController = Get.put(QrController());
  // final controller = Get.put(TempAController());
  RefreshController refreshController = RefreshController();
  final CarouselSliderController carouselController =
      CarouselSliderController();

  bool showAmount = false;
  int _current = 0;
  int _currentDropping = 0;
  int _currentLoveit = 0;

  final box = GetStorage();
  File? _backgroundImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // chkShowAlert();
      setState(() {
        if (homeController.rxBgCard.value == '') {
          _backgroundImage = null;
        } else {
          _backgroundImage = File(homeController.rxBgCard.value);
        }
      });
    });
  }

  List<String> imageUrls = [
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
    "https://blog.ipleaders.in/wp-content/uploads/2021/10/Advertisement-Media.jpg",
  ];
  List<String> imageUrlsDropping = [
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
  ];
  List<String> loveItUrls = [
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
    "https://matrixmarketinggroup.com/wp-content/uploads/2021/12/Mcdonalds-Food-Ad.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: cr_fbf7,
        floatingActionButton: SizedBox(
          width: 14.w,
          height: 14.w,
          child: FloatingActionButton(
            onPressed: () {
              // qrController.clear();
              // if (!userController.isCheckToken.value) {
              //   userController.isCheckToken.value = true;
              //   userController.checktoken(name: 'menu').then((value) async {
              //     if (userController.isLogin.value) {
              //       final result = await Get.to(() => QRScannerScreen());
              //       if (result != null) {
              //         qrController.verifyQR(result);
              //       }
              //     }
              //   });
              //   userController.isCheckToken.value = false;
              // }
            },
            backgroundColor: Theme.of(context).primaryColor,
            shape: CircleBorder(),
            child: Icon(
              Iconsax.scan,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
          ),
        ),
        body: PullRefresh(
          refreshController: refreshController,
          onRefresh: () {
            homeController.fetchServicesmMenu();
            refreshController.refreshCompleted();
          },
          child: SingleChildScrollView(
            child: homeController.menuModel.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              PrimaryCardComponent(),
                              Container(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Container(
                                      child: AlignedGridView.count(
                                        itemCount: homeController.menuModel
                                                .first.menulists!.length +
                                            1,
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 17,
                                        crossAxisSpacing: 20,
                                        shrinkWrap: true,
                                        primary: false,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index ==
                                              homeController.menuModel.first
                                                  .menulists!.length) {
                                            return InkWell(
                                              onTap: () async {},
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 6),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      MyIcon.ic_more,
                                                      width: 5.5.w,
                                                      height: 8.5.w,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  TextFont(
                                                    text: 'more',
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w400,
                                                    maxLines: 2,
                                                    color: cr_4139,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          var result = homeController.menuModel
                                              .first.menulists![index];
                                          String? url = result.logo;
                                          if (url != null &&
                                              homeController
                                                  .TPlus_theme.value) {
                                            url = url.replaceFirst(
                                                "Icons/", "Icons/y");
                                          }

                                          return InkWell(
                                            onTap: () async {
                                              userController
                                                  .isRenewToken.value = true;
                                              bool isValidToken =
                                                  await userController
                                                      .checktokenSuperApp();
                                              if (isValidToken) {
                                                if (result.template != '/') {
                                                  homeController
                                                          .menutitle.value =
                                                      result.groupNameEN!;
                                                  homeController.menudetail
                                                      .value = result;
                                                  if (result.template ==
                                                      "webview") {
                                                    Get.to(OpenWebView(
                                                        url: homeController
                                                            .menudetail
                                                            .value
                                                            .url
                                                            .toString()));
                                                  } else {
                                                    Get.toNamed(
                                                        '/${result.template}');
                                                  }
                                                } else {
                                                  DialogHelper
                                                      .showErrorDialogNew(
                                                          description:
                                                              'Not available');
                                                }
                                              }
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                SizedBox(height: 6),
                                                SvgPicture.network(
                                                  url!,
                                                  placeholderBuilder:
                                                      (BuildContext context) =>
                                                          Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  ),
                                                  width: 8.5.w,
                                                  height: 8.5.w,
                                                ),
                                                SizedBox(height: 10),
                                                TextFont(
                                                  text: getLocalizedGroupName(
                                                      result),
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.w400,
                                                  maxLines: 2,
                                                  color: cr_4139,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // PrimaryButton(
                              //     title: 'fetchServicesmMenu',
                              //     onPressed: () {
                              //       homeController.fetchServicesmMenu();
                              //     }),
                              // PrimaryButton(
                              //     title: 'OTP TESTING',
                              //     onPressed: () {
                              //       Get.toNamed('/otpTransfer');
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'Get Payment List',
                              //     onPressed: () {
                              //       Get.to(ListsPaymentScreen(
                              //         description: 'select_payment',
                              //         stepBuild: '4/5',
                              //         title: homeController.getMenuTitle(),
                              //         onSelectedPayment: () {
                              //           paymentController
                              //               .reqCashOut(
                              //                   transID: controller.rxtransid.value,
                              //                   amount: controller.rxPaymentAmount.value,
                              //                   toAcc: controller.rxaccnumber.value,
                              //                   chanel: homeController
                              //                       .menudetail.value.groupNameEN,
                              //                   provider:
                              //                       controller.tempAdetail.value.code,
                              //                   remark: controller.rxNote.value)
                              //               .then(
                              //                 (value) => {
                              //                   if (value)
                              //                     {Get.to(() => ConfirmTempAScreen())}
                              //                 },
                              //               );
                              //           return Container();
                              //         },
                              //       ));
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'Visa Master Card',
                              //     onPressed: () {
                              //       Get.toNamed('/visaMasterCard');
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'OTP Email',
                              //     onPressed: () {
                              //       Get.toNamed('/otpTransferEmail');
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'Transfer',
                              //     onPressed: () {
                              //       Get.toNamed('/transfer');
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'Cash Out',
                              //     onPressed: () {
                              //       Get.toNamed('/cashOut');
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'finance',
                              //     onPressed: () {
                              //       Get.toNamed('/finance');
                              //     }),
                              // const SizedBox(height: 20),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'tempA',
                              //     onPressed: () async {
                              //       Get.toNamed('/templateA');

                              // Get.to(ReusableResultScreen(
                              //     fromAccountImage: 'https://mmoney.la/AppLite/PartnerIcon/electricLogo.png',
                              //     fromAccountName: 'fromAccountName',
                              //     fromAccountNumber: 'fromAccountNumber',
                              //     toAccountImage: 'https://mmoney.la/AppLite/PartnerIcon/electricLogo.png',
                              //     toAccountName: 'toAccountName',
                              //     toAccountNumber: 'toAccountNumber',
                              //     toTitleProvider: 'toTitleProvider',
                              //     amount: '1000',
                              //     fee: '0',
                              //     transactionId: 'transactionId',
                              //     note: 'note',
                              //     timestamp: '2025-01-29 09:47:10'));

                              // Get.to(ScreenshotPage());
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'XJaidee',
                              //     onPressed: () {
                              //       Get.toNamed('/xjaidee');
                              //     }),
                              // const SizedBox(height: 20),
                              // PrimaryButton(
                              //     title: 'X-Proof',
                              //     onPressed: () {
                              //       Get.toNamed('/proof');
                              //     }),
                            ],
                          ),
                        ),
                      ),
                      // PrimaryButton(
                      //     title: 'XJaidee',
                      //     onPressed: () {
                      //       Get.toNamed('/xjaidee');
                      //     }),
                      const SizedBox(height: 20),
                      Container(
                        color: color_fff,
                        width: Get.width,
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFont(
                                text: "Deal for you, ມາລີນາ!",
                                color: cr_4139,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                noto: true,
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 2,
                                endIndent: 310,
                              ),
                              const SizedBox(height: 20),
                              buildRecomend(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        color: color_fff,
                        width: Get.width,
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFont(
                                text: "Dropping Like It's Hot!",
                                color: cr_4139,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 2,
                                endIndent: 310,
                              ),
                              const SizedBox(height: 20),
                              buildDropping(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        color: color_fff,
                        width: Get.width,
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFont(
                                text: "Dropping Like It's Hot!",
                                color: cr_4139,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 2,
                                endIndent: 310,
                              ),
                              const SizedBox(height: 20),
                              buildLoveit(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Lottie.asset(
                        MyIcon.animation_load,
                        repeat: true,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget PrimaryCardComponent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: _backgroundImage == null
          ? BoxDecoration(
              color: color_fff,
              image: DecorationImage(
                image: AssetImage(MyIcon.deault_theme),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20))
          : BoxDecoration(
              color: color_fff,
              image: DecorationImage(
                image: FileImage(_backgroundImage!),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.sp),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: color_fff,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFont(
                text: "Your balance",
                color: Colors.black,
                poppin: true,
                fontSize: 7.5,
              ),
            ),
            SizedBox(height: 5.sp),
            Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    )
                        .animate(
                            onPlay: (controller) =>
                                controller.repeat()) // 🔄 Loop animation
                        // .effect(duration: 100.ms) // Small padding to total duration
                        .effect(delay: 1000.ms, duration: 4000.ms)
                        .shimmer(blendMode: BlendMode.srcOver),
                  ),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cr_black.withOpacity(0.1),
                        border: Border.all(
                            color: color_fff.withOpacity(0.7), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Divider(
                          //   color: Theme.of(context).primaryColor,
                          //   thickness: 3,
                          //   height: 3,
                          // )
                          //     .animate(onPlay: (controller) => controller.repeat())
                          //     .effect(duration: 10.ms)
                          //     .effect(delay: 10.ms, duration: 4000.ms)
                          //     .shimmer(blendMode: BlendMode.dstIn),
                          AnimatedBalanceWidget(
                              balance: int.parse(
                                  userController.mainBalance.value.toString())),
                          Divider(
                            color: Theme.of(context).primaryColor,
                            thickness: 3,
                            height: 3,
                          )
                              .animate(
                                  onPlay: (controller) => controller.repeat())
                              .effect(duration: 10.ms)
                              .effect(delay: 10.ms, duration: 4000.ms)
                              .shimmer(blendMode: BlendMode.dstIn),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildRecomend() {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imageUrls.map<Widget>((entry) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(entry),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Indicator for the carousel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageUrls.length, (index) {
              return _current == index
                  ? Container(
                      width: 6.0.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cr_ecec,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Container buildDropping() {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              initialPage: _currentDropping + 1,
              reverse: false,
              autoPlay: true,
              enlargeCenterPage: false,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 0.45,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentDropping = index;
                });
              },
            ),
            items: imageUrlsDropping.map<Widget>((entry) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(entry),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Indicator for the carousel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageUrlsDropping.length, (index) {
              return _currentDropping == index
                  ? Container(
                      width: 6.0.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cr_ecec,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Container buildLoveit() {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.45,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentLoveit = index;
                });
              },
            ),
            items: List.generate((loveItUrls.length / 4).ceil(), (index) {
              int start = index * 4;
              int end = start + 4;
              List<String> sublist = loveItUrls.sublist(
                  start, end > loveItUrls.length ? loveItUrls.length : end);
              return GridView.builder(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: sublist.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(sublist[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((loveItUrls.length / 4).ceil(), (index) {
              return _currentLoveit == index
                  ? Container(
                      width: 6.0.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      margin: const EdgeInsets.only(left: 6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cr_ecec,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}

String getLocalizedGroupName(result) {
  switch (Get.locale?.languageCode) {
    case 'en':
      return result.groupNameEN ?? '';
    case 'lo':
      return result.groupNameLA ?? '';
    case 'zh':
      return result.groupNameCH ?? '';
    case 'vi':
      return result.groupNameVT ?? '';
    default:
      return result.groupNameEN ?? '';
  }
}

class AnimatedBalanceWidget extends StatefulWidget {
  final int balance;

  AnimatedBalanceWidget({required this.balance});

  @override
  _AnimatedBalanceWidgetState createState() => _AnimatedBalanceWidgetState();
}

class _AnimatedBalanceWidgetState extends State<AnimatedBalanceWidget> {
  bool showAmount = false; // Toggle state
  int animatedValue = 0; // Holds the animated balance value
  final NumberFormat fn = NumberFormat("#,###"); // Currency formatter
  bool _isDisposed = false; // ✅ Track if widget is disposed

  @override
  void dispose() {
    _isDisposed = true; // ✅ Mark widget as disposed
    super.dispose();
  }

  void toggleBalance() {
    setState(() {
      showAmount = !showAmount;
      if (showAmount) {
        animatedValue = 0;
        animateBalance();
      }
    });
  }

  void animateBalance() async {
    for (int i = 0; i <= widget.balance; i += (widget.balance ~/ 30)) {
      await Future.delayed(Duration(milliseconds: 10)); // Adjust speed

      if (!mounted || _isDisposed)
        return; // ✅ Prevent `setState()` after dispose

      setState(() {
        animatedValue = i;
      });
    }

    if (!mounted || _isDisposed) return; // ✅ Prevent `setState()` after dispose

    setState(() {
      animatedValue = widget.balance; // Ensure it lands on final value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              showAmount
                  ? fn.format(animatedValue)
                  : "********", // Show animation or mask,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.5,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "₭",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.5,
              ),
            ),
          ],
        ),

        // ✅ Toggle Button for Show/Hide Balance
        GestureDetector(
          onTap: toggleBalance, // Call toggle function
          child: Icon(
            showAmount ? Iconsax.eye : Iconsax.eye_slash,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
