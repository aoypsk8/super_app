// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/models/calendar_model.dart';
import 'package:super_app/services/api/dio_client.dart';

class CarlendarsController extends GetxController {
  String baseURL = 'https://mspro.laotel.com/';
  final storage = GetStorage();
  DateTime now = DateTime.now();
  Rx<CalendarModel> calendarMonthList = CalendarModel().obs;
  RxString rxYear = ''.obs;
  RxString rxMonth = ''.obs;
  List<String> days = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];

  Future<void> fetchCalendarMonthList(String year, String month) async {
    try {
      var msisdn = storage.read('msisdn') ?? '20';
      var langKey = await storage.read('language') ?? 'en';
      if (langKey == 'lo') langKey = 'la';
      var response = await DioClient.getNoLoading(
        '${baseURL}api/CalendarOfMonth?year=$year&month=$month&Language=$langKey&msisdn=$msisdn',
      );
      if (response != null) {
        rxYear.value = year;
        rxMonth.value = month;
        calendarMonthList.value = CalendarModel.fromJson(response);
      } else {
        print("Error: Received null response from API");
      }
    } catch (e) {
      print("Error fetching calendar data: $e");
    }
  }
}
