// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/models/appinfo_model.dart';
import 'package:super_app/models/balance_model.dart';
import 'package:super_app/models/user_profile_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

import '../models/model-history/history_model.dart';

class UserController extends GetxController with WidgetsBindingObserver {
  final storage = GetStorage();
  RxString walletid = ''.obs;
  RxString profileName = ''.obs;
  RxString birthday = ''.obs;
  RxString rxBirthday = ''.obs;

  // profile
  Rx<UserProfileModel> userProfilemodel = UserProfileModel().obs;

  // balance
  Rx<BalanceModel> balanceModel = BalanceModel().obs;
  RxInt totalBalance = 0.obs;
  RxInt mainBalance = 0.obs;
  RxInt pointBalance = 0.obs;

  RxBool isLogin = false.obs;
  RxBool isCheckToken = false.obs;

  //auth
  RxString rxMsisdn = '2052768833'.obs;

  RxString rxLat = ''.obs;
  RxString rxLong = ''.obs;

  RxString rxToken = ''.obs;
  RxString rxEmail = ''.obs;
  RxString refcode = ''.obs;

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

  Future checktoken({String? name}) async {
    getCurrentLocation();
  }

  @override
  void onReady() async {
    super.onReady();
    String wallet = '2052555999';
    storage.write('msisdn', wallet);
    rxMsisdn.value = storage.read('msisdn');
    await loginpincode(wallet, '555555');
    await fetchBalance();
    await queryUserProfile();
  }

  Future<void> loginpincode(String msisdn, String pincode) async {
    try {
      final response = await DioClient.postEncrypt('${MyConstant.urlGateway}/login', {"msisdn": msisdn, "pin": pincode});
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

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied. Please enable it in settings.");
        return;
      }
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );
      // Update latitude and longitude
      rxLat.value = currentPosition.latitude.toString();
      rxLong.value = currentPosition.longitude.toString();
      print('Latitude: ${rxLat.value}, Longitude: ${rxLong.value}');
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchBalance() async {
    try {
      // Retrieve token and msisdn from storage
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
      var token = await storage.read('token');
      var msisdn = await storage.read('msisdn');
      if (token == null || msisdn == null) {
        print('Error: Missing token or msisdn');
        return;
      }
      var url = '${MyConstant.urlUser}/query';
      var data = {"msisdn": msisdn};
      var response = await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
      if (response != null) {
        userProfilemodel.value = UserProfileModel.fromJson(response);
        profileName.value = '${userProfilemodel.value.name} ${userProfilemodel.value.surname}';
      } else {
        print('Error: Response is null');
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
    var response = await DioClient.postEncrypt('${MyConstant.urlLoginByEmail}/GetMsisdn', {'email': rxEmail.value, 'birthday': rxBirthday.value});
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
    queryUserProfile();
    // DialogHelper.showSuccess();
    Get.back();
  }

  RxList<HistoryModel> historylists = <HistoryModel>[].obs;
  RxMap<String, List<HistoryModel>> groupedHistory = <String, List<HistoryModel>>{}.obs;
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
}
