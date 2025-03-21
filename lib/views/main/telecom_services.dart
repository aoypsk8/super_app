import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/telecomsrv_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/telecomsrv_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/service/service.dart';
import 'package:super_app/views/telecom/tel_package_detail.dart';
import 'package:super_app/views/web/openWebView.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/pull_refresh.dart';
import 'package:super_app/widget/textfont.dart';

import '../telecom/add_phone.dart';

class TelecomServices extends StatefulWidget {
  const TelecomServices({super.key});

  @override
  State<TelecomServices> createState() => _TelecomServicesState();
}

class _TelecomServicesState extends State<TelecomServices> {
  RefreshController refreshController = RefreshController();
  final telecomsrv = Get.put(TelecomsrvController());
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  final fn = NumberFormat("#,###", "en_US");
  bool isHidden = true;
  final storage = GetStorage();

  refresh() async {
    await telecomsrv.getAirtime(await storage.read('msisdn'));
    await telecomsrv.getNetworktype();
    await telecomsrv.queryTelPackage(await storage.read('msisdn'));
    await telecomsrv.phoneList();
    // await telecomsrv.fetchMainMenu();
    await homeController.fetchServicesmMenu(userController.rxMsisdn.value);
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Scaffold(
              body: PullRefresh(
                refreshController: refreshController,
                onRefresh: () => refresh(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dashboard(),
                      SizedBox(height: 8),
                      menu(),
                      // SizedBox(height: 8),
                      // menuVas()
                    ],
                  ),
                ),
              ),
            ),
            slideUpPhone()
          ],
        ));
  }

  Widget slideUpPhone() {
    return SlidingUpPanel(
        renderPanelSheet: false,
        panel: floatingPanel(),
        controller: telecomsrv.panelController,
        maxHeight: Get.height / 2,
        minHeight: 0.0,
        backdropEnabled: true);
  }

  Widget menu() {
    return Container(
      color: color_fff,
      child: homeController.menuModel.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFont(
                        text: 'ບໍລິການໂທລະຄົມ',
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        width: 10.w,
                        height: 3,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFEF3328),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  homeController.menuModel.skip(1).isNotEmpty
                      ? menuIcon()
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Lottie.asset(
                              MyIcon.animation_load,
                              repeat: true,
                            ),
                          ),
                        ),
                ],
              ),
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
    );
  }

  Widget menuVas() {
    return Container(
      color: color_fff,
      child: telecomsrv.mainMenuInfo.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFont(
                        text: 'ບໍລິການເສີມ',
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        width: 10.w,
                        height: 3,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFEF3328),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  menuVasIcon()
                ],
              ),
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
    );
  }

  Widget menuIcon() {
    return AlignedGridView.count(
      itemCount: homeController.menuModel.skip(1).first.menulists!.length,
      crossAxisCount: 4,
      mainAxisSpacing: 17,
      crossAxisSpacing: 20,
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0),
      itemBuilder: (BuildContext context, int index) {
        // var result = homeController.menuModel.skip(1).first.menulists![index];
        var result = homeController.menuModel.skip(1).first.menulists![index];
        String? url = result.logo;
        if (url != null && homeController.TPlus_theme.value) {
          url = url.replaceFirst("icons/", "icons/y");
        } else {
          url = url!.replaceFirst("icons/", "icons/");
        }

        return InkWell(
          onTap: () async {
            await homeController.clear();
            if (!userController.isCheckToken.value) {
              bool isValidToken = await userController.checktokenSuperApp();
              if (isValidToken) {
                if (result.template != '/') {
                  homeController.menutitle.value = result.groupNameEN!;
                  homeController.menudetail.value = result;
                  if (result.template == "webview") {
                    Get.to(
                      OpenWebView(
                          url: homeController.menudetail.value.url.toString()),
                    );
                  } else {
                    Get.toNamed('/${result.template}');
                  }
                } else {
                  DialogHelper.showErrorDialogNew(
                    description: 'Not available',
                  );
                }
              }
            }
            // if (!userController.isCheckToken.value) {
            //   userController.isCheckToken.value = true;
            //   userController.checktoken(name: 'menu').then((value) {
            //     if (userController.isLogin.value) {
            //       if (result.template != '/') {
            //         homeController.menutitle.value = result.groupNameEN!;
            //         homeController.menudetail.value = result;
            //         if (result.template == "webview") {
            //           Get.to(
            //             OpenWebView(
            //                 url:
            //                     homeController.menudetail.value.url.toString()),
            //           );
            //         } else {
            //           Get.toNamed('/${result.template}');
            //         }
            //       } else {
            //         DialogHelper.showErrorDialogNew(
            //           description: 'Not available',
            //         );
            //       }
            //     }
            //   });
            //   userController.isCheckToken.value = false;
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 6),
              SvgPicture.network(
                url,
                placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(5.0),
                  child: const CircularProgressIndicator(),
                ),
                width: 8.5.w,
                height: 8.5.w,
              ),
              SizedBox(height: 10),
              TextFont(
                text: getLocalizedGroupName(result),
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
    );
  }

  Widget menuVasIcon() {
    return AlignedGridView.count(
      itemCount: telecomsrv.mainMenuInfo.length,
      crossAxisCount: 4,
      mainAxisSpacing: 17,
      crossAxisSpacing: 20,
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var data = telecomsrv.mainMenuInfo[index];

        return InkWell(
          onTap: () async {},
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 6),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: data.coverPage1x1!,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SvgPicture.asset(
                        MyIcon.ic_logo_x,
                        width: 60,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 64,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFont(
                text: data.mainMenuKey!,
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
    );
  }

  Widget floatingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
      ),
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        child: Column(
          children: [
            Container(
              width: 36.w,
              margin: EdgeInsets.only(top: 6),
              child: Divider(
                color: cr_d9d9,
                thickness: 3,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFont(
                    text: 'ລາຍການເບີຂອງທ່ານ',
                    fontSize: 11,
                  ),
                  InkWell(
                    onTap: () => Get.to(
                      () => AddPhonePage(),
                      transition:
                          Transition.downToUp, // Moves page from bottom to top
                      duration: Duration(
                          milliseconds: 300), // Adjust speed of animation
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: color_ec1c,
                        ),
                        TextFont(
                          text: 'ເພິ່ມເບີ',
                          color: cr_red,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: phoneLists())
          ],
        ),
      ),
    );
  }

  Widget phoneLists() {
    return ListView(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      children: [
        ...telecomsrv.phoneListModel.mapIndexed(
          (i, e) => Slidable(
            enabled: i == 0 ? false : true,
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              extentRatio: 0.2,
              children: [
                if (i != 0)
                  CustomSlidableAction(
                    onPressed: (i) => DialogHelper.dialogRecurringConfirm(
                        title: 'ຈະລົບແທ້ຫວາ',
                        description:
                            'ເບີ ${e.phoneNumber} ລົບໄປກໍບໍ່ຊ່ວຍໃຫ້ລືມ,ເຈັບສູ໊ດດດດດ ',
                        okTitle: 'ຕັດໃຈໄດ້ແລ້ວ',
                        onOk: () {
                          Get.back();
                          telecomsrv.delPhone(e.phoneNumber!);
                        }),
                    padding: EdgeInsets.only(left: 10, top: 0, bottom: 11),
                    child: SizedBox.expand(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 21),
                        decoration: BoxDecoration(
                          color: cr_8b85,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SvgPicture.asset(
                          MyIcon.ic_trash,
                          color: color_fff,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            child: phoneCard(i, e, true, 8, true),
          ),
        )
      ],
    );
  }

  Widget dashboard() {
    return Container(
      padding: EdgeInsets.only(top: 14, left: 15, right: 15, bottom: 18),
      color: color_fff,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(
              text: 'ຈຳນວນເບີທີ່ຜູກ',
              color: cr_7070,
              fontWeight: FontWeight.w500),
          card(),
          SizedBox(height: 16),
          phoneList()
        ],
      ),
    );
  }

  Widget phoneList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 0),
      children: [
        ...telecomsrv.phoneListModel
            .skip(1)
            .take(2)
            .mapIndexed((i, e) => phoneCard(i, e, false, 12, false)),
        btnPhone()
      ],
    );
  }

  Widget btnPhone() {
    return InkWell(
      onTap: () => telecomsrv.panelController.open(),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: ShapeDecoration(
              color: Color(0xFFEFF6FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: TextFont(
              text: 'ເບິ່ງທັງໝົດ ${telecomsrv.phoneListModel.length} ເບີ',
              color: cr_63eb,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneCard(
      int i, PhoneListModel e, bool main, double radius, bool all) {
    return InkWell(
      onTap: () => Get.to(() => TelPackageDetail(
            msisdn: e.phoneNumber!,
            i: i + 2,
            networkType: e.networkType!,
          )),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 12),
        margin: EdgeInsets.only(bottom: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1, color: main && i == 0 ? cr_red : color_ddd),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  main && i == 0 ? MyIcon.ic_sim_color : MyIcon.ic_sim_bw,
                  width: 8.w,
                ),
                SizedBox(height: 3),
                TextFont(
                  text: e.networkType ?? '',
                  color: color_blackE72,
                  poppin: true,
                  fontSize: 6,
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  child: Row(
                    children: [
                      TextFont(
                        text: isHidden
                            ? maskMsisdnX(
                                e.phoneNumber ?? telecomsrv.msisdn.value)
                            : e.phoneNumber ?? telecomsrv.msisdn.value,
                        poppin: true,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.5,
                        color: cr_4139,
                      ),
                      SizedBox(width: 15),
                      Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility,
                        size: 4.w,
                        color: color_777,
                      )
                    ],
                  ),
                ),
                main && i == 0
                    ? TextFont(
                        text: 'ເບີຫລັກ',
                        color: cr_red,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      )
                    : Row(
                        children: [
                          TextFont(
                            text: 'ຫມາຍເລກ ',
                            color: color_777,
                            fontSize: 10,
                          ),
                          TextFont(
                            text:
                                (i + (main ? 1 : 2)).toString().padLeft(2, '0'),
                            poppin: true,
                            color: color_777,
                            fontSize: 10,
                          )
                        ],
                      ),
              ],
            ),
            Spacer(),
            if (i == 0 && all)
              Icon(
                Icons.check_circle_rounded,
                size: 6.w,
                color: cr_red,
              ),
            if (!all)
              Icon(
                Icons.chevron_right_rounded,
                size: 6.5.w,
                color: color_777,
              )
          ],
        ),
      ),
    );
  }

  Widget card() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.9, 0.45),
          end: Alignment(0.90, -0.45),
          colors: [Color(0xFFEF3D49), Color(0xFFC1101B)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 7,
            offset: Offset(0, 1),
            spreadRadius: 0.50,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
              right: 0, bottom: 0, child: SvgPicture.asset(MyIcon.bg_circle)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(flex: 2, child: cardPackage()),
                      circleChart()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Divider(
                    color: cr_0e19,
                  ),
                ),
                cardSIM()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardSIM() {
    return InkWell(
      onTap: () => Get.to(() => TelPackageDetail(
            msisdn: telecomsrv.phoneListModel[0].phoneNumber!,
            i: 0,
            networkType: telecomsrv.phoneListModel[0].networkType!,
          )),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Row(
            children: [
              SvgPicture.asset(MyIcon.ic_sim_round),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        child: Row(
                          children: [
                            TextFont(
                              text: isHidden
                                  ? maskMsisdnX(
                                      telecomsrv.phoneListModel.isNotEmpty
                                          ? telecomsrv
                                              .phoneListModel[0].phoneNumber!
                                          : telecomsrv.msisdn.value)
                                  : telecomsrv.phoneListModel.isNotEmpty
                                      ? telecomsrv
                                          .phoneListModel[0].phoneNumber!
                                      : telecomsrv.msisdn.value,
                              poppin: true,
                              fontWeight: FontWeight.w400,
                              color: color_fff,
                              fontSize: 11,
                            ),
                            SizedBox(width: 15),
                            Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 4.w,
                              color: color_fff,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFont(
                        text: 'ເບີຫລັກ',
                        color: color_fff,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 6),
                      TextFont(
                        text:
                            '(${telecomsrv.phoneListModel.isNotEmpty ? telecomsrv.phoneListModel[0].networkType! : ''})',
                        fontSize: 8,
                        poppin: true,
                        color: color_fff,
                        fontWeight: FontWeight.w300,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFont(
                      text:
                          '₭ ${fn.format(int.parse(telecomsrv.mainAirtime.value))}',
                      poppin: true,
                      fontWeight: FontWeight.w600,
                      color: color_fff,
                      fontSize: 13,
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: color_fff,
                      size: 7.w,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget circleChart() {
    return CircularPercentIndicator(
      radius: 47,
      lineWidth: 7.0,
      animation: true,
      animationDuration: 300,
      percent: telecomsrv.inusePackageModel.value.doublePercent ?? 0.0,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFont(
            text: telecomsrv.inusePackageModel.value.qtaUsed ?? '0',
            poppin: true,
            color: color_fff,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          TextFont(
            text: '/${telecomsrv.inusePackageModel.value.qtaValue ?? '0'} MB',
            poppin: true,
            fontSize: 9,
            color: color_fff,
          ),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: cr_bc02,
      backgroundColor: cr_fbf7,
    );
  }

  Widget cardPackage() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 14),
              decoration: ShapeDecoration(
                color: cr_0e19,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
              ),
              child: TextFont(
                text: 'ແພັກເກັດປັດຈຸບັນ',
                fontSize: 9,
                color: color_fff,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFont(
                text: 'ກຳລັງນຳໃຊ້',
                fontSize: 9,
                color: color_ddd,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset(MyIcon.ic_internet_round),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFont(
                    text: telecomsrv.inusePackageModel.value.packageName ??
                        'available',
                    poppin: true,
                    fontWeight: FontWeight.w400,
                    color: color_fff,
                    fontSize: 10,
                  ),
                  Row(
                    children: [
                      TextFont(
                        text: 'ໄລຍະເວລາ',
                        color: color_fff,
                        fontSize: 9,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: TextFont(
                          text: telecomsrv.inusePackageModel.value.dateStamp ??
                              'available',
                          color: color_fff,
                          fontSize: 9,
                          poppin: true,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
