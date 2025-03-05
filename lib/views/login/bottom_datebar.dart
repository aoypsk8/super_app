import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/calendar_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/calendar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class BottomDateBar extends StatelessWidget {
  final CarlendarsController calendarController;
  final DateTime now;

  const BottomDateBar({
    Key? key,
    required this.calendarController,
    required this.now,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (calendarController.calendarMonthList.value.listDates == null || calendarController.calendarMonthList.value.listDates!.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      String eventDesc = "";
      String todayDay = "";
      String fullDay = "";

      try {
        var todayDate = calendarController.calendarMonthList.value.listDates!.firstWhereOrNull((e) => e.isToday == true);
        var eventDate = calendarController.calendarMonthList.value.listSpecial!.firstWhereOrNull((e) => e.date == todayDate?.christDay);
        eventDesc = eventDate?.description ?? 'no_events';
        todayDay = todayDate?.christDay ?? '';
        fullDay = todayDate?.fullDay ?? '';
        if (fullDay.length >= 7) {
          fullDay = "${fullDay.substring(5, 7)}/${fullDay.substring(0, 4)}";
        }
      } catch (e) {
        print(e);
      }

      return InkWell(
        onTap: () => Get.to(CalendarScreen(), transition: Transition.downToUp, duration: Duration(milliseconds: 500))?.then((_) async {
          await calendarController.fetchCalendarMonthList(
            now.year.toString(),
            now.month.toString(),
          );
        }),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(MyIcon.ic_arrowUp),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFont(
                      text: todayDay,
                      color: color_primary_light,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      poppin: true,
                    ),
                    TextFont(
                      text: fullDay,
                      color: color_primary_light,
                      poppin: true,
                      fontSize: 10,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: color_f4f4,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFont(
                                text: eventDesc,
                                maxLines: 3,
                                fontSize: 10,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: cr_ef33,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: TextFont(
                                  text: 'view_calendar',
                                  fontSize: 10,
                                  color: color_fff,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
