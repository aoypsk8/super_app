// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unrelated_type_equality_checks, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class buildHistoryTransferRecent extends StatefulWidget {
  const buildHistoryTransferRecent({
    super.key,
    required this.updateParentValue,
  });

  final Function(String, String) updateParentValue;

  @override
  State<buildHistoryTransferRecent> createState() =>
      _buildHistoryTransferRecentState();
}

class _buildHistoryTransferRecentState
    extends State<buildHistoryTransferRecent> {
  List<Map<String, dynamic>> historyData = [];
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('historyTransfer');
    if (jsonData != null) {
      List<dynamic> data = json.decode(jsonData);
      print(data);
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
      List<Map<String, dynamic>> lastFiveItems = sortedData.take(20).toList();
      setState(() {
        historyData = lastFiveItems;
      });
    }
  }

  void _saveFavoriteTransfer(
      String walletNo, String walletName, String profile_user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoriteDataString = prefs.getString('favoriteTransfer');
    List<Map<String, dynamic>> favoriteData = [];
    if (favoriteDataString != null && favoriteDataString.isNotEmpty) {
      try {
        favoriteData = (json.decode(favoriteDataString) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        print('Error decoding favoriteTransfer: $e');
      }
    }
    String? historyDataString = prefs.getString('historyTransfer');
    List<Map<String, dynamic>> historyDataList = [];
    if (historyDataString != null && historyDataString.isNotEmpty) {
      try {
        historyDataList = (json.decode(historyDataString) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        print('Error decoding historyTransfer: $e');
        return;
      }
    }
    bool existsInFavorites =
        favoriteData.any((item) => item['walletNo'] == walletNo);
    bool existsInHistory = false;

    for (var item in historyDataList) {
      if (item['walletNo'] == walletNo) {
        item['favorite'] = (item['favorite'] == 1) ? 0 : 1;
        existsInHistory = true;
        if (item['favorite'] == 1 && !existsInFavorites) {
          favoriteData.add({
            'walletNo': walletNo,
            'profile_user': profile_user,
            'walletName': walletName,
            'timeStamp': DateTime.now().toIso8601String(),
          });
        } else if (item['favorite'] == 0) {
          favoriteData.removeWhere((fav) => fav['walletNo'] == walletNo);
        }
        break;
      }
    }
    if (!existsInHistory) {
      historyDataList.add({
        'walletNo': walletNo,
        'profile_user': profile_user,
        'walletName': walletName,
        'timeStamp': DateTime.now().toIso8601String(),
        'favorite': 1,
      });
      favoriteData.add({
        'walletNo': walletNo,
        'profile_user': profile_user,
        'walletName': walletName,
        'timeStamp': DateTime.now().toIso8601String(),
      });
      print(favoriteData);
    }
    try {
      prefs.setString('historyTransfer', json.encode(historyDataList));
      prefs.setString('favoriteTransfer', json.encode(favoriteData));
      print('Favorite status updated for $walletNo');
    } catch (e) {
      print('Error saving data: $e');
    }
    _loadData();
  }

  void removeFavorite(String walletNo) async {
    String? jsonData = storage.read('favoriteTransfer');
    if (jsonData != null) {
      List<dynamic> data = json.decode(jsonData);
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
      int indexToDelete = -1;
      for (int i = 0; i < sortedData.length; i++) {
        if (sortedData[i]['walletNo'] == walletNo) {
          indexToDelete = i;
          break;
        }
      }
      // Remove the data if found
      if (indexToDelete != -1) {
        sortedData.removeAt(indexToDelete);
        String newJsonData = json.encode(sortedData);
        storage.write('favoriteTransfer', newJsonData);
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
                  widget.updateParentValue(historyData[index]['walletNo'],
                      historyData[index]['walletName']);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: cr_ecec)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                historyData[index]['profile_user'] ??
                                    MyConstant.profile_default,
                                fit: BoxFit.cover,
                                width: 11.w,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFont(
                                      text: historyData[index]['walletName'],
                                      fontSize: 12,
                                      color: cr_2929,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    TextFont(
                                      text: maskMsisdn(historyData[index]
                                              ['walletNo']
                                          .toString()),
                                      fontSize: 11,
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
                              onTap: () {
                                _saveFavoriteTransfer(
                                  (historyData[index]['walletNo']),
                                  (historyData[index]['walletName']),
                                  (historyData[index]['profile_user']),
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

  String maskMsisdn(String msisdn) {
    return msisdn.replaceRange(3, msisdn.length - 3, '****');
  }
}
