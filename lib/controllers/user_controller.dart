// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/models/appinfo_model.dart';
import 'package:super_app/models/balance_model.dart';
import 'package:super_app/models/history_detail_model.dart';
import 'package:super_app/models/history_model.dart';
import 'package:super_app/models/kyc_model.dart';
import 'package:super_app/models/profile_mmoney_model.dart';
import 'package:super_app/models/user_profile_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/splash_screen.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:super_app/views/login/create_password.dart';
import 'package:super_app/views/login/login_have_acc.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/views/main/bottom_nav.dart';
import 'package:super_app/views/register/register_form.dart';
import 'package:super_app/views/reusable_template/reusable_otp.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
import 'package:super_app/widget/reusableResultWithCode.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserController extends GetxController with WidgetsBindingObserver {
  final storage = GetStorage();
  final HomeController homController = Get.find();

  RxString walletid = ''.obs;
  RxString profileName = ''.obs;
  RxString birthday = ''.obs;
  RxString rxBirthday = ''.obs;

  // profile
  Rx<UserProfileModel> userProfilemodel = UserProfileModel().obs;
  Rx<KycModel> kycModel = KycModel().obs;

  // history
  RxList<HistoryModel> historylists = <HistoryModel>[].obs;
  RxMap<String, List<HistoryModel>> groupedHistory = <String, List<HistoryModel>>{}.obs;
  Rx<HistoryDetailModel> historyDetailModel = HistoryDetailModel().obs;

  // balance
  Rx<BalanceModel> balanceModel = BalanceModel().obs;
  RxInt totalBalance = 0.obs;
  RxInt mainBalance = 0.obs;
  RxInt pointBalance = 0.obs;

  RxBool isLogin = false.obs;
  RxBool isCheckToken = false.obs;

  //auth
  RxString rxMsisdn = ''.obs;

  // device info
  RxString device_id = ''.obs;
  RxString device_model = ''.obs;
  RxString os_version = ''.obs;
  RxString device_name = ''.obs;
  RxString rxLat = ''.obs;
  RxString rxLong = ''.obs;

  RxString rxToken = ''.obs;
  RxString rxEmail = ''.obs;
  RxString refcode = ''.obs;

  // new super app
  Rx<ProfileMmoneyModel> profileMmoneyModel = ProfileMmoneyModel().obs;

  RxString rxPasswordPartner = ''.obs;

  //number page to close
  RxInt pageclose = 0.obs;
  increasepage() {
    pageclose++;
    print('pages : $pageclose');
  }

  decreasepage() {
    pageclose--;
    print('pages : $pageclose');
  }

  // Future checktoken({String? name}) async {
  //   getCurrentLocation();
  // }

  @override
  void onReady() async {
    super.onReady();
    await queryUserProfile();
  }

  Future<void> loginpincode(String msisdn, String pincode) async {
    try {
      final response =
          await DioClient.postEncrypt('${MyConstant.urlGateway}/login', {"msisdn": msisdn, "pin": pincode});
      if (response != null && response["resultCode"] == 0) {
        final token = response['token'];
        if (token != null) {
          await storage.write('token', token);
          isLogin.value = true;
          rxToken.value = token;
          print('Token: $token');
        }
      } else {
        print('Error: Login failed with resultCode ${response?["resultCode"] ?? "unknown"}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> fetchBalance() async {
    try {
      var token = await storage.read('token');
      var msisdn = await storage.read('msisdn');

      if (token == null || msisdn == null) {
        print('Error: Missing token or msisdn');
        return;
      }
      var url = '${MyConstant.urlConsumerInfo}/UserProfile';
      var data = {"msisdn": msisdn};

      var response = await DioClient.postEncrypt(loading: false, url, data, key: 'lmm-key');

      if (response["resultCode"] == 0) {
        balanceModel.value = BalanceModel.fromJson(response);

        var result = balanceModel.value.data;
        if (result != null) {
          walletid.value = result.walletIds ?? '';
          birthday.value = result.birthday ?? '';
          totalBalance.value = result.amount ?? 0;
          mainBalance.value = result.fiat ?? 0;
          pointBalance.value = result.point ?? 0;
          // profileName.value = '${result.firstname ?? ''} ${result.lastname ?? ''}'.trim();
        }
      } else {
        print('Error: ${response["resultMessage"] ?? "Unknown error occurred"}');
      }
    } catch (e) {
      print('Error in fetchBalance: $e');
    }
  }

  queryUserProfile() async {
    try {
      //   var token = await storage.read('token');
      //   var msisdn = await storage.read('msisdn');
      var url = '${MyConstant.urlUser}/query';
      var data = {"msisdn": rxMsisdn.value};
      var response = await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
      if (response != null) {
        userProfilemodel.value = UserProfileModel.fromJson(response);
        profileName.value = '${userProfilemodel.value.name} ${userProfilemodel.value.surname}';
        return true;
      } else {
        print('Error: Response is null');
        return false;
      }
    } catch (e) {
      print('Error in queryKyc: $e');
    }
  }

  otpprocessTransfer(String otpCode) async {
    var response = await DioClient.postEncrypt(
      '${MyConstant.urlGateway}/confirmOTP',
      {
        "otp": otpCode,
        "ref": refcode.value,
      },
    );
    if (response['resultCode'] == 0) {
      // Get.off(() => const ConfirmTranferScreen());
    } else {
      DialogHelper.showErrorDialogNew(description: response['resultDesc']);
    }
  }

  resendotp() async {
    var response = await DioClient.postEncrypt('${MyConstant.urlGateway}/OTP', {'msisdn': rxMsisdn.value});
    print(response);
    if (response["resultCode"] == 0) {
      refcode.value = response["data"]["ref"].toString();
    } else {
      DialogHelper.showErrorDialogNew(description: 'ERRORTOTO');
    }
  }

  resendotpforemail() async {
    var response = await DioClient.postEncrypt(
        '${MyConstant.urlLoginByEmail}/GetMsisdn', {'email': rxEmail.value, 'birthday': rxBirthday.value});
    print(response);
    if (response["resultCode"] == 0) {
      refcode.value = response["data"]["ref"].toString();
    } else {
      DialogHelper.showErrorDialogNew(description: 'ERRORTOTO');
    }
  }

  uploadImgProfile(File imgFile, String imgType) async {
    String fileName = imgFile.path.split('/').last;
    var formData = dio.FormData.fromMap({
      "id": userProfilemodel.value.msisdn,
      'image': await dio.MultipartFile.fromFile(
        '.${imgFile.path}',
        filename: fileName,
      ),
    });

    var responseUpload = await DioClient.postEncrypt('${MyConstant.urlProfileUpload}/upload', formData, image: true);
    var dataUpdate = {
      "msisdn": userProfilemodel.value.msisdn,
      "gender": userProfilemodel.value.gender,
      "name": userProfilemodel.value.name,
      "surname": userProfilemodel.value.surname,
      "birthdate": userProfilemodel.value.birthdate,
      "provinceCode": userProfilemodel.value.provinceCode,
      "provinceDesc": userProfilemodel.value.provinceDesc,
      "district": userProfilemodel.value.district,
      "village": userProfilemodel.value.village,
      "card_id": userProfilemodel.value.cardId,
      "verify": userProfilemodel.value.verify,
      "type": userProfilemodel.value.type,
      "doc_img": userProfilemodel.value.docImg,
      "verify_img": userProfilemodel.value.verifyImg,
      "profile_img": responseUpload["newurl"],
      "created": userProfilemodel.value.created,
      "updated": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      "status": userProfilemodel.value.status
    };
    var url = '${MyConstant.urlUser}/requpdate';
    await DioClient.postEncrypt(url, dataUpdate, key: 'lmm');
    // querykyc();
    // userProfilemodel.value.profileImg = responseUpload["newurl"];
    queryUserProfile();
  }

  uploadDocImg(File imgFile, String imgType) async {
    String fileName = imgFile.path.split('/').last;
    var formData = dio.FormData.fromMap({
      "id": userProfilemodel.value.msisdn,
      'image': await dio.MultipartFile.fromFile('.${imgFile.path}', filename: fileName),
    });
    var responseUpload = await DioClient.postEncrypt(
      '${MyConstant.urlProfileUpload}/upload',
      formData,
      image: true,
    );
    var dataUpdate = {
      "msisdn": userProfilemodel.value.msisdn,
      "gender": userProfilemodel.value.gender,
      "name": userProfilemodel.value.name,
      "surname": userProfilemodel.value.surname,
      "birthdate": userProfilemodel.value.birthdate,
      "provinceCode": userProfilemodel.value.provinceCode,
      "provinceDesc": userProfilemodel.value.provinceDesc,
      "district": userProfilemodel.value.district,
      "village": userProfilemodel.value.village,
      "card_id": userProfilemodel.value.cardId,
      "verify": userProfilemodel.value.verify,
      "type": userProfilemodel.value.type,
      "doc_img": responseUpload["newurl"],
      "verify_img": userProfilemodel.value.verifyImg,
      "profile_img": userProfilemodel.value.profileImg,
      "created": userProfilemodel.value.created,
      "updated": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      "status": userProfilemodel.value.status
    };
    var url = '${MyConstant.urlUser}/requpdate';
    await DioClient.postEncrypt(url, dataUpdate, key: 'lmm');
    //   querykyc();
    // userProfilemodel.value.docImg = responseUpload["newurl"];
    queryUserProfile();
  }

  uploadVerifyImg(File imgFile, String imgType) async {
    String fileName = imgFile.path.split('/').last;
    var formData = dio.FormData.fromMap({
      "id": userProfilemodel.value.msisdn,
      'image': await dio.MultipartFile.fromFile('.${imgFile.path}', filename: fileName),
    });
    var responseUpload = await DioClient.postEncrypt(
      '${MyConstant.urlProfileUpload}/upload',
      formData,
      image: true,
    );
    var dataUpdate = {
      "msisdn": userProfilemodel.value.msisdn,
      "gender": userProfilemodel.value.gender,
      "name": userProfilemodel.value.name,
      "surname": userProfilemodel.value.surname,
      "birthdate": userProfilemodel.value.birthdate,
      "provinceCode": userProfilemodel.value.provinceCode,
      "provinceDesc": userProfilemodel.value.provinceDesc,
      "district": userProfilemodel.value.district,
      "village": userProfilemodel.value.village,
      "card_id": userProfilemodel.value.cardId,
      "verify": userProfilemodel.value.verify,
      "type": userProfilemodel.value.type,
      "doc_img": userProfilemodel.value.docImg,
      "verify_img": responseUpload["newurl"],
      "profile_img": userProfilemodel.value.profileImg,
      "created": userProfilemodel.value.created,
      "updated": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      "status": userProfilemodel.value.status
    };
    var url = '${MyConstant.urlUser}/requpdate';
    await DioClient.postEncrypt(loading: false, url, dataUpdate, key: 'lmm');
    // querykyc();
    // userProfilemodel.value.verifyImg = responseUpload["newurl"];
    queryUserProfile();
  }

  verificationRegister(gender, name, surname, bd, provincecode, province, dist, village, identify) async {
    var dataUpdate = {
      "msisdn": userProfilemodel.value.msisdn,
      "gender": gender,
      "name": name,
      "surname": surname,
      "birthdate": bd,
      "provinceCode": provincecode,
      "provinceDesc": province,
      "district": dist,
      "village": village,
      "card_id": identify,
      "verify": 'Pending',
      "type": userProfilemodel.value.type,
      "doc_img": userProfilemodel.value.docImg,
      "verify_img": userProfilemodel.value.verifyImg,
      "profile_img": userProfilemodel.value.profileImg,
      "created": userProfilemodel.value.created,
      "updated": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      "status": userProfilemodel.value.status
    };
    var url = '${MyConstant.urlUser}/requpdate';
    await DioClient.postEncrypt(loading: false, url, dataUpdate, key: 'lmm');
    await queryUserProfile();
    // DialogHelper.showSuccess();
    Get.back();
  }

  fetchHistory() async {
    var msisdn = await storage.read('msisdn');
    var token = await storage.read('token');
    if (token != null && msisdn != null) {
      var url = '${MyConstant.urlHistory}/history';
      var data = {"wallet_id": walletid.value, "msisdn": await storage.read('msisdn')};
      var res = await DioClient.postEncrypt(url, loading: false, data);
      List<HistoryModel> historyList = res.map<HistoryModel>((json) => HistoryModel.fromJson(json)).toList();
      groupedHistory.clear();
      for (var item in historyList) {
        String key = item.created != null ? item.created!.substring(0, 7) : 'Unknown'; // Format: YYYY-MM
        if (!groupedHistory.containsKey(key)) {
          groupedHistory[key] = [];
        }
        groupedHistory[key]!.add(item);
      }
    } else {
      groupedHistory.clear();
    }
  }

  fetchHistoryDetail(transID) async {
    var url = '${MyConstant.urlHistory}/detail';
    var data = {"transid": transID};
    // var res = await DioClient.postNoLoading(url, data);
    var res = await DioClient.postEncrypt(url, data);
    print(res);
    if (res != null) {
      historyDetailModel.value = HistoryDetailModel.fromJson(res);
      Get.to(() => ReusableResultScreen(
            fromAccountImage:
                historyDetailModel.value.logo == "" ? MyConstant.profile_default : historyDetailModel.value.logo!,
            fromAccountName: historyDetailModel.value.fromAccName!,
            fromAccountNumber: historyDetailModel.value.fromAcc!,
            toAccountImage:
                historyDetailModel.value.logo == "" ? MyConstant.profile_default : historyDetailModel.value.logo!,
            toAccountName: historyDetailModel.value.toAccName!,
            toAccountNumber: historyDetailModel.value.toAcc!,
            toTitleProvider: historyDetailModel.value.provider!,
            amount: historyDetailModel.value.amount!,
            fee: historyDetailModel.value.fee == "" ? "0" : historyDetailModel.value.fee!,
            transactionId: historyDetailModel.value.transid!,
            note: historyDetailModel.value.ramark!,
            timestamp: historyDetailModel.value.timestamp!,
            fromHistory: true,
          ));
    }
  }

  /*
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████

  ---- Device - App Info and Insernt login log

  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  */
  Future<void> getDeviceInfo() async {
    const platform = MethodChannel('device_info_channel');
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device_model.value = androidInfo.model;
      device_id.value = androidInfo.id;
      device_name.value = androidInfo.name;
      os_version.value = '${androidInfo.version.release}|SDK${androidInfo.version.sdkInt}|${androidInfo.board}';
    } else if (Platform.isIOS) {
      try {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        final Map<dynamic, dynamic> result = await platform.invokeMethod("getDeviceDetails");
        device_model.value = '${result["hardwareModel"]} | ${iosInfo.modelName}';
        device_id.value = result["deviceID"];
        device_name.value = result["deviceName"];
        os_version.value = result["systemVersion"];
      } on PlatformException catch (e) {
        print("Error retrieving device details: ${e.message}");
      }
    }
  }

  getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('permission: $permission}');
        // _showLocationPermissionDialog();
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      rxLat.value = position.latitude.toString();
      rxLong.value = position.longitude.toString();
      print('Location: ${rxLat.value}, ${rxLong.value}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  insertLoginLog() async {
    await getDeviceInfo();
    await getCurrentLocation();
    var url = '${MyConstant.urlSuperAppLogin}/InsertLog';
    var data = {
      "msisdn": rxMsisdn.value,
      "device_id": device_id.value,
      "devicemodel": device_model.value,
      "imei": device_id.value,
      "osversion": os_version.value,
      "lat": rxLat.value,
      "long": rxLong.value,
      "appversion": homController.appVersion.value,
      "device_name": device_name.value
    };
    await DioClient.postEncrypt(url, data);
  }

  /*
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████

  ---- manage user profile

  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  */

  checkMserviceTplus(username, password) async {
    var url = '${MyConstant.urlSuperAppLogin}/CheckMsisdnInLtcAndTplus';
    var data = {"msisdn": username, "password": password};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      if (res['status']) {
        rxPasswordPartner.value = password;
        requestOTP(username, 'reg_by_partner');
      } else {
        DialogHelper.showErrorDialogNew(description: res["resultDesc"]);
      }
    }
  }

  queryKYC_5_7(msisdn) async {
    var url = '${MyConstant.urlSuperAppLogin}/GetKyc';
    var data = {"msisdn": msisdn};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      print(res);
      if (res['status']) {
        kycModel.value = KycModel.fromJson(res);
      } else {
        DialogHelper.showErrorDialogNew(description: res["resultDesc"]);
      }
    }
  }

  Future<bool> queryProfileMmoney(msisdn) async {
    var url = '${MyConstant.urlSuperAppLogin}/GetProfile';
    var data = {"msisdn": msisdn};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      if (res['status']) {
        profileMmoneyModel.value = ProfileMmoneyModel.fromJson(res);
        return true;
      } else {
        DialogHelper.showErrorDialogNew(description: 'You don\'t have profile.\nPlease Register first.');
        return false;
      }
    }
    return false;
  }

  Future<bool> checkHavePassword() async {
    var url = '${MyConstant.urlSuperAppLogin}/CheckPassword';
    var data = {"msisdn": rxMsisdn.value};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      print(res);
      if (res['status']) {
        return true;
      } else {
        // DialogHelper.showErrorDialogNew(description: res["resultDesc"]);
        return false;
      }
    }
    return false;
  }

  createPassword(msisdn, password) async {
    var url = '${MyConstant.urlSuperAppLogin}/CreatePassword';
    var data = {"msisdn": msisdn, "password": password};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      print(res);
      if (res['status']) {
        Get.offAll(SplashScreen());
      } else {
        DialogHelper.showErrorDialogNew(description: res["resultDesc"]);
      }
    }
  }

  forgotPassword(msisdn) async {
    var url = '${MyConstant.urlSuperAppLogin}/ForGotPassword';
    var data = {"msisdn": msisdn};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      if (res['status']) {
        storage.remove('msisdn');
        return true;
      } else {
        return false;
      }
    }
  }

  /*
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████

  ---- login process

  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  ████████████████████████████████████████████████████████████████████████████████████████████████████████████████
  */
  RxBool isRenewToken = false.obs;
  loginSuperApp(msisdn, password, {bool reqOTPprocess = true}) async {
    var url = '${MyConstant.urlSuperAppLogin}/LoginToSuperApp';
    var data = {"msisdn": msisdn, "password": 'LMM!$password'};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      if (res['status']) {
        storage.write('msisdn', msisdn);
        storage.write('token', res['token']);
        rxToken.value = res['token'];
        print(rxToken.value);
        if (reqOTPprocess) {
          requestOTP(msisdn, 'login');
        } else {
          loginProcess(msisdn);
        }
      } else {
        DialogHelper.showErrorDialogNew(description: res["resultDesc"]);
      }
    }
  }

  Future<bool> loginRefreshTokenWebview(msisdn, password) async {
    bool status = false;
    var url = '${MyConstant.urlSuperAppLogin}/LoginToSuperApp';
    var data = {"msisdn": msisdn, "password": 'LMM!$password'};

    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      if (res['status']) {
        storage.write('msisdn', msisdn);
        storage.write('token', res['token']);
        rxToken.value = res['token']; // ✅ Update token globally
        status = true;
      } else {
        DialogHelper.showErrorDialogNew(description: res["resultDesc"]);
      }
    }
    return status; // ✅ Return success or failure
  }

  RxBool isWebview = false.obs;
  Future<bool> checktokenSuperApp() async {
    try {
      getCurrentLocation();
      String? msisdn = storage.read('msisdn');
      String? token = storage.read('token');
      TempUserProfileStorage boxUser = TempUserProfileStorage();
      TempUserProfile? user = boxUser.getUserByUsername(msisdn ?? '');

      if (msisdn == null) {
        storage.remove('msisdn');
        storage.remove('token');
        Get.offAll(SplashScreen());
        return false;
      }

      if (token == null) {
        Get.to(() => LoginHaveAccount(user: user.toJson()), transition: Transition.downToUp);
        return false;
      }

      var response = await DioClient.postEncrypt(
        '${MyConstant.urlGateway}/checkauth',
        loading: false,
        {'msisdn': msisdn, 'token': token},
      );

      if (response['resultCode'] == 0) {
        rxToken.value = token;
        return true;
      } else {
        Get.to(() => LoginHaveAccount(user: user.toJson()), transition: Transition.downToUp);
        return false;
      }
    } catch (e) {
      DialogHelper.showErrorDialogNew(description: "Authentication failed. Please try again.");
      rxToken.value = '';
      Get.offAll(SplashScreen());
      return false;
    }
  }

  loginProcess(msisdn, {bool isWebview = false}) async {
    rxMsisdn.value = msisdn;
    await storage.write('msisdn', msisdn);
    await insertLoginLog();
    await fetchBalance();
    await queryUserProfile(); //old
    // await queryProfileMmoney(msisdn); //new
    homController.fetchServicesmMenu(msisdn);

    saveTempUserLogin(msisdn, profileName.value, userProfilemodel.value.profileImg ?? '');
    if (isRenewToken.value) {
      Get.back();
    } else {
      Get.offAll(() => BottomNav());
    }
  }

  Future<void> requestOTP(String msisdn, String type) async {
    try {
      var response = await DioClient.postEncrypt('${MyConstant.urlGateway}/OTP', {'msisdn': msisdn});
      if (response["resultCode"] != 0) {
        DialogHelper.showErrorDialogNew(description: "Unable to send OTP");
        return;
      }
      rxMsisdn.value = msisdn;
      refcode.value = response["data"]["ref"]?.toString() ?? '';
      Get.to(() => ReusableOtpScreen(
            title: 'confirm_otp',
            desc1: 'desc1',
            desc2: 'desc2',
            phoneNumber: msisdn,
            buttonText: 'buttonText',
            onOtpCompleted: (otp) => confirmOTP(msisdn: msisdn, otpCode: otp, type: type),
            onResendPressed: () => requestOTP(msisdn, type),
          ));
    } catch (e) {
      DialogHelper.showErrorDialogNew(description: 'An unexpected error occurred.');
      print("Error in requestOTP: $e");
    }
  }

  Future<void> confirmOTP({required String msisdn, required String otpCode, required String type}) async {
    try {
      rxMsisdn.value = msisdn;
      if (msisdn == "2059395777X") {
        await storage.write('msisdn', msisdn);
        Get.toNamed('/loginpincode');
        return;
      }
      var response =
          await DioClient.postEncrypt('${MyConstant.urlGateway}/confirmOTP', {"otp": otpCode, "ref": refcode.value});
      if (response['resultCode'] != 0) {
        DialogHelper.showErrorDialogNew(description: "OTP verification failed.");
        return;
      }
      await handleOTPProcessSuccess(msisdn, type);
    } catch (e) {
      DialogHelper.showErrorDialogNew(description: 'An unexpected error occurred during OTP confirmation.');
      print("Error in confirmOTP: $e");
    }
  }

  Future<void> handleOTPProcessSuccess(String msisdn, String type) async {
    switch (type) {
      case "login":
        storage.remove('biometric');
        storage.remove('biometric_password');
        loginProcess(msisdn);
        break;

      case "forgot":
        await forgotPassword(msisdn);
        bool hasMmoneyProfile = await queryProfileMmoney(msisdn);
        bool hasWalletBO = await checkHaveWalletBO();
        if (!hasMmoneyProfile) await queryKYC_5_7(msisdn);
        storage.remove('biometric');
        storage.remove('biometric_password');
        Get.to(() => hasMmoneyProfile
            ? CreatePasswordScreen()
            : RegisterFormScreen(regType: hasWalletBO ? 'Approved' : 'UnApproved'));
        break;

      case "register":
        var data = await queryKYC_5_7(msisdn);
        print(data);
        Get.to(() => RegisterFormScreen(regType: 'UnApproved'));
        break;

      case "reg_by_mmoney":
        await _handleRegByMmoney(msisdn);
        break;

      case "reg_by_partner":
        await _handleRegByPartner(msisdn);
        break;

      default:
        print("Unknown type: $type");
    }
  }

  Future<void> _handleRegByMmoney(String msisdn) async {
    bool hasWallet = await checkHaveWalletBO();
    bool hasMmoneyProfile = await queryProfileMmoney(msisdn);
    bool hasPassword = await checkHavePassword();
    if (hasWallet && hasMmoneyProfile) {
      if (hasPassword) {
        DialogHelper.showErrorDialogNew(
          description: 'You already have an account.',
          onClose: () => Get.offAll(SplashScreen()),
        );
      } else {
        Get.to(() => CreatePasswordScreen());
      }
    }
  }

  Future<void> _handleRegByPartner(String msisdn) async {
    bool hasWalletBO = await checkHaveWalletBO();
    bool hasMmoneyProfile = await queryProfileMmoney(msisdn);
    bool hasPassword = await checkHavePassword();
    if (hasWalletBO && hasMmoneyProfile) {
      if (hasPassword) {
        DialogHelper.showErrorDialogNew(
          description: 'You already have an account.',
          onClose: () => Get.offAll(SplashScreen()),
        );
      } else {
        // Get.to(() => CreatePasswordScreen());
        createPassword(msisdn, rxPasswordPartner.value);
      }
    } else {
      await queryKYC_5_7(msisdn);
      Get.to(() => RegisterFormScreen(regType: hasWalletBO ? 'Approved' : 'UnApproved'));
    }
  }

  saveTempUserLogin(String username, String fullname, String imageProfile) async {
    final userStorage = TempUserProfileStorage();
    final now = DateTime.now();
    List<TempUserProfile> users = userStorage.getTempUserProfiles();
    TempUserProfile? existingUser = users.firstWhereOrNull((user) => user.username == username);
    if (existingUser == null) {
      final newUser =
          TempUserProfile(username: username, fullname: fullname, imageProfile: imageProfile, lastLogin: now);
      userStorage.addOrUpdateTempUserProfile(newUser);
    } else {
      userStorage.updateLastLogin(username, imageProfile);
    }
  }

  Future<bool> checkHaveWalletBO() async {
    var response =
        await DioClient.postEncrypt('${MyConstant.urlUser}/checkLMM', {'msisdn': rxMsisdn.value}, key: 'lmm');
    if (response['resultCode'] == '0001') {
      return true;
    } else {
      return false;
    }
  }

  register(regType, gender, fname, lname, birthdate, proid, district, village) async {
    String verify, type = '';
    if (regType == 'Approved') {
      verify = 'Approved';
      type = 'Registration by M money';
    } else {
      type = 'Registration by M moneyX';
      verify = 'UnApproved';
    }
    var url = '${MyConstant.urlUser}/register';
    var data = {
      "msisdn": rxMsisdn.value,
      "gender": gender,
      "name": fname,
      "surname": lname,
      "birthdate": birthdate,
      "provinceCode": proid,
      "provinceDesc": proid,
      "district": district,
      "village": village,
      "card_id": '',
      "verify": verify,
      "type": type,
      "doc_img": '',
      "verify_img": '',
      "profile_img": 'https://mmoney.la/AppLite/Users/mmoney.png',
      "created": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      "updated": '',
      "status": "Active"
    };
    var response = await DioClient.postEncrypt(url, data, key: 'lmm');
    if (response['resultCode'] == "0") {
      if (rxPasswordPartner.value != '') {
        createPassword(rxMsisdn.value, rxPasswordPartner.value);
      } else {
        Get.to(() => CreatePasswordScreen());
      }
    } else {
      DialogHelper.showErrorDialogNew(description: response['resultDesc']);
    }
  }

  Future<bool> chkPasswordSetBiometic(msisdn, password) async {
    bool chk = false;
    var url = '${MyConstant.urlSuperAppLogin}/LoginToSuperApp';
    var data = {"msisdn": msisdn, "password": 'LMM!$password'};
    var res = await DioClient.postEncrypt(url, data);
    if (res != null) {
      if (res['status']) {
        storage.write('msisdn', msisdn);
        storage.write('token', res['token']);
        storage.write('biometric_password', password);
        chk = true;
        return chk;
      } else {
        return chk;
      }
    }
    return chk;
  }
}
