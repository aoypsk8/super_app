// ignore_for_file: unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/login/lists_user_login.dart';
import 'package:super_app/views/settings/verify_account.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class RefreshTokenWebview extends StatefulWidget {
  final Map<String, dynamic> user;
  const RefreshTokenWebview({super.key, required this.user});

  @override
  State<RefreshTokenWebview> createState() => _RefreshTokenWebviewState();
}

class _RefreshTokenWebviewState extends State<RefreshTokenWebview> {
  final box = GetStorage();
  final _password = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    String? msisdn = box.read('msisdn'); // ✅ Fix: Handle null case
    if (msisdn != null) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (widget.user != null) {
          loginWithBiometric();
        }
      });
    }
  }

  loginWithBiometric() async {
    bool chkBiometric = box.read('biometric') ?? false;
    if (chkBiometric) {
      bool isAuthenticated = false;
      try {
        isAuthenticated = await _localAuth.authenticate(
          localizedReason: "Authenticate to login.",
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
            sensitiveTransaction: true,
          ),
        );
        if (isAuthenticated) {
          String pwd = storage.read('biometric_password') ?? '';
          bool success = await userController.loginRefreshTokenWebview(widget.user['username'], pwd);
          if (success) {
            Get.back(result: true); // ✅ Return true to WebView after login success
          }
        }
      } catch (e) {
        print("Biometric authentication error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppbarLogin(),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildProfileSection(),
                          _buildPasswordField(),
                          // _buildActionButtons(),
                          SizedBox(height: 10.sp),
                          // _buildLoginBiometric(),
                          SizedBox(height: 10.sp),
                          _buildLoginButton(),
                          SizedBox(height: 15.h),
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
    );
  }

  /// ✅ Profile Picture & Name Section
  Widget _buildProfileSection() {
    return Column(
      children: [
        // TextFont(text: widget.user['image_profile']),
        Stack(
          children: [
            SizedBox(
              width: 60.w,
              height: 60.w,
              child: Lottie.asset('assets/animation/circle.json'),
            ),
            Positioned.fill(
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
                      widget.user['image_profile'] ?? 'https://mmoney.la/AppLite/Users/mmoney.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TextFont(
          text: widget.user['fullname'] ?? '',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          noto: true,
        ),
        TextFont(
          text: widget.user != null ? _maskPhoneNumber(widget.user['username']) : 'No Account',
          fontSize: 18,
          poppin: true,
        ),
      ],
    );
  }

  /// ✅ Password Input Field
  Widget _buildPasswordField() {
    return buildPasswordField(controller: _password, label: 'password', name: 'password');
  }

  /// ✅ Login Button
  Widget _buildLoginButton() {
    return buildBottomAppbar(
      high: 0,
      func: () async {
        if (_formKey.currentState!.validate()) {
          bool success = await userController.loginRefreshTokenWebview(widget.user['username'], _password.text);
          if (success) {
            Get.back(result: true);
          }
        }
      },
      title: 'login',
    );
  }

  /// ✅ Mask Phone Number (e.g., "2023***123")
  String _maskPhoneNumber(String number) {
    if (number.length >= 7) {
      return number.replaceRange(4, 7, '***');
    }
    return number;
  }
}
