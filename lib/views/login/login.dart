import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/calendar_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/appbar_login.dart';
import 'package:super_app/views/login/calendar.dart';
import 'package:super_app/views/login/bottom_datebar.dart';
import 'package:super_app/views/login/forgot_password.dart';
import 'package:super_app/views/login/lists_user_login.dart';
import 'package:super_app/views/login/login_have_acc.dart';
import 'package:super_app/views/login/login_mmoney.dart';
import 'package:super_app/views/login/login_tplus_mservice.dart';
import 'package:super_app/views/login/opt_screen.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/views/register/register.dart';
import 'package:super_app/views/settings/verify_account.dart';
import 'package:super_app/views/x-jaidee/Xjaidee.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final calendarController = Get.put(CarlendarsController());
  final box = GetStorage();
  DateTime now = DateTime.now();

  TempUserProfileStorage userStorage = TempUserProfileStorage();

  String signInWith = 'super_app';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      var msisdn = box.read('msisdn');
      if (msisdn == null) {
        showSignInWith(context);
      }
    });
  }

  loadData() async {
    await calendarController.fetchCalendarMonthList(now.year.toString(), now.month.toString());
  }

  void showSignInWith(BuildContext context) {
    var fromApps = [
      {
        "title": "M moneyX",
        "logo": "assets/images/mmoneyx.jpg",
      },
      {
        "title": "M-Services",
        "logo": "assets/images/mservice.png",
      },
      {
        "title": "My T-Plus",
        "logo": "assets/images/tplus.png",
      },
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0), // Remove default padding
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 5.w, // Full width
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 50.w, // Full width
                            height: 50.w,
                            child: Image.asset('assets/images/from.png', fit: BoxFit.cover),
                          ),
                          Row(
                            children: [
                              TextFont(
                                text: 'Where are you from?',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                poppin: true,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              itemCount: fromApps.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(), // Disable scroll inside dialog
                              itemBuilder: (context, index) {
                                final data = fromApps[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      signInWith = data['title']!;
                                    });
                                    Get.back();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: color_f4f4,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: cr_eae7, width: 2.0),
                                            image: DecorationImage(image: AssetImage(data['logo']!), fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextFont(
                                                text: data['title']!,
                                                poppin: true,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              TextFont(
                                                text: 'Continues as ${data['title']} User.',
                                                color: cr_7070,
                                                fontSize: 10,
                                                poppin: true,
                                              ),
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
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            signInWith = 'default';
                          });
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cr_eae7,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateSignInMethod(String method) {
    setState(() {
      signInWith = method; // Update the signInWith variable
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getLoginWidget() {
      switch (signInWith) {
        case 'default':
          return LoginUsernamePassword();
        case 'M-Services':
          return LoginTplusMservice(onMethodSelected: updateSignInMethod, title: 'M-Services');
        case 'My T-Plus':
          return LoginTplusMservice(onMethodSelected: updateSignInMethod, title: 'My T-Plus');
        case 'M moneyX':
          return LoginMmoney(onMethodSelected: updateSignInMethod);
        default:
          return LoginUsernamePassword();
      }
    }

    return Scaffold(
      backgroundColor: color_fff,
      body: SafeArea(
        child: Column(
          children: [
            AppbarLogin(),
            getLoginWidget(),
            // users.isEmpty ? getLoginWidget() : LoginHaveAccount(user: Map<String, dynamic>.from(users[0].toJson())),
            InkWell(
              onTap: () {
                showSignInWith(context);
              },
              child: TextFont(text: 'sign_in_with'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomDateBar(calendarController: calendarController, now: now),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageService = Get.find<LanguageService>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows bottom sheet to be flexible
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(
                text: 'Select Language',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: cr_7070, // Follow theme color
              ),
              SizedBox(height: 16),
              _buildLanguageOption(context, 'English', 'en', languageService),
              _buildLanguageOption(context, 'Lao', 'lo', languageService),
              _buildLanguageOption(context, 'Chinese', 'zh', languageService),
              _buildLanguageOption(context, 'Vietnamese', 'vi', languageService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String languageName, String languageCode, LanguageService languageService) {
    return ListTile(
      title: TextFont(
        text: languageName,
        color: cr_7070, // Follow theme color
      ),
      trailing: languageService.locale.languageCode == languageCode
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null, // Show check mark for the active language
      onTap: () {
        languageService.changeLanguage(languageCode);
        loadData();
        Get.back(); // Close the bottom sheet after selecting a language
      },
    );
  }
}

class LoginUsernamePassword extends StatelessWidget {
  const LoginUsernamePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final _username = TextEditingController();
    final _password = TextEditingController();
    return Expanded(
      child: Animate(
        delay: Durations.long1,
        effects: [FlipEffect(), SlideEffect()],
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  // Row(
                  //   textBaseline: TextBaseline.alphabetic,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     TextFont(
                  //       text: 'Login ',
                  //       color: color_primary_light,
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //     TextFont(
                  //       text: 'to MmoneyX',
                  //       maxLines: 2,
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     TextFont(
                  //       text: 'Super App',
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w500,
                  //       maxLines: 2,
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10.sp),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1, // Adjust width if necessary
                          child: SizedBox.expand(
                            child: SvgPicture.asset(
                              'assets/icons/ic_mmoneyx.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: VerticalDivider(
                            color: color_777,
                            thickness: 1,
                            width: 1,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFont(
                                text: 'Login ',
                                color: color_primary_light,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              TextFont(
                                text: 'to M moneyX',
                                maxLines: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              TextFont(
                                text: 'SuperApp',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField(
                          controller: _username,
                          label: 'username',
                          name: 'username',
                          hintText: 'enter_your_username',
                        ),
                        buildPasswordField(
                          controller: _password,
                          label: 'password',
                          name: 'password',
                          hintText: 'enter_your_password',
                          isMinLengthRequired: true,
                        ),
                        forgot_password(),
                        SizedBox(height: 20.sp),
                        buildBottomAppbar(
                            func: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                userController.loginSuperApp(_username.text, _password.text);
                              }
                            },
                            title: 'login'),
                        newuser_register(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class newuser_register extends StatelessWidget {
  const newuser_register({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        TextFont(text: 'new_account?'),
        InkWell(
          onTap: () {
            Get.to(RegisterScreen());
          },
          child: TextFont(
            text: 'register',
            underline: true,
            color: cr_ef33,
            underlineColor: cr_ef33,
          ),
        ),
      ],
    );
  }
}

class forgot_password extends StatelessWidget {
  const forgot_password({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return InkWell(
      onTap: () {
        Get.to(ForgotPasswordScreen());
      },
      child: Align(
          alignment: Alignment.centerRight,
          child: TextFont(
            text: 'forgot_password',
            underline: true,
            color: cr_ef33,
            underlineColor: cr_ef33,
          )),
    );
  }
}
