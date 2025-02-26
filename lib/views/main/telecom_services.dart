import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
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
  bool isHidden = true;
  String msisdn = '2055515155';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PullRefresh(
        refreshController: refreshController,
        onRefresh: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [dashboard()],
        ),
      ),
    );
  }

  Widget dashboard() {
    return Padding(
      padding: EdgeInsets.only(top: 14, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(
              text: 'ຈຳນວນເບີທີ່ຜູກ',
              color: cr_7070,
              fontWeight: FontWeight.w500),
          card()
        ],
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
                            text: isHidden ? maskMsisdnX(msisdn) : msisdn,
                            poppin: true,
                            fontWeight: FontWeight.w400,
                            color: color_fff,
                            fontSize: 11,
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.visibility_off,
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
                      text: '(Prepaid)',
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
                    text: '₭ 10,000,000',
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
      percent: 0.7,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFont(
            text: '2512',
            poppin: true,
            color: color_fff,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          TextFont(
            text: '/5024 MB',
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
                  text: 'Package Social 518',
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
                    SizedBox(width: 10),
                    TextFont(
                      text: '28/02/2025 23:59',
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
