import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
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
            child: Flex(
              direction: Axis.horizontal,
              children: [Expanded(flex: 1, child: cardPackage()), Text('data')],
            ),
          ),
        ],
      ),
    );
  }

  Widget circleChart() {
    return LinearPercentIndicator(
        animation: true,
        animationDuration: 300,
        linearStrokeCap: LinearStrokeCap.roundAll,
        width: 40.w,
        lineHeight: 3.6,
        percent: 0.4,
        padding: EdgeInsets.all(3),
        backgroundColor: Color(0xffF8E5CA),
        // progressColor: Color(0xffF14D58),
        linearGradient: LinearGradient(
            colors: [Color(0xffED1C29), Color(0xffC7757A), Color(0xffB08C8F)],
            stops: [0.25, 0.8, 0.9]));
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
