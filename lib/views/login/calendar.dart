import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/calendar_controller.dart';
import 'package:super_app/models/calendar_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CarlendarsController calendarController = Get.find();
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    // loadData();
  }

  // loadData() async {
  //   Future.delayed(Duration(microseconds: 1)).then((_) async {
  //     await calendarController.fetchCalendarMonthList(now.year.toString(), now.month.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BuildAppBar(title: 'calendar'),
      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    // color: color_1a1,
                    height: 20.h,
                    child: Image.asset(
                      'assets/images/calendar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: ShapeDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: OvalBorder(),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: color_fff,
                          size: 7.w,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    calendarHeader(),
                    SizedBox(height: 10),
                    calendarDayHeader(),
                    SizedBox(height: 10),
                    calendarDayBody(),
                    SizedBox(height: 10),
                    specialDayList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   color: cr_ef33,
      //   child: Padding(
      //     padding: const EdgeInsets.only(bottom: 50, top: 20),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Row(
      //           children: [
      //             Expanded(
      //               child: TextFont(text: 'text'),
      //             ),
      //             Expanded(
      //               child: TextFont(text: 'text'),
      //             ),
      //             Expanded(
      //               child: TextFont(text: 'text'),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget calendarHeader() {
    return Obx(() {
      if (calendarController.calendarMonthList.value.monthFullName == null || calendarController.rxMonth.value == null) {
        return Center(child: SizedBox.shrink());
      }

      return Row(
        children: [
          TextFont(
            text: "${calendarController.calendarMonthList.value.monthFullName} "
                "(${calendarController.rxMonth.value.toString().padLeft(2, '0')})",
            fontWeight: FontWeight.w700,
          ),
          Spacer(),
          InkWell(
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: TextFont(
                  text: "Select Year & Month",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                actions: [
                  SizedBox(
                    height: 250, // Adjust height for visibility
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Year Picker
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: int.parse(calendarController.rxYear.value) - 2000,
                            ),
                            onSelectedItemChanged: (index) {
                              int selectedYear = 2000 + index;
                              calendarController.rxYear.value = selectedYear.toString();
                            },
                            children: List.generate(50, (index) {
                              int year = 2000 + index;
                              return Center(child: Text(year.toString()));
                            }),
                          ),
                        ),

                        // Month Picker
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: int.parse(calendarController.rxMonth.value) - 1,
                            ),
                            onSelectedItemChanged: (index) {
                              calendarController.rxMonth.value = (index + 1).toString();
                            },
                            children: List.generate(12, (index) {
                              return Center(child: Text("${index + 1}".padLeft(2, '0')));
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    calendarController.fetchCalendarMonthList(calendarController.rxYear.value, calendarController.rxMonth.value.padLeft(2, '0')); // Fetch updated data
                    Navigator.pop(context);
                  },
                  child: TextFont(
                    text: "Done",
                    fontWeight: FontWeight.bold,
                    color: cr_red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 5.w,
                ),
                SizedBox(width: 6),
                TextFont(
                  text: calendarController.rxYear.value.toString(),
                  fontWeight: FontWeight.w600,
                  poppin: true,
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Container calendarDayHeader() {
    return Container(
      width: Get.width,
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: calendarController.days.length,
        crossAxisCount: 7,
        padding: EdgeInsets.only(bottom: 3),
        itemBuilder: (contex1t, index) {
          var e = calendarController.days[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFont(
              text: e.toUpperCase(),
              textAlign: TextAlign.center,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: (e.toLowerCase() == 'sat' || e.toLowerCase() == 'sun') ? Color(0xffD95842) : color_text_grey,
            ),
          );
        },
      ),
    );
  }

  Widget calendarDayBody() {
    // Check if the list is null or empty before building the grid
    if (calendarController.calendarMonthList.value.listDates == null || calendarController.calendarMonthList.value.listDates!.isEmpty) {
      return Center(child: SizedBox.shrink() // Show a loading indicator when data is not available
          );
    }

    return AlignedGridView.count(
      crossAxisCount: 7,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 3),
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      itemCount: calendarController.calendarMonthList.value.listDates!.length,
      itemBuilder: (context, index) {
        var e = calendarController.calendarMonthList.value.listDates![index];

        return InkWell(
          onTap: () {
            // checktokencalen();
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 6, top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: (e.isToday ?? false) ? cr_red.withOpacity(0.5) : Colors.transparent),
              color: (e.isToday ?? false) ? color_red244.withOpacity(0.1) : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TextFont(
                        text: e.christDay ?? '-', // Handle null safety
                        textAlign: TextAlign.center,
                        color: e.color != null ? Color(int.parse(e.color!)) : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        poppin: true,
                      ),
                      if (e.icon != null && e.icon!.isNotEmpty) // Null & Empty check for icon
                        Positioned(
                          right: 2,
                          child: Opacity(
                            opacity: e.color == '0xffC4C4C4' ? .5 : 1,
                            child: CachedNetworkImage(
                              imageUrl: e.icon!,
                              fit: BoxFit.fill,
                              width: 2.7.w,
                              progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  e.buddhaDay ?? '', // Handle null safety
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.notoSansLao(
                    height: 1.3,
                    fontSize: 7.5.sp,
                    color: e.color == '0xffC4C4C4' ? color_c4c4 : color_999,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget specialDayList() {
    return Obx(() {
      // Check if the list is null or empty
      if (calendarController.calendarMonthList.value.listSpecial == null || calendarController.calendarMonthList.value.listSpecial!.isEmpty) {
        return Center(child: SizedBox.shrink() // Show loading indicator while data is fetching
            );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...calendarController.calendarMonthList.value.listSpecial!.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TextFont(
                        text: e.date ?? '-', // Handle null safety
                        poppin: true,
                        fontSize: 11,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFont(
                          text: e.description ?? 'No description available', // Handle null safety
                          fontSize: 10.5,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(), // Convert map to list to avoid errors
            ],
          ),
        ),
      );
    });
  }
}
