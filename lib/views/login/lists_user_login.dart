import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/calendar_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/appbar_login.dart';
import 'package:super_app/views/login/bottom_datebar.dart';
import 'package:super_app/views/login/login.dart';
import 'package:super_app/views/login/login_have_acc.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/textfont.dart';

class UserProfileListView extends StatefulWidget {
  @override
  _UserProfileListViewState createState() => _UserProfileListViewState();
}

class _UserProfileListViewState extends State<UserProfileListView> {
  final TempUserProfileStorage userStorage = TempUserProfileStorage();
  int? selectedIndex; // Track selected item
  bool chkSelected = false; // Track if any item is selected
  final calendarController = Get.put(CarlendarsController());
  DateTime now = DateTime.now();
  TempUserProfile? seletedUser;

  @override
  Widget build(BuildContext context) {
    List<TempUserProfile> users = userStorage.getTempUserProfiles();

    String maskPhoneNumber(String number) {
      if (number.length >= 7) {
        return number.replaceRange(4, 7, '***');
      }
      return number;
    }

    return Scaffold(
      bottomNavigationBar: BottomDateBar(
        calendarController: calendarController,
        now: now,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppbarLogin(),
                      // Header Text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: 'Login ',
                            color: color_primary_light,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          TextFont(
                            text: 'to MmoneyX',
                            maxLines: 2,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      TextFont(
                        text: 'Super App',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                      ),
                      SizedBox(height: 10.sp),

                      // User List
                      users.isEmpty
                          ? Center(child: TextFont(text: 'No user profiles found', poppin: true))
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: ListView.builder(
                                itemCount: users.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  bool isSelected = index == selectedIndex;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        chkSelected = true;
                                        seletedUser = user;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected ? color_fbd : color_ecec,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected ? color_primary_light.withOpacity(0.5) : Colors.transparent,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: CachedNetworkImageProvider(user.imageProfile),
                                          ),
                                          SizedBox(width: 20.sp),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextFont(
                                                  text: user.fullname,
                                                  noto: true,
                                                  fontWeight: FontWeight.w600,
                                                  color: color_777,
                                                  // maxLines: 2,
                                                ),
                                                TextFont(
                                                  text: maskPhoneNumber(user.username),
                                                  noto: true,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                // TextFont(
                                                //   text: DateFormat('dd-MM-yyyy HH:mm').format(user.lastLogin),
                                                //   poppin: true,
                                                //   color: color_777,
                                                //   fontSize: 8,
                                                // ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close, color: color_777),
                                            onPressed: () {
                                              userStorage.deleteTempUserProfile(user.username);
                                              setState(() {}); // Refresh list after deletion
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: 10.sp),
                      buildBottomAppbar(
                        func: chkSelected && seletedUser != null
                            ? () => Get.offAll(LoginHaveAccount(user: seletedUser!.toJson()))
                            : () {}, // Disable if not selected
                        title: 'continue_as',
                        bgColor: chkSelected ? cr_ef33 : color_d5d5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.offAll(LoginScreen());
                            },
                            child: TextFont(
                              text: 'swap_account',
                              underline: true,
                              color: cr_ef33,
                              underlineColor: cr_ef33,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
