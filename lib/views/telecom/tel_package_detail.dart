import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/telecomsrv_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class TelPackageDetail extends StatefulWidget {
  final String msisdn;
  final int i;
  final String networkType;
  const TelPackageDetail(
      {super.key,
      required this.msisdn,
      required this.i,
      required this.networkType});

  @override
  State<TelPackageDetail> createState() => _TelPackageDetailState();
}

class _TelPackageDetailState extends State<TelPackageDetail> {
  final telecomsrv = Get.put(TelecomsrvController());
  bool isHidden = true;
  final fn = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    telecomsrv.getAirtime(widget.msisdn);
    telecomsrv.getPoint(widget.msisdn);
    telecomsrv.queryTelPackage(widget.msisdn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  color_f2f2,
                  Color(0xFFC4C6C9),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset(MyIcon.bg_tel_detail)),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Stack(
                      children: [
                        body(),
                        appBarBackBtn(),
                        appBarTitle(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget body() {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          simProfile(),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: TextFont(
              text: 'ລາຍການແພັກເກັດ',
            ),
          ),
          Expanded(child: package())
        ],
      ),
    );
  }

  Widget simProfile() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              decoration: ShapeDecoration(
                color: Color(0xFFFCDFE1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: SvgPicture.asset(
                MyIcon.ic_sim_color,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextFont(
                      text: widget.i == 0 ? 'ເບີຫລັກ' : 'ໝາຍເລກ',
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: 4),
                    if (widget.i > 0)
                      TextFont(
                        text: widget.i.toString().padLeft(2, '0'),
                        poppin: true,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    TextFont(
                      text: ' (${widget.networkType})',
                      color: color_777,
                      poppin: true,
                      fontSize: 9,
                    )
                  ],
                ),
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
                            ? maskMsisdnX(widget.msisdn)
                            : widget.msisdn,
                        poppin: true,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      SizedBox(width: 15),
                      Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility,
                        size: 4.w,
                        color: color_777,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 20),
        balance(),
      ],
    );
  }

  Widget package() {
    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 14),
      children: [
        ...telecomsrv.telQueryPackage.mapIndexed((i, e) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(bottom: 14),
            decoration: ShapeDecoration(
              color: e.isCurrentNormal! ? cr_red : color_fff,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
            child: Row(
              children: [
                SvgPicture.asset(e.isCurrentNormal!
                    ? MyIcon.ic_tel_internet
                    : MyIcon.ic_tel_internet_bw),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: TextFont(
                              text: e.isCurrentNormal! ? 'ກຳລັງນຳໃຊ້' : 'ລໍຖ້າ',
                              color: e.isCurrentNormal! ? color_fff : color_777,
                              fontSize: 10,
                            )),
                        Expanded(
                            flex: 2,
                            child: TextFont(
                              text: e.packageName!,
                              color: e.isCurrentNormal! ? color_fff : cr_4139,
                              fontSize: 9,
                              textAlign: TextAlign.end,
                              poppin: true,
                            ))
                      ],
                    ),
                    LinearPercentIndicator(
                      lineHeight: 5.3,
                      percent: e.doublePercent.toDouble() > 1
                          ? 1.0
                          : e.doublePercent.toDouble(),
                      progressColor: Color(0xffF0AF4C),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                      backgroundColor: Color(0xffFBEEE6),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFont(
                          text: '${e.qtaUsed}/${e.qtaValue}MB',
                          color: e.isCurrentNormal! ? color_fff : cr_4139,
                          fontSize: 9,
                          textAlign: TextAlign.start,
                          poppin: true,
                        )),
                        Expanded(
                            child: TextFont(
                          text: e.dateStamp!,
                          color: e.isCurrentNormal! ? color_fff : cr_4139,
                          fontSize: 9,
                          textAlign: TextAlign.end,
                          poppin: true,
                        ))
                      ],
                    ),
                  ],
                ))
              ],
            ),
          );
        })
      ],
    );
  }

  Widget balance() {
    return Column(
      children: [
        TextFont(
          text: 'ມູນຄ່າໂທ',
          fontSize: 11,
        ),
        TextFont(
          text: '₭ ${fn.format(int.parse(telecomsrv.airtime.value))}',
          poppin: true,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              pointCard(MyIcon.ic_coin, 'ຄະແນນສະສົມ', telecomsrv.point.value),
              SizedBox(
                width: 20,
              ),
              pointCard(MyIcon.ic_star, 'ໂບນັດພາຍໃນ',
                  telecomsrv.inHouseAirtime.value),
            ],
          ),
        )
      ],
    );
  }

  Widget pointCard(String icon, String title, String point) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 6.2.w,
            ),
            SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  text: title,
                  color: color_777,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
                TextFont(
                  text: fn.format(int.parse(point)),
                  poppin: true,
                  fontSize: 10.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: TextFont(
        text: 'ລາຍລະອຽດ',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget appBarBackBtn() {
    return Positioned(
        right: 0,
        child: InkWell(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              MyIcon.deleteX_round,
              width: 10.w,
              height: 10.w,
            )));
  }
}
