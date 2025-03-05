import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/calendar_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/appbar_login.dart';
import 'package:super_app/views/login/bottom_datebar.dart';
import 'package:super_app/views/login/lists_user_login.dart';
import 'package:super_app/views/login/login.dart';
import 'package:super_app/views/settings/verify_account.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class LoginHaveAccount extends StatefulWidget {
  final Map<String, dynamic> user; // Accept user data

  LoginHaveAccount({
    super.key,
    required this.user, // Required parameter
  });

  @override
  State<LoginHaveAccount> createState() => _LoginHaveAccountState();
}

class _LoginHaveAccountState extends State<LoginHaveAccount> {
  final calendarController = Get.put(CarlendarsController());

  final box = GetStorage();

  DateTime now = DateTime.now();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _password = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  loadData() async {
    await calendarController.fetchCalendarMonthList(now.year.toString(), now.month.toString());
  }

  @override
  Widget build(BuildContext context) {
    // String lastLoginTime = widget.user['last_login'] != null ? DateFormat('HH:mm').format(DateTime.parse(widget.user['last_login'])) : 'No recent login';

    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppbarLogin(),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: 60.w,
                                height: 60.w,
                                child: Lottie.asset('assets/animation/circle.json'),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 45.w,
                                    height: 45.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: color_primary_light.withOpacity(0.2), width: 5),
                                    ),
                                    child: CircleAvatar(
                                      radius: 80.sp,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: CachedNetworkImageProvider(
                                        widget.user['image_profile'] ??
                                            'https://profile.mmoney.la/ImageProfile/default_profile.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFont(
                            text: widget.user['fullname'] ?? 'Guest User',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            noto: true,
                          ),
                          TextFont(
                            text: widget.user['username'] ?? 'No Account',
                            fontSize: 18,
                            poppin: true,
                          ),
                          // TextFont(
                          //   text: 'Last Login: $lastLoginTime', // Display last login time
                          //   fontSize: 12,
                          //   color: Colors.grey,
                          //   poppin: true,
                          // ),
                          buildPasswordField(controller: _password, label: 'password', name: 'password'),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to((UserProfileListView()));
                                },
                                child: TextFont(
                                  text: 'recent_login',
                                  // underline: true,
                                  color: color_777,
                                ),
                              ),
                              forgot_password(),
                            ],
                          ),
                          SizedBox(height: 20.sp),
                          buildBottomAppbar(
                              func: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  userController.loginSuperApp(
                                    widget.user['username'],
                                    _password.text,
                                    reqOTPprocess: false,
                                  );
                                }
                              },
                              title: 'login'),
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomDateBar(calendarController: calendarController, now: now),
    );
  }
}
