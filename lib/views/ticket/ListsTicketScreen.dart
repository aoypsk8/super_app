import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/ticket_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/ticket/TicketHistoryScreen.dart';
import 'package:super_app/views/ticket/TicketPaymentScreen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class ListsTicketScreen extends StatefulWidget {
  const ListsTicketScreen({super.key});

  @override
  State<ListsTicketScreen> createState() => _ListsTicketScreenState();
}

class _ListsTicketScreenState extends State<ListsTicketScreen> {
  final userController = Get.find<UserController>();
  final homeController = Get.find<HomeController>();
  final ticketController = Get.put(TicketController());

  @override
  void initState() {
    userController.increasepage();
    ticketController.fetchTicketLists();
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
        appBar: BuildAppBar(
          title: homeController.menutitle.value,
          hasIcon: true,
          onIconTap: () {
            Get.to(() => const TicketHistoryScreen());
          },
          customIcon: Container(
            decoration: BoxDecoration(
              color: color_f4f4,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Iconsax.lamp,
                color: cr_ef33,
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFont(
                    text: 'lastest_event',
                    fontWeight: FontWeight.w500,
                    color: cr_2929,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AnimationLimiter(
                  child: AlignedGridView.count(
                    itemCount: ticketController.ticketLists.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 16,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 800),
                        columnCount: 2,
                        child: ScaleAnimation(
                          scale: 0.5,
                          child: FadeInAnimation(child: buildTicket(index)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTicket(int index) {
    return InkWell(
      onTap: () {
        ticketController.ticketDetail.value =
            ticketController.ticketLists[index];
        Get.to(() => const TicketPaymentScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 230.sp,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: cr_red,
                    ),
                  ),
                  imageUrl: ticketController.ticketLists[index].logo.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextFont(
              text: ticketController.ticketLists[index].title.toString(),
              maxLines: 2,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.access_time,
                  size: 12.sp,
                  color: cr_7070,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: TextFont(
                    text: ticketController.ticketLists[index].dateEvent
                        .toString(),
                    maxLines: 2,
                    fontSize: 10,
                    color: cr_2929,
                  ),
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
                Expanded(
                  child: TextFont(
                    text:
                        ticketController.ticketLists[index].location.toString(),
                    maxLines: 2,
                    fontSize: 10,
                    color: cr_2929,
                    noto: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListProvider(int index) {
    return InkWell(
      onTap: () {
        // tempBcontroler.tempBdetail.value = tempBcontroler.tampBmodel[index];
        // Get.to(() => const VertifyAccountTempBScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: color_fff,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 30.h,
              // color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: cr_red,
                    ),
                  ),
                  imageUrl: ticketController.ticketLists[index].logo.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFont(
                          text: ticketController.ticketLists[index].description
                              .toString(),
                          fontWeight: FontWeight.w700,
                          maxLines: 5,
                          noto: true,
                        ),
                        TextFont(
                          text: ticketController.ticketLists[index].price
                              .toString(),
                          fontSize: 8,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
