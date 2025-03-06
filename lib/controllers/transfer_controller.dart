// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/menu_model.dart';
import 'package:super_app/models/UserKycModel.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
import '../services/helper/random.dart';
import '../services/api/dio_client.dart';
import '../utility/myconstant.dart';
import 'package:intl/intl.dart';

class TransferController extends GetxController {
  final userController = Get.find<UserController>();
  final homeController = Get.find<HomeController>();
  Rx<UserKycModel> desTranferKyc = UserKycModel().obs;
  final logController = Get.put(LogController());
  final storage = GetStorage();
  Logger logger = Logger();

  ///
  RxString destinationMsisdn = ''.obs;
  RxString destinationname = ''.obs;
  RxString amount = ''.obs;
  RxString note = ''.obs;
  RxString rxtransid = ''.obs;
  RxString rxtimestamp = ''.obs;

  final RxBool enableBottom = true.obs;
  //? Log
  var logVerifyRes;
  var logPaymentReq;
  var logPaymentRes;

  clear() async {
    destinationMsisdn.value = '';
    // print('from clear destinationMsisdn ${destinationMsisdn.value}');
    // destinationMsisdn.refresh();
    destinationname.value = '';
    amount.value = '';
    note.value = '';
    rxtransid.value = '';
    rxtimestamp.value = '';
    logVerifyRes = null;
    logPaymentReq = null;
    logPaymentRes = null;
  }

  Future<void> vertifyWallet(
      String desMsisdn, String transferAmount, String transferNote) async {
    try {
      // Step 1: Verify Wallet
      String url = '${MyConstant.urlConsumerInfo}/UserInfo';
      var response = await DioClient.postEncrypt(
          url, loading: false, {"msisdn": desMsisdn}, key: 'lmm-key');
      await desTransferKyc(desMsisdn); // Perform additional checks if required.

      if (response["responseCode"] == "0000") {
        // Wallet verification successful
        destinationMsisdn.value = desMsisdn;
        destinationname.value = "${response["name"]} ${response["surname"]}";
        amount.value = transferAmount;
        note.value = transferNote;
        logVerifyRes = response;
        // Step 2: Check Balance

        var balanceResponse = await DioClient.postEncrypt(
            '${MyConstant.urlLoginByEmail}/CheckBalance',
            {"msisdn": userController.rxMsisdn.value, "amount": amount.value});

        var getemail = await storage.read("emailLocal");
        userController.rxEmail.value = getemail ?? "";

        if (balanceResponse['success'] == false &&
            userController.rxMsisdn.value.startsWith("204")) {
          var otpDatas = {
            'email': userController.rxEmail.value,
            'birthday': userController.birthday.value
          };

          var otpResponse = await DioClient.postEncrypt(
              '${MyConstant.urlLoginByEmail}/GetMsisdn', otpDatas);

          if (otpResponse["resultCode"] == 0) {
            userController.refcode.value =
                otpResponse["data"]["ref"].toString();
            enableBottom.value = true;
            Get.toNamed('/otpTransferEmail');
          } else {
            enableBottom.value = true;
            // Handle OTP sending failure
            DialogHelper.showErrorDialogNew(
                description: otpResponse["resultDesc"].toString());
          }
        } else if (balanceResponse['success'] == false) {
          var otpData = {
            'msisdn': userController.rxMsisdn.value,
            'birthday': userController.birthday.value
          };
          var otpResponse = await DioClient.postEncrypt(
              '${MyConstant.urlGateway}/signup', otpData);

          if (otpResponse["resultCode"] == 0) {
            enableBottom.value = true;
            // OTP sent successfully
            userController.refcode.value =
                otpResponse["data"]["ref"].toString();
            // Navigate to OtpTransferScreen
            Get.toNamed('/otpTransfer');
          } else {
            enableBottom.value = true;
            // Handle OTP sending failure
            DialogHelper.showErrorDialogNew(
                description: otpResponse["resultDesc"].toString());
          }
        } else {
          enableBottom.value = true;
          Get.to(ListsPaymentScreen(
            description: 'select_payment',
            stepBuild: '2/3',
            title: homeController.getMenuTitle(),
            onSelectedPayment: (paymentType, cardIndex) {
              Get.to(
                () => ReusableConfirmScreen(
                  appbarTitle: homeController.getMenuTitle(),
                  function: () {
                    enableBottom.value = false;
                    transfer(homeController.menudetail.value);
                  },
                  isEnabled: enableBottom,
                  stepProcess: "3/3",
                  stepTitle: "check_detail",
                  fromAccountImage:
                      userController.userProfilemodel.value.profileImg ??
                          MyConstant.profile_default,
                  fromAccountName:
                      '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}',
                  fromAccountNumber:
                      userController.userProfilemodel.value.msisdn.toString(),
                  toAccountImage: desTranferKyc.value.profileImg ??
                      MyConstant.profile_default,
                  toAccountName: destinationname.value,
                  toAccountNumber: destinationMsisdn.value,
                  amount: amount.value,
                  fee: '0',
                  note: note.value,
                ),
              );
            },
          ));
        }
      } else {
        enableBottom.value = true;
        // Wallet verification failed
        DialogHelper.showErrorDialogNew(
            description: response["responseMessage"]);
      }
    } catch (e) {
      enableBottom.value = true;
      // Handle unexpected errors
      DialogHelper.showErrorDialogNew(
          description: 'An unexpected error occurred. Please try again.');
      print("Error in vertifyWallet: $e");
    }
  }

