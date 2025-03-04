import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:super_app/controllers/telecomsrv_controller.dart';
import 'package:super_app/models/telecomsrv_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/pull_refresh.dart';
import 'package:super_app/widget/textfont.dart';

class TelecomServices extends StatefulWidget {
  const TelecomServices({super.key});

  @override
  State<TelecomServices> createState() => _TelecomServicesState();
}

class _TelecomServicesState extends State<TelecomServices> {
  RefreshController refreshController = RefreshController();
  final telecomsrv = Get.put(TelecomsrvController());
  final fn = NumberFormat("#,###", "en_US");
  bool isHidden = true;

  refresh() async {
    await telecomsrv.getAirtime();
    await telecomsrv.getNetworktype();
    await telecomsrv.getPackage();
    await telecomsrv.phoneList();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SlidingUpPanel(
          renderPanelSheet: false,
          panel: floatingPanel(),
          controller: telecomsrv.panelController,
          maxHeight: Get.height / 2,
          minHeight: 0.0,
          backdropEnabled: true,
          body: Scaffold(
            body: PullRefresh(
              refreshController: refreshController,
              onRefresh: () => refresh(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [dashboard()],
              ),
            ),
          ),
        ));
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
            child: phoneCard(i, e, true, 8),
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
      physics: NeverScrollableScrollPhysics(),
      children: [
        ...telecomsrv.phoneListModel
            .skip(1)
            .take(2)
            .mapIndexed((i, e) => phoneCard(i, e, false, 12)),
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

  Widget phoneCard(int i, PhoneListModel e, bool main, double radius) {
    return InkWell(
      onTap: () {},
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
            Icon(
              Icons.chevron_right_rounded,
              size: 7.w,
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
    return Flex(
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
                                ? maskMsisdnX(telecomsrv
                                        .phoneListModel.isNotEmpty
                                    ? telecomsrv.phoneListModel[0].phoneNumber!
                                    : telecomsrv.msisdn.value)
                                : telecomsrv.phoneListModel.isNotEmpty
                                    ? telecomsrv.phoneListModel[0].phoneNumber!
                                    : telecomsrv.msisdn.value,
                            poppin: true,
                            fontWeight: FontWeight.w400,
                            color: color_fff,
                            fontSize: 11,
                          ),
                          SizedBox(width: 15),
                          Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
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
                    text: '₭ ${fn.format(int.parse(telecomsrv.airtime.value))}',
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
            TextFont(
              text: 'ກຳລັງນຳໃຊ້',
              fontSize: 9,
              color: color_ddd,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset(MyIcon.ic_internet_round),
            SizedBox(width: 12),
            Column(
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
                    TextFont(
                      text: telecomsrv.inusePackageModel.value.dateStamp ??
                          'available',
                      color: color_fff,
                      fontSize: 9,
                      poppin: true,
                    )
                  ],
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
