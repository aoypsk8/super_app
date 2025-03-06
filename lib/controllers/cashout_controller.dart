// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/ProviderBankModel.dart';
import 'package:super_app/models/RecentBankModel.dart';
import 'package:super_app/models/ReqCashoutBankModel.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/cashout/OtpTransferBankScreen.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
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
  Rx<ReqCashoutBankModel> reqcashout = ReqCashoutBankModel().obs;

  final RxBool enableBottom = true.obs;

  RxString rxTransID = ''.obs;
  RxString rxAccNo = ''.obs;
  RxString rxAccName = ''.obs;
  RxString rxPaymentAmount = ''.obs;
  RxString rxFee = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxTimeStamp = ''.obs;

  RxString rxCodeBank = ''.obs;
  RxString rxLogo = ''.obs;

  //? Log
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  fetchBankList() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[0];
    // var url = "/Bank/getList";
    var response =
        await DioClient.postEncrypt(loading: false, url, key: 'lmm', {});
    bankModel.value = response
        .map<ProviderBankModel>((json) => ProviderBankModel.fromJson(json))
        .toList();
  }

  fetchRecentBank() async {
    try {
      List<String> urlSplit =
          homeController.menudetail.value.url.toString().split(";");
      var url = urlSplit[1];
      // var url = "/Bank/getRecent";
      var response = await DioClient.postEncrypt(
        loading: false,
        url,
        {
          "Msisdn": storage.read('msisdn'),
          "ReqID": bankDetail.value.requesterID,
        },
        key: 'lmm',
      );
      if (response != null && response.isNotEmpty) {
        List<RecentBankModel> fetchedData = response
            .map<RecentBankModel>((json) => RecentBankModel.fromJson(json))
            .toList();
        // Retrieve SharedPreferences instance
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('historyCashout');
        // Get favoriteCashout data from localStorage
        String? favoriteDataString = prefs.getString('favoriteCashout');
        List<dynamic> favoriteDataList = [];
        if (favoriteDataString != null) {
          favoriteDataList = jsonDecode(favoriteDataString);
        }
        // Create new data and update favorite status
        for (var model in fetchedData) {
          int favorite =
              favoriteDataList.any((fav) => fav['AccNo'] == model.accNo)
                  ? 1
                  : 0;
          Map<String, dynamic> newData = {
            'AccNo': model.accNo,
            'AccName': model.accName,
            'id': rxCodeBank.value,
            'favorite': favorite,
            'logo': rxLogo.value
          };
          // Get existing historyCashout data
          String? historyDataString = prefs.getString('historyCashout');
          List<dynamic> historyDataList = [];
          if (historyDataString != null) {
            historyDataList = jsonDecode(historyDataString);
          }
          // Add new data to historyCashout
          historyDataList.add(newData);
          // Save updated historyCashout to localStorage
          prefs.setString('historyCashout', jsonEncode(historyDataList));
          print("New data added to historyCashout: $newData");
        }
      }
    } catch (e) {
      print("Error fetching recent bank data: $e");
    }
  }

  verifyAcc(String accNo) async {
    rxAccNo.value = accNo;
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[2];
    // var url = "/Bank/verify";
    rxTransID.value = await randomNumber().fucRandomNumberBank();
    var data = {
      "transactionId": rxTransID.value,
      "phoneNumber": await storage.read('msisdn'),
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
      enableBottom.value = true;
      Get.to(
        () => ReusableConfirmScreen(
          appbarTitle: homeController.getMenuTitle(),
          function: () {
            enableBottom.value = false;
            confirmPayment();
          },
          isEnabled: enableBottom,
          stepProcess: "3/3",
          stepTitle: "check_detail",
          fromAccountImage: userController.userProfilemodel.value.profileImg ??
              MyConstant.profile_default,
          fromAccountName:
              '${userController.userProfilemodel.value.name.toString()} ${userController.userProfilemodel.value.surname.toString()}',
          fromAccountNumber:
              userController.userProfilemodel.value.msisdn.toString(),
          toAccountImage: rxLogo.value,
          toAccountName: rxAccNo.toString(),
          toAccountNumber: rxAccName.toString(),
          amount: rxPaymentAmount.value,
          fee: rxFee.value,
          note: rxNote.value,
        ),
      );
    } else {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: response['resultdesc']);
    }
  }

  confirmPayment() async {
    userController.fetchBalance();
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[3];
    // var url = "/Bank/reqCashOut";
    int balance = int.parse(userController.mainBalance.value.toString());
    int payment_fee = int.parse(rxPaymentAmount.value.toString()) +
        int.parse(rxFee.value.toString());
    if (balance > payment_fee) {
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
        enableBottom.value = true;
        Get.to(() => const OtpTransferBankScreen());
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorDialogNew(description: response['resultdesc']);
      }
    } else {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }

  confirmOtpPayment(otp) async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[4];
    // var url = "/Bank/payment";
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
      homeController.menudetail.value.groupNameEN.toString(),
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

      Get.to(ReusableResultScreen(
        fromAccountImage: userController.userProfilemodel.value.profileImg ??
            MyConstant.profile_default,
        fromAccountName: userController.profileName.value,
        fromAccountNumber: userController.rxMsisdn.value,
        toAccountImage: rxLogo.value,
        toAccountName: rxAccName.value,
        toAccountNumber: rxAccName.value,
        toTitleProvider: '',
        amount: rxPaymentAmount.value,
        fee: rxFee.value,
        transactionId: rxTransID.value,
        note: rxNote.value,
        timestamp: rxTimeStamp.value,
      ));
    } else {
      DialogHelper.showErrorDialogNew(description: response['resultdesc']);
    }
  }
}