  desTransferKyc(msisdn) async {
    desTranferKyc = UserKycModel().obs;
    var url = '${MyConstant.urlUser}/query';
    var data = {"msisdn": msisdn};
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
    if (response != null) {
      if (response["resultCode"] != "1") {
        desTranferKyc.value = UserKycModel.fromJson(response);
      }
    }
  }

  fetchbalance(
      String desMsisdn, String transferAmount, String transferNote) async {
    var url = '${MyConstant.urlGateway}/getBalance';
    var data = {"msisdn": desMsisdn, "type": MyConstant.desRoute};
    var response = await DioClient.postEncrypt(url, loading: false, data);
    if (response["resultCode"] == 0) {
      destinationMsisdn.value = desMsisdn;
      destinationname.value = response["data"]["firstname"];
      amount.value = transferAmount;
      note.value = transferNote;
      // transfer ConfirmTranferScreen
      Get.toNamed('/confirmTransfer');
    } else {
      DialogHelper.showErrorDialogNew(description: response["resultDesc"]);
    }
  }

  transfer(Menulists menulist) async {
    final menuWithAppId14 = homeController.menuModel.value.firstWhere(
      (menu) => menu.menulists!.any((item) => item.appid == 14),
    );
    if (menuWithAppId14 != null) {
      final matchedItem =
          menuWithAppId14.menulists!.firstWhere((item) => item.appid == 14);
      homeController.menutitle.value = matchedItem.groupNameEN!;
      homeController.menudetail.value = matchedItem;
    }
    try {
      List<String> urlSplit =
          homeController.menudetail.value.url.toString().split(";");
      rxtransid.value = menulist.description.toString() +
          await randomNumber().fucRandomNumber();
      var data = {
        "transID": rxtransid.value,
        "transAmount": amount.value,
        "msisdnOut": storage.read('msisdn'),
        "msisdnIn": destinationMsisdn.value,
        "remark": note.value,
        "type": MyConstant.desRoute,
        "token": userController.rxToken.value
      };

      /*
      ╔═.✵.═════════════════════════════════════════════════════════════════════════════════════╗
      »»————————————————————————————————⚠️ old ⚠️—————————————————————————————————————————————««
      */
      // var response = await DioClient.postEncrypt(urlSplit[0], data, key: "");
      var response = await DioClient.postEncrypt(urlSplit[0], data, key: "");
      if (response["resultCode"].toString() == '0') {
        //! save log
        logPaymentReq = data;
        logPaymentRes = response;
        logController.insertAllLog(
          homeController.menudetail.value.groupNameEN.toString(),
          rxtransid.value,
          '',
          '',
          destinationMsisdn.value,
          destinationname.value,
          amount.value,
          0,
          '',
          note.value,
          logVerifyRes,
          logPaymentReq,
          logPaymentRes,
        );

        saveHistoryTransfer(destinationMsisdn.value, destinationname.value,
            desTranferKyc.value.profileImg ?? MyConstant.profile_default);
        userController.fetchBalance();
        rxtimestamp.value =
            DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
        enableBottom.value = true;

        Get.to(ReusableResultScreen(
          fromAccountImage: userController.userProfilemodel.value.profileImg ??
              MyConstant.profile_default,
          fromAccountName: userController.profileName.value,
          fromAccountNumber: userController.rxMsisdn.value,
          toAccountImage:
              desTranferKyc.value.profileImg ?? MyConstant.profile_default,
          toAccountName: destinationname.value,
          toAccountNumber: destinationMsisdn.value,
          toTitleProvider: '',
          amount: amount.value,
          fee: '0',
          transactionId: rxtransid.value,
          note: note.value,
          timestamp: rxtimestamp.value,
        ));
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorDialogNew(description: response["resultDesc"]);
      }
    } catch (e) {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: e.toString());
    }
  }

  void saveHistoryTransfer(
      String walletno, String walletname, String profile_user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myDataString = prefs.getString('historyTransfer');
    if (myDataString == null) {
      var myData0 = [
        {
          'timeStamp': DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
          'walletNo': walletno,
          'profile_user': profile_user,
          'walletName': walletname,
          'favorite': 0,
        }
      ];
      prefs.setString('historyTransfer', json.encode(myData0));
    } else {
      List<Map<String, dynamic>> myData =
          (json.decode(myDataString ?? '') as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
      bool exists = false;
      for (var item in myData) {
        if (item['walletNo'] == walletno) {
          item['timeStamp'] =
              DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
          exists = true;
          break;
        }
      }
      if (!exists) {
        myData.add({
          'timeStamp': DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
          'walletNo': walletno,
          'profile_user': profile_user,
          'walletName': walletname,
          'favorite': 0,
        });
      }
      prefs.setString('historyTransfer', json.encode(myData));
    }
  }
}
