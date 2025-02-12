// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/ticket_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({super.key});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  final userController = Get.find<UserController>();
  final homeController = Get.find<HomeController>();
  final ticketController = Get.put(TicketController());

  @override
  void initState() {
    userController.increasepage();
    ticketController.fetchTicketHistory();
    super.initState();
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
        appBar: BuildAppBar(title: "history"),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFont(
                    text: 'lastest_order',
                    fontWeight: FontWeight.w500,
                    color: cr_2929,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: ticketController.historyLists.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 550),
                        child: SlideAnimation(
                          verticalOffset: 1,
                          child: FlipAnimation(
                            child: buildListProvider(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListProvider(int index) {
    return Container(
      decoration: BoxDecoration(
        color: color_f4f4,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          Clipboard.setData(
            ClipboardData(text: '${ticketController.historyLists[index].code}'),
          ).then((_) {
            Get.snackbar(
                'Copied!', 'code: ${ticketController.historyLists[index].code}',
                snackPosition: SnackPosition.BOTTOM);
          });
        },
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: cr_red,
                    ),
                  ),
                  imageUrl:
                      ticketController.historyLists[index].logo.toString(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text:
                          ticketController.historyLists[index].title.toString(),
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                      color: cr_2929,
                    ),
                    TextFont(
                      text:
                          ticketController.historyLists[index].code.toString(),
                      fontWeight: FontWeight.w700,
                      color: color_ed1,
                      noto: true,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.sp,
                          color: cr_7070,
                        ),
                        const SizedBox(width: 3),
                        TextFont(
                          text: DateFormat('dd MMM, yyyy HH:mm').format(
                            DateTime.parse(
                              ticketController.historyLists[index].created
                                  .toString()
                                  .replaceAll('/', '-'),
                            ),
                          ),
                          fontSize: 10,
                          poppin: true,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12.sp,
                          color: cr_7070,
                        ),
                        const SizedBox(width: 3),
                        TextFont(
                          text: ticketController.historyLists[index].location
                              .toString(),
                          fontSize: 10,
                          poppin: true,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFont(
                          text: NumberFormat('#,###').format(double.parse(
                              ticketController.historyLists[index].price
                                  .toString())),
                          fontWeight: FontWeight.w500,
                          color: cr_b326,
                          poppin: true,
                          fontSize: 15,
                        ),
                        SizedBox(width: 5),
                        TextFont(
                          text: 'kip',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: cr_b326,
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
    );
  }
}
