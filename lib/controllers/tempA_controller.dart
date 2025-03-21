// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/menu_model.dart';
import 'package:super_app/models/provider_tempA_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
import 'package:super_app/views/templateA/payment_tempA.dart';
import 'package:super_app/views/templateA/result_tempA.dart';

class TempAController extends GetxController {
  final userController = Get.find<UserController>();
  RxList<ProviderTempAModel> tempAmodel = <ProviderTempAModel>[].obs;
  Rx<ProviderTempAModel> tempAdetail = ProviderTempAModel().obs;
  RxList<Map<String, Object?>> provsep = <Map<String, Object?>>[].obs;
  RxList<RecentTempAModel> recentTempA = <RecentTempAModel>[].obs;
  final paymentController = Get.put(PaymentController());
  final storage = GetStorage();
  final homeController = Get.find<HomeController>();

  RxString rxaccnumber = ''.obs;
  RxString rxaccname = ''.obs;
  RxString debit = ''.obs;
  RxString rxtransid = ''.obs;
  RxString rxtimestamp = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxFee = ''.obs;
  RxString rxPaymentAmount = ''.obs;
  final RxBool enableBottom = true.obs;

  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  var isLoading = false.obs;
  // menudetail.url = 'https://electricx.mmoney.la/getList;https://electricx.mmoney.la/verify;https://electricx.mmoney.la/payment;https://electricx.mmoney.la/getRecent;https://electricx.mmoney.la/history;';

  Future<void> fetchTempAList() async {
    try {
      List<String> urlSplit = homeController.menudetail.value.url!.split(";");
      if (urlSplit.isEmpty || urlSplit[0].isEmpty) {
        throw Exception("Malformed URL: Unable to extract the first URL part.");
      }
      var url = urlSplit[0];
      var response =
          await DioClient.postEncrypt(loading: false, url, key: 'lmm', {});
      if (response == null || response.isEmpty) {
        throw Exception("Empty or invalid response received from API.");
      }
      tempAmodel.value = response
          .map<ProviderTempAModel>((json) => ProviderTempAModel.fromJson(json))
          .toList();
      final part = tempAmodel.map((e) => e.part).toSet().toList();
      provsep.value = part.map((e) {
        return {
          "partid": e,
          "data": tempAmodel.where((res) => res.part == e).toList()
        };
      }).toList();
    } catch (e, stackTrace) {
      print("Error in fetchTempAList: $e");
      print(stackTrace);
    }
  }

  fetchrecent() async {
    enableBottom.value = true;
    List<String> urlSplit = homeController.menudetail.value.url!.split(";");
    if (urlSplit.isEmpty || urlSplit[0].isEmpty) {
      throw Exception("Malformed URL: Unable to extract the first URL part.");
    }
    var response = await DioClient.postEncrypt(
        loading: false,
        urlSplit[3],
        {
          "Msisdn": storage.read('msisdn'),
          "ProviderID": tempAdetail.value.code
        },
        key: 'lmm');
    recentTempA.value = response
        .map<RecentTempAModel>((json) => RecentTempAModel.fromJson(json))
        .toList();
  }

  Future<void> debitProcess(String accNumber) async {
    try {
      rxtransid.value =
          "${homeController.menudetail.value.description!}${await randomNumber().fucRandomNumber()}";
      final urlSplit = homeController.menudetail.value.url?.split(";") ?? [];
      final apiUrl = urlSplit[1];
      final payload = {
        "TransactionID": "",
        "PhoneUser": storage.read('msisdn'),
        "AccNo": accNumber,
        "EWid": tempAdetail.value.eWid,
        "Remark": "",
      };
      final response = await DioClient.postEncrypt(apiUrl, payload, key: 'lmm');
      if (response['ResultCode'] == "200") {
        rxaccname.value = response['AccName'] ?? "Unknown";
        rxaccnumber.value = accNumber;
        debit.value = response['Debit'] ?? 0;
        rxFee.value = tempAdetail.value.fee!;
        enableBottom.value = true;
        Get.to(() => PaymentTempAScreen());
      } else {
        enableBottom.value = true;
        // Show error dialog with the result description
        DialogHelper.showErrorDialogNew(
            description: response['ResultDesc'] ?? "Unknown error occurred");
      }
    } catch (e, stackTrace) {
      enableBottom.value = true;
      print("Error in debitProcess: $e");
      print("StackTrace: $stackTrace");
    }
  }

