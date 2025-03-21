import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/history_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:intl/intl.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

final UserController userController = Get.find();
final RefreshController _refreshController = RefreshController();

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    userController.fetchHistory();
  }

  void _onRefresh() async {
    await userController.fetchHistory();
    _refreshController.refreshCompleted();
  }

  String convertDateFormat(String date) {
    List<String> parts = date.split('-');
    return "${parts[1]}/${parts[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'history'),
      body: Container(
        decoration: BoxDecoration(color: color_fff, boxShadow: []),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(text: 'all_transaction'),
              Obx(() {
                return Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: () {
                      _refreshController.refreshCompleted();
                      userController.fetchHistory();
                    },
                    header: WaterDropHeader(
                        complete: TextFont(text: 'loading_complete')),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: userController.groupedHistory.keys.length,
                      itemBuilder: (context, index) {
                        String yearMonth =
                            userController.groupedHistory.keys.toList()[index];
                        List<HistoryModel> transactions =
                            userController.groupedHistory[yearMonth]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextFont(
                                text: convertDateFormat(yearMonth), // YYYY-MM
                                poppin: true,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            // Transactions List
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, subIndex) {
                                final data = transactions[subIndex];
                                return InkWell(
                                  onTap: () {
                                    userController
                                        .fetchHistoryDetail(data.tranID);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: color_f4f4,
                                      border: Border.all(
                                          color: color_f4f4, width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        buildDetail(data),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            TextFont(
                                              text:
                                                  '${data.type == 'OUT' ? '-' : '+'}${fn.format(data.amount is int ? data.amount.toDouble() : data.amount)}',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: data.type == 'OUT'
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.green,
                                              poppin: true,
                                            ),
                                            TextFont(
                                              text: '.00LAK',
                                              fontWeight: FontWeight.w500,
                                              color: data.type == 'OUT'
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.green,
                                              poppin: true,
                                              fontSize: 11,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row buildDetail(HistoryModel data) {
    return Row(
      children: [
        SizedBox(
          height: 35.sp,
          width: 35.sp,
          child: getIcon(data),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(text: data.channel ?? '', fontSize: 14),
              TextFont(
                  text: data.tranID ?? '',
                  poppin: true,
                  fontSize: 10,
                  color: color_777),
              if (data.remark != null)
                TextFont(
                    text: data.remark ?? '',
                    poppin: true,
                    color: color_777,
                    fontSize: 10),
              TextFont(
                text: DateFormat('dd MMM, yyyy HH:mm')
                        .format(DateTime.parse(data.created!)) ??
                    '',
                poppin: true,
                color: color_777,
                fontSize: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getIcon(HistoryModel data) {
    // Debugging Output
    print("Channel (Processed): '${data.channel?.trim().toUpperCase()}'");
    switch (data.channel?.trim().toUpperCase()) {
      case 'MOBILE':
        return SvgPicture.asset(MyIcon.ic_telecom);
      case 'TRANSFER':
        return SvgPicture.asset(
            data.type == "OUT" ? MyIcon.ic_cashout : MyIcon.ic_cashout);
      case 'QR':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'LEASING':
        return SvgPicture.asset(MyIcon.ic_leasing);
      case 'WATER':
        return SvgPicture.asset(MyIcon.ic_water);
      case 'ELECTRIC':
        return SvgPicture.asset(MyIcon.ic_electric);
      case 'BANK':
        return SvgPicture.asset(MyIcon.ic_bank);
      case 'CASHBACK':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'PROMOTION':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'SCNLOTTO':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'FEECHARGE':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'LABNET':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'CASH-IN':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'PAYROLL':
        return SvgPicture.asset(MyIcon.ic_cashout);
      case 'WETV':
        return SvgPicture.asset(MyIcon.ic_cashout);
      default:
        return SvgPicture.asset(MyIcon.ic_more);
    }
  }
}
