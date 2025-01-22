// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class buildHistoryCashOutRecent extends StatefulWidget {
  const buildHistoryCashOutRecent({
    super.key,
    required this.updateParentValue,
  });

  final Function(String, String) updateParentValue;

  @override
  State<buildHistoryCashOutRecent> createState() =>
      _buildHistoryCashOutRecentState();
}

class _buildHistoryCashOutRecentState extends State<buildHistoryCashOutRecent> {
  List<Map<String, dynamic>> historyData = [];
  final cashOutController = Get.put(CashOutController());
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      _loadData();
    });
    cashOutController.fetchRecentBank();
    _loadData();
  }

  _loadData() async {
    if (cashOutController.recentModel.value.isNotEmpty) {
      List<Map<String, dynamic>> data = cashOutController.recentModel.value
          .map((model) => model.toJson())
          .toList();
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['id'].compareTo(a['id']));
      List<Map<String, dynamic>> lastFiveItems = sortedData.take(5).toList();
      // Update state
      setState(() {
        historyData = lastFiveItems;
      });
    } else {
      print("No data in recentModel.");
    }
  }

  void _saveFavoriteCashout(String AccNo, String AccName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoriteDataString = prefs.getString('favoriteCashout');
    List<Map<String, dynamic>> favoriteData = [];

    if (favoriteDataString != null && favoriteDataString.isNotEmpty) {
      try {
        favoriteData = (json.decode(favoriteDataString) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        print('Error decoding favoriteCashout: $e');
      }
    }

    String? historyDataString = prefs.getString('historyCashout');
    List<Map<String, dynamic>> historyDataList = [];

    if (historyDataString != null && historyDataString.isNotEmpty) {
      try {
        historyDataList = (json.decode(historyDataString) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        print('Error decoding historyCashout: $e');
        return;
      }
    }

    bool existsInFavorites = favoriteData.any((item) => item['AccNo'] == AccNo);
    bool existsInHistory = false;

    for (var item in historyDataList) {
      if (item['AccNo'] == AccNo) {
        item['favorite'] = (item['favorite'] == 1) ? 0 : 1;
        existsInHistory = true;
        if (item['favorite'] == 1 && !existsInFavorites) {
          favoriteData.add({
            'AccNo': AccNo,
            'AccName': AccName,
            'timeStamp': DateTime.now().toIso8601String(),
          });
        } else if (item['favorite'] == 0) {
          favoriteData.removeWhere((fav) => fav['AccNo'] == AccNo);
        }
        break;
      }
    }

    if (!existsInHistory) {
      historyDataList.add({
        'AccNo': AccNo,
        'AccName': AccName,
        'timeStamp': DateTime.now().toIso8601String(),
        'favorite': 1,
      });

      favoriteData.add({
        'AccNo': AccNo,
        'AccName': AccName,
        'timeStamp': DateTime.now().toIso8601String(),
      });
    }

    try {
      prefs.setString('historyCashout', json.encode(historyDataList));
      prefs.setString('favoriteCashout', json.encode(favoriteData));
      print('Favorite status updated for $AccNo');
    } catch (e) {
      print('Error saving data: $e');
    }

    _loadData();
  }

  void removeFavorite(String AccNo) async {
    String? jsonData = storage.read('favoriteCashout');
    if (jsonData != null) {
      List<dynamic> data = json.decode(jsonData);
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

      int indexToDelete = -1;
      for (int i = 0; i < sortedData.length; i++) {
        if (sortedData[i]['AccNo'] == AccNo) {
          indexToDelete = i;
          break;
        }
      }

      if (indexToDelete != -1) {
        sortedData.removeAt(indexToDelete);
        String newJsonData = json.encode(sortedData);
        storage.write('favoriteCashout', newJsonData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            historyData.length,
            (index) {
              return InkWell(
                onTap: () {
                  widget.updateParentValue(historyData[index]['AccNo'],
                      historyData[index]['AccName']);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: cr_ecec),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              MyIcon.ic_user,
                              fit: BoxFit.fill,
                              width: 11.w,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFont(
                                      text: historyData[index]['AccName'],
                                      fontSize: 9.sp,
                                      color: cr_2929,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    TextFont(
                                      text: maskAccountNumber(historyData[index]
                                              ['AccNo']
                                          .toString()),
                                      fontSize: 9.sp,
                                      color: cr_7070,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  historyData[index]['favorite'] =
                                      historyData[index]['favorite'] == 1
                                          ? 0
                                          : 1;
                                });

                                _saveFavoriteCashout(
                                  historyData[index]['AccNo'],
                                  historyData[index]['AccName'],
                                );
                              },
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: historyData[index]['favorite'] == 1
                                    ? SvgPicture.asset(
                                        MyIcon.ic_heart_fill,
                                        fit: BoxFit.fill,
                                      )
                                    : SvgPicture.asset(
                                        MyIcon.ic_heart_unfill,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String maskAccountNumber(String AccNo) {
    if (AccNo.length > 6) {
      return AccNo.replaceRange(3, AccNo.length - 3, '****');
    }
    return AccNo;
  }
}