  paymentprocess(String amount) async {
    if (userController.totalBalance.value >= int.parse(rxPaymentAmount.value)) {
      PaymentController paymentController = Get.find<PaymentController>();
      var data;
      var url;
      var response;
      if (await paymentController.confirmCashOut()) {
        List<String> urlSplit =
            homeController.menudetail.value.url?.split(";") ?? [];
        url = urlSplit[2];
        data = {
          "AccName": rxaccname.value,
          "TransactionID": rxtransid.value,
          "AccNo": rxaccnumber.value,
          "Amount": amount,
          "EWid": tempAdetail.value.eWid,
          "ProCode": tempAdetail.value.code,
          "PhoneUser": storage.read('msisdn'),
          "Title": homeController.menudetail.value.groupNameEN,
          "Remark": ''
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmm');

        //! save log
        await saveLogTempA(data, response, amount);
        if (response['ResultCode'] == '200') {
          rxtimestamp.value = response['CreateDate'];
          rxPaymentAmount.value = amount;
          enableBottom.value = true;
          Get.to(() => ReusableResultScreen(
              fromAccountImage:
                  userController.userProfilemodel.value.profileImg!,
              fromAccountName: userController.profileName.value,
              fromAccountNumber: userController.userProfilemodel.value.msisdn!,
              toAccountImage: tempAdetail.value.logo!,
              toAccountName: rxaccname.value,
              toAccountNumber: rxaccnumber.value,
              toTitleProvider: tempAdetail.value.title!,
              amount: rxPaymentAmount.value,
              fee: rxFee.value,
              transactionId: rxtransid.value,
              note: rxNote.value,
              timestamp: rxtimestamp.value));
        } else {
          enableBottom.value = true;
          DialogHelper.showErrorDialogNew(description: response['ResultCode']);
        }
      }
    } else {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }

  Future<void> saveLogTempA(
      Map<String, dynamic> data, response, String amount) async {
    final logController = Get.put(LogController());
    logPaymentReq = data;
    logPaymentRes = response;
    await logController.insertAllLog(
      homeController.menudetail.value.groupNameEN.toString(),
      rxtransid.value,
      tempAdetail.value.logo!,
      tempAdetail.value.code,
      rxaccnumber.value,
      rxaccname.value,
      amount,
      0,
      tempAdetail.value.fee,
      rxNote.value,
      logVerify,
      logPaymentReq,
      logPaymentRes,
    );
  }

  //!
  //! VISA - MASTER CARD Template A
  //!------------------------------------------------------------------------------
  paymentprocessVisa(String amount, Menulists menudetail,
      String storedCardUniqueID, String cvvCode) async {
    var data;
    var url;
    var response;
    rxtransid.value =
        "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
    print(rxtransid.value);
    print(amount);
    if (await paymentController.paymentByVisaMasterCard(
      rxtransid.value,
      '',
      int.parse(amount),
      storedCardUniqueID,
      cvvCode,
    )) {
      List<String> urlSplit =
          homeController.menudetail.value.url?.split(";") ?? [];
      url = urlSplit[2];
      data = {
        "AccName": rxaccname.value,
        "TransactionID": rxtransid.value,
        "AccNo": rxaccnumber.value,
        "Amount": amount,
        "EWid": tempAdetail.value.eWid,
        "ProCode": tempAdetail.value.code,
        "PhoneUser": storage.read('msisdn'),
        "Title": homeController.menudetail.value.groupNameEN,
        "Remark": ''
      };
      response = await DioClient.postEncrypt(url, data, key: 'lmm');

      //! save log
      await saveLogTempA(data, response, amount);
      if (response['ResultCode'] == '200') {
        rxtimestamp.value = response['CreateDate'];
        rxPaymentAmount.value = amount;
        enableBottom.value = true;
        Get.to(() => ReusableResultScreen(
            fromAccountImage: userController.userProfilemodel.value.profileImg!,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.userProfilemodel.value.msisdn!,
            toAccountImage: tempAdetail.value.logo!,
            toAccountName: rxaccname.value,
            toAccountNumber: rxaccnumber.value,
            toTitleProvider: tempAdetail.value.title!,
            amount: rxPaymentAmount.value,
            fee: rxFee.value,
            transactionId: rxtransid.value,
            note: rxNote.value,
            timestamp: rxtimestamp.value));
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorDialogNew(description: response['ResultCode']);
      }
    } else {
      enableBottom.value = true;
    }
  }

  //!
  //! VISA - MASTER CARD Template A
  //!------------------------------------------------------------------------------
  // paymentprocessVisaWithoutstoredCardUniqueID(
  //     String amount, Menulists menudetail) async {
  //   var data;
  //   var url;
  //   var response;
  //   List<String> urlSplit =
  //       homeController.menudetail.value.url?.split(";") ?? [];
  //   url = urlSplit[2];
  //   data = {
  //     "AccName": rxaccname.value,
  //     "TransactionID": rxtransid.value,
  //     "AccNo": rxaccnumber.value,
  //     "Amount": amount,
  //     "EWid": tempAdetail.value.eWid,
  //     "ProCode": tempAdetail.value.code,
  //     "PhoneUser": storage.read('msisdn'),
  //     "Title": homeController.menudetail.value.groupNameEN,
  //     "Remark": ''
  //   };
  //   response = await DioClient.postEncrypt(url, data, key: 'lmm');

  //   //! save log
  //   await saveLogTempA(data, response, amount);
  //   if (response['ResultCode'] == '200') {
  //     rxtimestamp.value = response['CreateDate'];
  //     rxPaymentAmount.value = amount;
  //     enableBottom.value = true;
  //     Get.to(() => ReusableResultScreen(
  //         isUSD: true,
  //         fromAccountImage: userController.userProfilemodel.value.profileImg!,
  //         fromAccountName: userController.profileName.value,
  //         fromAccountNumber: userController.userProfilemodel.value.msisdn!,
  //         toAccountImage: tempAdetail.value.logo!,
  //         toAccountName: rxaccname.value,
  //         toAccountNumber: rxaccnumber.value,
  //         toTitleProvider: tempAdetail.value.title!,
  //         amount: rxPaymentAmount.value,
  //         fee: rxFee.value,
  //         transactionId: rxtransid.value,
  //         note: rxNote.value,
  //         timestamp: rxtimestamp.value));
  //   } else {
  //     enableBottom.value = true;
  //     DialogHelper.showErrorDialogNew(description: response['ResultCode']);
  //   }
  // }
}
