// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/model-bank/ProviderBankModel.dart';
import 'package:super_app/models/model-bank/RecentBankModel.dart';
import 'package:super_app/models/model-bank/ReqCashoutBankModel.dart';
import 'package:super_app/services/helper/random.dart';
import '../../../services/api/dio_client.dart';
import '../../../utility/dialog_helper.dart';

class CashOutController extends GetxController {
  final storage = GetStorage();
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final logController = Get.put(LogController());
  RxList<ProviderBankModel> bankModel = <ProviderBankModel>[].obs;
  Rx<ProviderBankModel> bankDetail = ProviderBankModel().obs;
  RxList<RecentBankModel> recentModel = <RecentBankModel>[].obs;
  RxList<RecentBankModel> recentFetchModel = <RecentBankModel>[].obs;
  Rx<ReqCashoutBankModel> reqcashout = ReqCashoutBankModel().obs;

  RxString rxTransID = ''.obs;
  RxString rxAccNo = ''.obs;
  RxString rxAccName = ''.obs;
  RxString rxPaymentAmount = ''.obs;
  RxString rxFee = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxTimeStamp = ''.obs;

  RxBool loading = false.obs;

  //? Log
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  fetchBankList() async {
    // List<String> urlSplit =
    //     homeController.menudetail.value.url.toString().split(";");
    // var url = urlSplit[0];
    var url = "/Bank/getList";
    var response =
        await DioClient.postEncrypt(loading: false, url, key: 'lmm', {});
    bankModel.value = response
        .map<ProviderBankModel>((json) => ProviderBankModel.fromJson(json))
        .toList();
  }

  fetchRecentBank() async {
    try {
      // API URL
      var url = "/Bank/getRecent";

      // API Response
      var response = await DioClient.postEncrypt(
        loading: false,
        url,
        {
          "Msisdn": storage.read('msisdn'),
          "ReqID": bankDetail.value.requesterID,
        },
        key: 'lmm',
      );

      // Check if the response is valid
      if (response != null && response.isNotEmpty) {
        // Map response data to RecentBankModel
        List<RecentBankModel> fetchedData = response
            .map<RecentBankModel>((json) => RecentBankModel.fromJson(json))
            .toList();

        // Check favorites from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? favoriteDataString = prefs.getString('favoriteCashout');
        List<dynamic> favoriteDataList = [];
        if (favoriteDataString != null) {
          favoriteDataList = jsonDecode(favoriteDataString);
        }

        // Update favorite status
        for (var model in fetchedData) {
          model.favorite =
              favoriteDataList.any((fav) => fav['AccNo'] == model.accNo)
                  ? 1
                  : 0;
        }

        // Assign to recentModel
        recentModel.assignAll(fetchedData);

        // Debug print
        print("Account Name: ${recentModel.first.accName}");
        print("Account Number: ${recentModel.first.accNo}");
        print("ID: ${recentModel.first.id}");
        print("Favorite: ${recentModel.first.favorite}");
      } else {
        print("No recent bank data found.");
      }
    } catch (e) {
      print("Error fetching recent bank data: $e");
    }
  }

  verifyAcc(String accNo) async {
    rxAccNo.value = accNo;
    // List<String> urlSplit =
    //     homeController.menudetail.value.url.toString().split(";");

    // var url = urlSplit[2];
    var url = " /Bank/verify";

    rxTransID.value = await randomNumber().fucRandomNumberBank();
    var data = {
      "transactionId": rxTransID.value,
      "phoneNumber": storage.read('msisdn'),
      "fullName": "M-Money X",
      "accountNo": rxAccNo.value,
      "bid": bankDetail.value.bID,
      "amount": rxPaymentAmount.value
    };
    var response = await DioClient.postEncrypt(url, data, key: 'lmm');

    if (response['resultcode'] == "200") {
      rxAccName.value = response['accountName'];
      rxFee.value = response['fee'].toString();
      logVerify = response;
      loading.value = false;
      // Get.to(() => const ConfirmTransferBankScreen());
    } else {
      loading.value = false;
      DialogHelper.showErrorWithFunctionDialog(
          description: response['resultdesc']);
    }
  }

  confirmPayment() async {
    // userController.fetchbalance();
    // List<String> urlSplit =
    //     homeController.menudetail.value.url.toString().split(";");
    // var url = urlSplit[3];
    var url = " /Bank/reqCashOut";
    // int balance = int.parse(userController.balance.value.toString());
    int balance = 10000000;
    int payment_fee = int.parse(rxPaymentAmount.value.toString()) +
        int.parse(rxFee.value.toString());
    if (balance > payment_fee) {
      //
      var data = {
        "bid": bankDetail.value.bID,
        "amount": rxPaymentAmount.value.toString(),
        "PhoneUser": storage.read('msisdn'),
        "remark": rxNote.value,
        "TranID": rxTransID.value,
        "accountNo": rxAccNo.value
      };
      var response = await DioClient.postEncrypt(url, data, key: 'lmm');
      // print(response.toString());
      if (response["resultcode"] == "200") {
        reqcashout.value = ReqCashoutBankModel.fromJson(response);
        loading.value = false;
        // Get.to(() => const OtpTransferBankScreen());
      } else {
        loading.value = false;
        DialogHelper.showErrorWithFunctionDialog(
            description: response['resultdesc']);
      }
    } else {
      loading.value = false;
      DialogHelper.showErrorWithFunctionDialog(
          description: 'Your balance not enough.');
    }
  }

  confirmOtpPayment(otp) async {
    // List<String> urlSplit =
    //     homeController.menudetail.value.url.toString().split(";");
    // var url = urlSplit[4];
    var url = "/Bank/payment";
    var data = {
      "bid": bankDetail.value.bID,
      "accountNo": rxAccNo.value,
      "amount": rxPaymentAmount.value,
      "remark": rxNote.value,
      "PhoneUser": storage.read('msisdn'),
      "accountName": rxAccName.value,
      "reqestorName": bankDetail.value.requesterName,
      "data": {
        "apiToken": reqcashout.value.data!.apiToken!,
        "transID": reqcashout.value.data!.transID!,
        "requestorID": reqcashout.value.data!.requestorID!,
        "transCashOutID": reqcashout.value.data!.transCashOutID!,
        "otpRefCode": reqcashout.value.data!.otpRefCode!,
        "otpRefNo": reqcashout.value.data!.otpRefNo!,
        "otp": otp
      }
    };

    var response = await DioClient.postEncrypt(url, data, key: 'lmm');

    //! save log
    logPaymentReq = data;
    logPaymentRes = response;
    logController.insertAllLog(
      "homeController.menudetail.value.groupNameEN.toString()",
      rxTransID.value,
      bankDetail.value.logo,
      bankDetail.value.requesterName!,
      rxAccNo.value,
      rxAccName.value,
      rxPaymentAmount.value,
      0,
      rxFee.value,
      rxNote.value,
      logVerify,
      logPaymentReq,
      logPaymentRes,
    );
    if (response["resultcode"] == "200") {
      rxTimeStamp.value = response["CreateDate"];
      loading.value = false;
      // Get.to(() => const ResultTransferBankScreen());
    } else {
      loading.value = false;
      DialogHelper.showErrorWithFunctionDialog(
          description: response['resultdesc']);
    }
  }
}
