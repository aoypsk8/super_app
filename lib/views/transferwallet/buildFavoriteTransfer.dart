// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class buildFavoriteTransfer extends StatefulWidget {
  const buildFavoriteTransfer({
    super.key,
    required this.updateParentValue,
  });

  final Function(String, String) updateParentValue;

  @override
  State<buildFavoriteTransfer> createState() => _buildFavoriteTransferState();
}

class _buildFavoriteTransferState extends State<buildFavoriteTransfer> {
  List<Map<String, dynamic>> favoriteData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('favoriteTransfer');
    if (jsonData != null && jsonData.isNotEmpty) {
      List<dynamic> data = json.decode(jsonData);
      setState(() {
        favoriteData = List<Map<String, dynamic>>.from(data)
          ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
      });
    }
  }

  Future<void> _updateFavoriteStatus(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonHistoryData = prefs.getString('historyTransfer');
    if (jsonHistoryData != null && jsonHistoryData.isNotEmpty) {
      List<Map<String, dynamic>> historyData = json
          .decode(jsonHistoryData)
          .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
          .toList();
      for (var item in historyData) {
        if (item['walletNo'] == favoriteData[index]['walletNo']) {
          item['favorite'] = 0;
          break;
        }
      }
      await prefs.setString('historyTransfer', json.encode(historyData));
    }
    deleteData(favoriteData[index]['walletNo']);
  }

  Future<void> deleteData(String walletNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoriteData.removeWhere((item) => item['walletNo'] == walletNo);
    await prefs.setString('favoriteTransfer', json.encode(favoriteData));
    setState(() {});
    showTopSnackBar(
      Overlay.of(context),
      snackBarPosition: SnackBarPosition.bottom,
      displayDuration: const Duration(milliseconds: 1000),
      CustomSnackBar.error(
        icon: const Icon(Icons.delete_forever,
            color: Color.fromARGB(161, 255, 255, 255), size: 120),
        message: "Deleted $walletNo from favorites.",
        textStyle: GoogleFonts.notoSansLao(color: color_fff),
        textAlign: TextAlign.left,
        maxLines: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: favoriteData.isEmpty
          ? Center(
              child: Text(
                "not_found",
                style: GoogleFonts.notoSansLao(fontSize: 12.sp, color: cr_2929),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: List.generate(favoriteData.length, (index) {
                  return InkWell(
                    onTap: () {
                      widget.updateParentValue(favoriteData[index]['walletNo'],
                          favoriteData[index]['walletName']);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFont(
                                          text: favoriteData[index]
                                              ['walletName'],
                                          fontSize: 9.sp,
                                          color: cr_2929,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        TextFont(
                                          text: maskMsisdn(favoriteData[index]
                                                  ['walletNo']
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
                                    favoriteData[index]['favorite'] == 0
                                        ? MyIcon.ic_heart_unfill
                                        : MyIcon.ic_heart_fill,
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
