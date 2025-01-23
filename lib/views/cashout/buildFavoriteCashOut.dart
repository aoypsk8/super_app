// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class buildFavoriteCashOut extends StatefulWidget {
  const buildFavoriteCashOut({
    super.key,
    required this.updateParentValue,
  });

  final Function(String, String) updateParentValue;

  @override
  State<buildFavoriteCashOut> createState() => _buildFavoriteCashOutState();
}

class _buildFavoriteCashOutState extends State<buildFavoriteCashOut> {
  List<Map<String, dynamic>> favoriteData = [];
  final cashOutController = Get.put(CashOutController());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('favoriteCashout');
    if (jsonData != null && jsonData.isNotEmpty) {
      List<dynamic> data = json.decode(jsonData);
      List<Map<String, dynamic>> filteredData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

      // Search for the item with matching 'id'
      var searchResult = filteredData.firstWhere(
        (item) => item['id'] == cashOutController.rxCodeBank.value,
        orElse: () => {}, // Return null if no match is found
      );

      setState(() {
        // If found, set the result as a single-item list; otherwise, set an empty list
        favoriteData = searchResult != null ? [searchResult] : [];
      });
    }
  }

  Future<void> _updateFavoriteStatus(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonHistoryData = prefs.getString('historyCashout');
    if (jsonHistoryData != null && jsonHistoryData.isNotEmpty) {
      List<Map<String, dynamic>> historyData = json
          .decode(jsonHistoryData)
          .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
          .toList();
      for (var item in historyData) {
        if (item['AccNo'] == favoriteData[index]['AccNo']) {
          item['favorite'] = 0;
          break;
        }
      }
      await prefs.setString('historyCashout', json.encode(historyData));
    }
    deleteData(favoriteData[index]['AccNo']);
  }

  Future<void> deleteData(String AccNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoriteData.removeWhere((item) => item['AccNo'] == AccNo);
    await prefs.setString('favoriteCashout', json.encode(favoriteData));
    setState(() {});
    showTopSnackBar(
      Overlay.of(context),
      snackBarPosition: SnackBarPosition.bottom,
      displayDuration: const Duration(milliseconds: 1000),
      CustomSnackBar.error(
        icon: const Icon(Icons.delete_forever,
            color: Color.fromARGB(161, 255, 255, 255), size: 120),
        message: "Deleted from favorites.",
        textStyle: GoogleFonts.notoSansLao(color: color_fff),
        textAlign: TextAlign.left,
        maxLines: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(favoriteData);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: favoriteData.isNotEmpty && favoriteData.first.isEmpty
          ? Center(
              child: TextFont(
                text: "not_found",
                color: cr_090a,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: List.generate(favoriteData.length, (index) {
                  return InkWell(
                    onTap: () {
                      widget.updateParentValue(
                        favoriteData[index]['AccNo'] ?? '',
                        favoriteData[index]['AccName'] ?? '',
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: cr_ecec),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Image.network(
                                  favoriteData[index]['logo'],
                                  fit: BoxFit.cover,
                                  width: 11.w,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFont(
                                          text: favoriteData[index]
                                                  ['AccName'] ??
                                              '',
                                          fontSize: 9.sp,
                                          color: cr_2929,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        if (favoriteData[index]['AccNo'] !=
                                            null)
                                          TextFont(
                                            text: maskMsisdn(favoriteData[index]
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
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _updateFavoriteStatus(index);
                                },
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: SvgPicture.asset(
                                    MyIcon.ic_heart_fill,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }

  String maskMsisdn(String msisdn) {
    return msisdn.replaceRange(3, msisdn.length - 3, '****');
  }
}
